import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// The widget that allows multiple image selection. Then merges the images into a single image at completion.
class MultiImageCardSelector extends StatefulWidget {
  /// The file of the image( iMage being rendered in card).
  final File? imageFile;

  /// Callback function when an image is clicked.
  final Function(File?) onClick;

  /// The title of the widget.
  final String title;

  /// Whether to use the gallery or not.
  final bool useGallery;

  /// Whether to show the image or not.
  final bool showImage;

  /// Whether to allow camera or gallery selection.
  final bool allowCameraOrGallery;

  /// The number of images to be selected (Maximum).
  final int imageCount;

  /// The number of images in the gallery to be selected (Maximum).
  final int? galleryImageCount;

  final int compressionQuality;
  final int imageQuality;
  const MultiImageCardSelector({
    Key? key,
    required this.imageFile,
    required this.onClick,
    required this.title,
    this.useGallery = true,
    this.showImage = true,
    this.allowCameraOrGallery = false,
    this.imageCount = 1,
    this.galleryImageCount,
    this.imageQuality = 80,
    this.compressionQuality = 65,
  }) : super(key: key);

  @override
  State<MultiImageCardSelector> createState() => _MultiImageCardSelectorState();
}

class _MultiImageCardSelectorState extends State<MultiImageCardSelector> {
  final Logger _logger = Logger();
  bool useGallery = true;

  /// Function to merge images from multiple files into one.
  Future<File?> mergeFiles({List<File>? capturedImages}) async {
    File? file;
    if (capturedImages != null && capturedImages.isNotEmpty) {
      int defaultHeight = 0;
      int defaultWidth = 0;
      for (var capturedFile in capturedImages) {
        final image1 = img.decodeImage(capturedFile.readAsBytesSync())!;
        defaultHeight = max(image1.height, defaultHeight);
        defaultWidth = defaultWidth + image1.width;
      }

      final mergedImage = img.Image(defaultWidth, defaultHeight);

      for (var i = 0; i < capturedImages.length; i++) {
        final image1 = img.decodeImage(capturedImages[0].readAsBytesSync());
        final image2 = img.decodeImage(capturedImages[i].readAsBytesSync());
        if (i == 0) {
          img.copyInto(mergedImage, image1!, blend: false);
        } else {
          img.copyInto(mergedImage, image2!, dstX: image1!.width, blend: false);
        }
      }

      final documentDirectory = await getTemporaryDirectory();
      file = File("${documentDirectory.path}merged_image.jpg");
      file.writeAsBytesSync(img.encodeJpg(mergedImage));
    }

    return file;
  }

  /// Function to compress the file size of an image.
  Future<File?> compressFile({required File file}) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: widget.compressionQuality,
    );

    return result;
  }

  /// Function that's called when an image is clicked.
  Future<File?> onImageClick() async {
    File? newImageFile;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      maxWidth: 2000.0,
      maxHeight: 1000.0,
      source: useGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      newImageFile = File(pickedFile.path);

      String fileExtension = p.extension(pickedFile.path).replaceAll('.', '');
      if (fileExtension.toLowerCase().contains('heic') ||
          fileExtension.toLowerCase().contains('heif')) {
        final pImage = img.decodeImage(newImageFile.readAsBytesSync());
        final documentDirectory = await getTemporaryDirectory();
        newImageFile = File("${documentDirectory.path}thumbnail.png");
        newImageFile.writeAsBytesSync(img.encodeJpg(pImage!));
      }
    } else {
      debugPrint('No image selected.');
    }
    return newImageFile;
  }

  /// Indicates whether images are being merged.
  bool _isMerging = false;

  /// Returns an icon based on whether the gallery is being used or not.
  Widget imageIcon() {
    /*return widget.useGallery
        ? const Icon(FontAwesomeIcons.fileArrowUp)
        : const Icon(FontAwesomeIcons.camera);*/
    return Image.asset(AppImage.empty2);
  }

  /// Function to handle the image processing request.
  Future<void> processRequest() async {
    List<File> capturedImages = [];
    File? newImageFile;
    try {
      setState(() {
        _isMerging = true;
      });

      int index = widget.imageCount;
      if (useGallery && widget.galleryImageCount != null) {
        index = widget.galleryImageCount ?? widget.imageCount;
      }
      for (int i = 0; i < index; i++) {
        int imgNumber = i + 1;
        Fluttertoast.showToast(
          msg: 'Taking Image Number $imgNumber /$index',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        File? imageReturn = await onImageClick();
        if (imageReturn != null) {
          capturedImages.add(imageReturn);

          Fluttertoast.showToast(
            msg: 'Saving Image Number $imgNumber /$index',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          await Future.delayed(const Duration(seconds: 1));
        } else {
          return;
        }
      }

      if (capturedImages.isNotEmpty && capturedImages.length > 1) {
        Fluttertoast.showToast(
          msg: 'Merging Images',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        newImageFile = await mergeFiles(capturedImages: capturedImages);
      } else {
        newImageFile = capturedImages[0];
      }
      Fluttertoast.showToast(
        msg: 'Images Merged',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isMerging = false;
        widget.onClick(newImageFile);
      });
    } catch (e, s) {
      _logger.e(e.toString());
      _logger.e(s);
      Fluttertoast.showToast(
        msg: 'Failed Image Merge',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setState(() {
        _isMerging = false;
        newImageFile = null;
        widget.onClick(newImageFile);
      });
    }
  }

  /// Function to show a dialog for camera or gallery selection.
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cameraButton = TextButton(
      child: const Text(
        "User Camera",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        useGallery = false;
        processRequest();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget galleryButton = TextButton(
      child: const Text(
        "Use Gallery",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed: () {
        useGallery = true;
        Navigator.of(context).pop();
        processRequest();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Add Image"),
      content: const Text("Please select one of the options below."),
      actions: [
        cameraButton,
        galleryButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Overriding initState to set whether to use the gallery based on the widget's property.
  @override
  void initState() {
    useGallery = widget.useGallery;
    super.initState();
  }

  /// Building the widget.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: ScreenUtil.screenHeight(context) * 0.15,
          minWidth: double.infinity,
          maxHeight: ScreenUtil.screenHeightFraction(context, dividedBy: 2),
        ),
        child: Card(
          elevation: 2,
          child: ListTile(
            title: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 50,
                minHeight: 60,
                maxHeight:
                    ScreenUtil.screenHeightFraction(context, dividedBy: 2) *
                        0.7,
              ),
              child: _isMerging
                  ? const Icon(FontAwesomeIcons.hourglassHalf)
                  : widget.imageFile != null
                      ? widget.showImage
                          ? Image.file(
                              widget.imageFile!,
                              fit: BoxFit.contain,
                            )
                          : imageIcon()
                      : imageIcon(),
            ),
            subtitle: ListTile(
              title: AutoSizeText(
                widget.title.toTitleCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: AutoSizeText(
                  'Please click card to ${widget.useGallery ? 'upload' : 'capture'} ${widget.title.toTitleCase()} picture.'
                      .toTitleCase()),
              trailing: widget.imageFile != null
                  ? const Icon(
                      FontAwesomeIcons.circleCheck,
                      color: Colors.green,
                    )
                  : const Icon(FontAwesomeIcons.circle),
            ),
            onTap: () async {
              try {
                if (widget.allowCameraOrGallery) {
                  showAlertDialog(context);
                } else if (widget.useGallery) {
                  useGallery = true;
                  processRequest();
                } else {
                  useGallery = false;
                  processRequest();
                }
              } catch (e, s) {
                _logger.e(e);
                _logger.e(s);
              }
            },
          ),
        ),
      ),
    );
  }
}
