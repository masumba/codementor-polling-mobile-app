import 'package:flutter/material.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/utils/screen_util.dart';

class FormFieldBlock extends StatelessWidget {
  final List<FormFieldWidget> children;

  const FormFieldBlock({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}

class FormFieldWidget extends StatelessWidget {
  final bool isVisible;
  final bool overrideWidget;
  final String title;
  final TextStyle? titleTextStyle;
  final TextAlign? titleTextAlign;
  final Widget child;
  const FormFieldWidget({
    Key? key,
    required this.title,
    this.titleTextStyle,
    this.titleTextAlign,
    required this.child,
    this.isVisible = true,
    this.overrideWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return overrideWidget
        ? isVisible
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                child: child,
              )
            : Container()
        : _renderDefault();
  }

  Widget _renderDefault() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isVisible
          ? [
              ScreenUtil.verticalSpaceTiny,
              Text(
                title.toTitleCase(),
                style: titleTextStyle ??
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: titleTextAlign,
              ),
              ScreenUtil.verticalSpaceTiny,
              child,
              ScreenUtil.verticalSpaceNormal,
            ]
          : [],
    );
  }
}
