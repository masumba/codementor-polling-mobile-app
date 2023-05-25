import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/utils/screen_util.dart';

class ImageUploadCardSelector extends StatefulWidget {
  final File? imageFile;
  final String? placeHolderUrl;
  final Function(File?) onClick;
  final String title;
  final bool removeInstructionText;
  final int debounceTimeMs;
  final double? filePlaceHolderHeight;
  final double? fontSize;

  const ImageUploadCardSelector({
    Key? key,
    required this.imageFile,
    required this.onClick,
    required this.title,
    this.placeHolderUrl,
    this.removeInstructionText = false,
    this.debounceTimeMs = 200,
    this.filePlaceHolderHeight,
    this.fontSize,
  }) : super(key: key);

  @override
  State<ImageUploadCardSelector> createState() =>
      _ImageUploadCardSelectorState();
}

class _ImageUploadCardSelectorState extends State<ImageUploadCardSelector> {
  final AlertService _alertService = AlertService();
  ValueNotifier<bool> _isEnabled = ValueNotifier<bool>(true);
  final Logger _logger = Logger();
  Timer? _timer;
  late final Duration _duration;
  double minFontSize = 8;

  @override
  void initState() {
    _duration = Duration(milliseconds: widget.debounceTimeMs);
    minFontSize = widget.fontSize ?? 16 / 2;
    super.initState();
    _isEnabled = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isEnabled,
      builder: (context, isEnabled, child) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          constraints: BoxConstraints(
              minHeight: ScreenUtil.screenHeight(context) * 0.15,
              minWidth: double.infinity,
              maxHeight: ScreenUtil.screenHeight(context) * 0.9),
          child: Card(
            elevation: 2,
            child: ListTile(
              title: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 50,
                  minHeight: 60,
                  maxHeight: 200,
                ),
                child: widget.imageFile != null
                    ? Image.file(
                        widget.imageFile!,
                        fit: BoxFit.contain,
                        height: widget.filePlaceHolderHeight,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.placeHolderUrl ?? '',
                        placeholder: (context, url) => Image.asset(
                          AppImage.logo,
                          fit: BoxFit.fitHeight,
                          height: widget.filePlaceHolderHeight,
                        ),
                        height: widget.filePlaceHolderHeight,
                        errorWidget: (context, url, error) => Image.asset(
                          AppImage.logo,
                          fit: BoxFit.fitHeight,
                          height: widget.filePlaceHolderHeight,
                        ),
                      ),
              ),
              subtitle: ListTile(
                title: AutoSizeText(
                  widget.removeInstructionText
                      ? widget.title.toTitleCase()
                      : 'Please click card to upload ${widget.title.toTitleCase()} picture.'
                          .toTitleCase(),
                  style: TextStyle(fontSize: widget.fontSize),
                ),
                trailing: widget.imageFile != null
                    ? const Icon(
                        FontAwesomeIcons.circleCheck,
                        color: Colors.green,
                      )
                    : const Icon(FontAwesomeIcons.circle),
              ),
              onTap: () async {
                _isEnabled.value = false;
                try {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    maxHeight: 480.0,
                    maxWidth: 680.0,
                    source: ImageSource.camera,
                    imageQuality: 60,
                  );
                  if (pickedFile != null) {
                    File newImageFile = File(pickedFile.path);
                    widget.onClick(newImageFile);
                  } else {
                    debugPrint('No image selected.');
                    if (context.mounted) {
                      _alertService.show(
                          message: 'Failed to take image.',
                          type: AlertType.error,
                          context: context);
                    }
                  }
                } catch (e, s) {
                  _logger.e('Image Capture Failure', e, s);
                  _logger.wtf(s);
                  widget.onClick(null);
                  _alertService.show(
                      message: 'Failed to load image.',
                      type: AlertType.error,
                      context: context);
                }
                _timer = Timer(_duration, () => _isEnabled.value = true);
              },
            ),
          ),
        ),
      ),
    );
  }
}
