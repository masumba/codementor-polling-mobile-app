import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/utils/shared_style_util.dart';

/// A button that shows a busy indicator in place of title
class BusyButton extends StatefulWidget {
  final Color? enabledButtonColor;
  final Color? buttonTextColor;
  final Color? disabledButtonColor;
  final double buttonRadius;
  final bool busy;
  final String title;
  final void Function()? onPressed;
  final bool enabled;

  const BusyButton(
      {Key? key,
      required this.title,
      this.busy = false,
      required this.onPressed,
      this.enabled = true,
      this.enabledButtonColor,
      this.buttonTextColor,
      this.disabledButtonColor,
      this.buttonRadius = 5})
      : super(key: key);

  @override
  State<BusyButton> createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    Color? defaultEnabledColor = AppColor.primaryColorDark.toColor();
    Color? defaultDisabledColor = AppColor.dividerColor.toColor();
    if (widget.enabledButtonColor != null) {
      defaultEnabledColor = widget.enabledButtonColor;
    }

    if (widget.disabledButtonColor != null) {
      defaultDisabledColor = widget.enabledButtonColor;
    }

    return GestureDetector(
      onTap: !widget.busy && widget.enabled
          ? widget.onPressed
          : () {
              debugPrint('Button ${widget.title} Busy');
            },
      child: InkWell(
        child: AnimatedContainer(
          height: widget.busy ? 40 : MediaQuery.of(context).size.width * 0.1,
          width: widget.busy ? 40 : MediaQuery.of(context).size.width * 0.9,
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: widget.busy ? 10 : 15,
              vertical: widget.busy ? 10 : 10),
          decoration: BoxDecoration(
            color: widget.enabled ? defaultEnabledColor : defaultDisabledColor,
            borderRadius: BorderRadius.circular(widget.buttonRadius),
          ),
          child: !widget.busy
              ? Text(
                  widget.title,
                  style: widget.buttonTextColor == null
                      ? SharedStyleUtil.buttonTitleTextStyle
                      : TextStyle(
                          fontWeight: FontWeight.w700,
                          color: widget.buttonTextColor),
                )
              : const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        ),
      ),
    );
  }
}
