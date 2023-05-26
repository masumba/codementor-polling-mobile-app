import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/utils/emoji_remover_input_formatter.dart';
import 'package:mobile_app/utils/inner_trimmed_input_formatter.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/utils/shared_style_util.dart';
import 'package:mobile_app/widgets/note_text.dart';

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final bool isDisabled;
  final bool isFocus;
  final String? initialValue;
  final String placeholder;
  final String? validationMessage;
  final Function? enterPressed;
  final Function? onTap;
  final FormFieldValidator<String>? validator;
  final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;

  final TextCapitalization textCapitalization;

  /// The default of this is [textInputAction] is [TextInputAction.next] which will switch focus on submit to the next field in form.
  /// In order to close keyboard on submit switch value to [TextInputAction.done]
  final TextInputAction textInputAction;
  final String? additionalNote;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final List<TextInputFormatter>? inputFormattersOverrideList;
  final int? inputSize;
  final int maxLines;
  final int? minLines;
  final double inputFieldHeight;
  final AutovalidateMode? autoValidateMode;
  final Icon? prefixIcon;
  final Widget? suffixIcon;

  /// If [controller] and [initialValue] are set the initial value will be ignored
  const InputField(
      {required this.controller,
      required this.placeholder,
      this.autoValidateMode,
      this.initialValue,
      this.enterPressed,
      this.textCapitalization = TextCapitalization.sentences,
      this.onTap,
      this.isFocus = false,
      this.fieldFocusNode,
      this.nextFocusNode,
      this.additionalNote,
      this.onChanged,
      this.inputFormatters,
      this.inputFormattersOverrideList,
      this.validationMessage,
      this.validator,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.password = false,
      this.isReadOnly = false,
      this.isDisabled = false,
      this.smallVersion = false,
      this.inputSize,
      this.maxLines = 1,
      this.minLines,
      this.inputFieldHeight = 55,
      this.prefixIcon,
      this.suffixIcon,
      Key? key})
      : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool isPassword;
  late bool isReadOnly;
  double fieldHeight = 55;

  @override
  void initState() {
    isPassword = widget.password;

    if (widget.isDisabled) {
      isReadOnly = widget.isDisabled;
    } else {
      isReadOnly = widget.isReadOnly;
    }

    super.initState();
  }

  List<TextInputFormatter> _inputFieldFormattersList() {
    List<TextInputFormatter> inputFieldFormatters = [];
    if (!isPassword) {
      inputFieldFormatters.add(InnerTrimmedInputFormatter());
    }
    inputFieldFormatters.add(EmojiRemoverInputFormatter());

    inputFieldFormatters.addAll(widget.inputFormatters ?? []);

    return inputFieldFormatters;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inputFieldHeight > 100) {
      fieldHeight = widget.inputFieldHeight;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.smallVersion ? 40 : fieldHeight,
          alignment: Alignment.centerLeft,
          padding: SharedStyleUtil.fieldPadding,
          decoration: isReadOnly
              ? SharedStyleUtil.disabledFieldDecoration
              : SharedStyleUtil.fieldDecoration,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  autovalidateMode: widget.autoValidateMode,
                  autofocus: widget.isFocus,
                  initialValue: widget.initialValue == null
                      ? null
                      : widget.controller == null
                          ? widget.initialValue
                          : null,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.inputSize,
                  validator: widget.validator,
                  textCapitalization: widget.textCapitalization,
                  controller: widget.controller,
                  keyboardType: Platform.isIOS &&
                          widget.textInputType == TextInputType.number
                      ? const TextInputType.numberWithOptions(
                          signed: true, decimal: true)
                      : widget.textInputType,
                  focusNode: widget.fieldFocusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap as void Function()?,
                  inputFormatters: widget.inputFormattersOverrideList ??
                      _inputFieldFormattersList(),
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed!();
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode!.requestFocus();
                    }

                    if (widget.textInputAction == TextInputAction.next) {
                      FocusScope.of(context).nextFocus();
                    } else if (widget.textInputAction == TextInputAction.done) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  obscureText: isPassword,
                  readOnly: isReadOnly,
                  enabled: !widget.isDisabled,
                  style: widget.isDisabled
                      ? const TextStyle(color: Colors.grey)
                      : null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.placeholder,
                    hintStyle:
                        TextStyle(fontSize: widget.smallVersion ? 12 : 15),
                  ).copyWith(
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: widget.suffixIcon),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isPassword = !isPassword;
                }),
                child: widget.password
                    ? Container(
                        width: fieldHeight,
                        height: fieldHeight,
                        alignment: Alignment.center,
                        child: Icon(isPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) ScreenUtil.verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote),
        ScreenUtil.verticalSpaceSmall
      ],
    );
  }
}
