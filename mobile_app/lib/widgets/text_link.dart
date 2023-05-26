import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final TextAlign? textAlign;
  final TextStyle? style;

  const TextLink(
      {Key? key, this.text, this.onPressed, this.textAlign, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Text(
        text!,
        textAlign: textAlign,
        style:
            style ?? const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}
