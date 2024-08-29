// ignore_for_file: unused_field

import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'my_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateTextEditingController extends TextEditingController {
  String realText = '';

  DateTextEditingController() {
    addListener(() {
      final text = this.text;
      if (text.length > 10) {
        this.text = realText;
        return;
      }
      if (realText.isNotEmpty && realText[realText.length - 1] != '/') {
        if (text.length == 2 || text.length == 5) {
          this.text = '$text/';
        }
      }
      realText = this.text;
    });
  }
}

class MonthYearTextEditingController extends TextEditingController {
  String realText = '';

  MonthYearTextEditingController() {
    addListener(() {
      final text = this.text;
      if (text.length > 5) {
        this.text = realText;
        return;
      }
      if (realText.isNotEmpty && realText[realText.length - 1] != '/') {
        if (text.length == 2) {
          this.text = '$text/';
        }
      }
      realText = this.text;
    });
  }
}

class CreditCardTextEditingController extends TextEditingController {
  int spaces = 0;
  String realText = '';

  CreditCardTextEditingController() {
    addListener(() {
      final text = this.text;
      if (text.length > 19) {
        this.text = realText;
        return;
      }
      if (realText.isNotEmpty && realText[realText.length - 1] != ' ') {
        if (text.length == 4 || text.length == 9 || text.length == 14) {
          this.text = '$text ';
        }
      }
      realText = this.text;
    });
  }
}

class CountTextEditingController extends TextEditingController {
  final int count;

  CountTextEditingController({required this.count}) {
    addListener(() {
      if (text.length > count) {
        text = text.substring(0, text.length - 1);
      }
    });
  }
}

class BizneTextFormField extends StatefulWidget {
  final String hint;
  final bool suffixError;
  final bool isNumber;
  final TextAlign textAlign;
  final void Function() onSubmited;
  final TextEditingController controller;
  final String? Function(String? value) validator;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final TextInputAction textInputAction;
  final bool autoFocus;

  const BizneTextFormField(
      {super.key,
      required this.controller,
      required this.validator,
      this.autoFocus = false,
      this.textAlign = TextAlign.start,
      this.hint = '',
      this.suffixError = false,
      this.isNumber = false,
      this.maxLines = 1,
      required this.onSubmited,
      this.isPassword = false,
      this.suffixIcon,
      this.prefixIcon,
      this.textInputAction = TextInputAction.done});

  @override
  State<BizneTextFormField> createState() => BizneTextFormFieldState();

  static String? Function(String?) getRequiredValidator(BuildContext context) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.requiredField;
      }
      return null;
    };
  }
}

class BizneTextFormFieldState extends State<BizneTextFormField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String? errorText;
  bool visibilityOff = true;

  void _updateErrorState(String? value) {
    setState(() {
      errorText = widget.validator(value);
    });
  }

  bool validate() {
    _updateErrorState(widget.controller.text);

    return errorText == null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        cursorColor: AppThemes().secondary,
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onChanged: (String value) {
          _updateErrorState(value);
        },
        onTapOutside: (event) => setState(() {
              _isFocused = false;
            }),
        onFieldSubmitted: (value) {
          _isFocused = false;
          widget.onSubmited();
        },
        autofocus: widget.autoFocus,
        focusNode: _focusNode,
        onEditingComplete: () => _focusNode.nextFocus(),
        textAlign: widget.textAlign,
        controller: widget.controller,
        keyboardType:
            widget.isNumber ? TextInputType.number : TextInputType.text,
        validator: widget.validator,
        obscureText: widget.isPassword && visibilityOff,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            labelStyle: const TextStyle(
              fontFamily: 'Quicksand',
            ),
            hintStyle: const TextStyle(fontFamily: 'Quicksand'),
            suffixIcon: widget.isPassword
                ? ExcludeFocus(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            visibilityOff = !visibilityOff;
                          });
                        },
                        icon: Icon(
                            visibilityOff
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: errorText == null
                                ? AppThemes().secondary
                                : AppThemes().negative)))
                : widget.suffixError && errorText != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 1.w),
                        child: Image.asset('assets/icons/input_error.png',
                            scale: 1.8),
                      )
                    : widget.suffixIcon,
            suffixIconConstraints:
                BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
            prefixIcon: widget.prefixIcon,
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            fillColor: AppThemes().whiteInputs,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: AppThemes().borderRadius),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppThemes().secondary, width: 2),
                borderRadius: AppThemes().borderRadius),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppThemes().borderRadius,
                borderSide: const BorderSide(color: Colors.transparent)),
            errorBorder: OutlineInputBorder(
                borderRadius: AppThemes().borderRadius,
                borderSide: BorderSide(color: AppThemes().negative, width: 2)),
            hintText: _isFocused ? '' : widget.hint,
            errorText: errorText,
            errorStyle: TextStyle(
                fontFamily: 'Quicksand',
                color: AppThemes().negative,
                fontWeight: FontTypeWeight.getFontType(FontType.bold))));
  }
}

class BizneTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final String? hint;
  final bool isNumber;
  final int maxLines;
  final void Function() onSubmited;

  const BizneTextField(
      {super.key,
      this.isNumber = false,
      required this.controller,
      required this.onSubmited,
      this.hint,
      this.maxLines = 1,
      this.textAlign = TextAlign.start,
      this.prefixIcon,
      this.suffixIcon});

  @override
  State<BizneTextField> createState() => _BizneTextFieldState();
}

class _BizneTextFieldState extends State<BizneTextField> {
  bool _isFocused = false;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: widget.maxLines,
        keyboardType: widget.isNumber ? TextInputType.number : null,
        cursorColor: AppThemes().secondary,
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onTapOutside: (event) => setState(() {
              _isFocused = false;
            }),
        onFieldSubmitted: (value) {
          _isFocused = false;
          widget.onSubmited();
        },
        autofocus: false,
        focusNode: _focusNode,
        onEditingComplete: () => _focusNode.nextFocus(),
        textAlign: widget.textAlign,
        controller: widget.controller,
        decoration: InputDecoration(
            labelStyle: const TextStyle(
              fontFamily: 'Quicksand',
            ),
            hintStyle: const TextStyle(fontFamily: 'Quicksand'),
            suffixIcon: widget.suffixIcon,
            suffixIconConstraints:
                BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
            prefixIconConstraints:
                BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
            prefixIcon: widget.prefixIcon,
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            fillColor: AppThemes().whiteInputs,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: AppThemes().borderRadius),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppThemes().secondary, width: 2),
                borderRadius: AppThemes().borderRadius),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppThemes().borderRadius,
                borderSide: const BorderSide(color: Colors.transparent)),
            hintText: _isFocused ? '' : widget.hint));
  }
}

class BizneRequiredField extends StatefulWidget {
  final String hint;
  final bool suffixError;
  final TextEditingController controller;
  final bool isNumber;
  final TextAlign textAlign;
  final int maxLines;
  final String? Function(String? value) validator;
  final Function() onSubmited;
  const BizneRequiredField({
    super.key,
    required this.onSubmited,
    this.textAlign = TextAlign.start,
    required this.hint,
    required this.controller,
    required this.validator,
    this.suffixError = false,
    this.isNumber = false,
    this.maxLines = 1,
  });

  @override
  State<BizneRequiredField> createState() => BizneRequiredFieldState();
}

class BizneRequiredFieldState extends State<BizneRequiredField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  void _updateErrorState(String? value) {
    setState(() {
      _errorMessage = widget.validator(value);
    });
  }

  bool validate() {
    _updateErrorState(widget.controller.text);

    return _errorMessage == null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onTapOutside: (event) => setState(() {
              _isFocused = false;
            }),
        onChanged: (String value) {
          _updateErrorState(value);
        },
        onSubmitted: (value) {
          setState(() {
            _isFocused = false;
            _updateErrorState(value);
          });
          widget.onSubmited();
        },
        maxLines: widget.maxLines,
        autofocus: false,
        focusNode: _focusNode,
        onEditingComplete: () => _focusNode.nextFocus(),
        textAlign: widget.textAlign,
        controller: widget.controller,
        keyboardType:
            widget.isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            fontFamily: 'Quicksand',
          ),
          hintStyle: const TextStyle(fontFamily: 'Quicksand'),
          suffixIcon: widget.suffixError && _errorMessage != null
              ? Image.asset(
                  'assets/icons/input_error.png',
                  scale: 1.8,
                )
              : null,
          suffixIconConstraints: BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
          filled: true,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
          fillColor: AppThemes().whiteInputs,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: AppThemes().borderRadius),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppThemes().secondary, width: 2),
              borderRadius: AppThemes().borderRadius),
          enabledBorder: OutlineInputBorder(
              borderRadius: AppThemes().borderRadius,
              borderSide: const BorderSide(color: Colors.transparent)),
          errorBorder: OutlineInputBorder(
              borderRadius: AppThemes().borderRadius,
              borderSide: BorderSide(color: AppThemes().negative, width: 2)),
          hintText: widget.hint,
          errorStyle: TextStyle(
            fontFamily: 'Quicksand',
            color: AppThemes().negative,
            fontWeight: FontTypeWeight.getFontType(FontType.bold),
          ),
        ));
  }
}

class BizneRequiredFieldLogin extends StatefulWidget {
  final String hint;
  final bool suffixError;
  final TextEditingController controller;
  final bool isNumber;
  final TextAlign textAlign;
  final int maxLines;
  final int countOnSubmited;
  final String? Function(String? value) validator;
  final Function() onSubmited;
  const BizneRequiredFieldLogin(
      {super.key,
      this.textAlign = TextAlign.start,
      required this.hint,
      required this.controller,
      required this.validator,
      required this.onSubmited,
      this.suffixError = false,
      this.isNumber = false,
      this.maxLines = 1,
      required this.countOnSubmited});

  @override
  State<BizneRequiredFieldLogin> createState() =>
      BizneRequiredFieldLoginState();
}

class BizneRequiredFieldLoginState extends State<BizneRequiredFieldLogin> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage;

  void _updateErrorState(String? value) {
    setState(() {
      _errorMessage = widget.validator(value);
    });
  }

  bool validate() {
    _updateErrorState(widget.controller.text);

    return _errorMessage == null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.5.h,
          child: TextField(
              textInputAction: TextInputAction.next,
              onTap: () {
                setState(() {
                  _isFocused = true;
                });
              },
              onTapOutside: (event) => setState(() {
                    _isFocused = false;
                  }),
              onChanged: (String value) {
                if (value.length == widget.countOnSubmited) {
                  _focusNode.nextFocus();
                  widget.onSubmited();
                }
                _updateErrorState(value);
              },
              onSubmitted: (value) {
                setState(() {
                  _isFocused = false;
                  _updateErrorState(value);
                });

                widget.onSubmited();
              },
              maxLines: widget.maxLines,
              autofocus: false,
              focusNode: _focusNode,
              onEditingComplete: () => _focusNode.nextFocus(),
              textAlign: widget.textAlign,
              controller: widget.controller,
              keyboardType:
                  widget.isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  fontFamily: 'Quicksand',
                ),
                hintStyle: const TextStyle(fontFamily: 'Quicksand'),
                suffixIcon: widget.suffixError && _errorMessage != null
                    ? Image.asset(
                        'assets/icons/input_error.png',
                        scale: 1.8,
                      )
                    : null,
                suffixIconConstraints:
                    BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
                filled: true,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                fillColor: AppThemes().whiteInputs,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: AppThemes().borderRadius),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppThemes().secondary, width: 2),
                    borderRadius: AppThemes().borderRadius),
                enabledBorder: OutlineInputBorder(
                    borderRadius: AppThemes().borderRadius,
                    borderSide: const BorderSide(color: Colors.transparent)),
                errorBorder: OutlineInputBorder(
                    borderRadius: AppThemes().borderRadius,
                    borderSide:
                        BorderSide(color: AppThemes().negative, width: 2)),
                hintText: widget.hint,
                errorStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  color: AppThemes().negative,
                  fontWeight: FontTypeWeight.getFontType(FontType.bold),
                ),
              )),
        ),
        if (_errorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: MyText(
              text: _errorMessage!,
              color: AppThemes().negative,
              type: FontType.semibold,
            ),
          )
      ],
    );
  }
}

class BizneRequiredVisibilityField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  const BizneRequiredVisibilityField(
      {super.key, required this.controller, required this.validator});

  @override
  State<BizneRequiredVisibilityField> createState() =>
      BizneRequiredVisibilityFieldState();
}

class BizneRequiredVisibilityFieldState
    extends State<BizneRequiredVisibilityField> {
  String? _errorMessage;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  bool passwordVisibilityOff = true;

  void _updateErrorState(String? value) {
    setState(() {
      _errorMessage = widget.validator(value);
    });
  }

  bool validate() {
    _updateErrorState(widget.controller.text);

    return _errorMessage == null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: passwordVisibilityOff,
        obscuringCharacter: '*',
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        onTapOutside: (event) => setState(() {
              _isFocused = false;
            }),
        onChanged: (String value) {
          _updateErrorState(value);
        },
        onSubmitted: (value) {
          _isFocused = false;
          _updateErrorState(value);
        },
        controller: widget.controller,
        autofocus: false,
        focusNode: _focusNode,
        onEditingComplete: () => _focusNode.nextFocus(),
        decoration: InputDecoration(
            hintStyle: const TextStyle(fontFamily: 'Quicksand'),
            contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
            filled: true,
            isDense: true,
            fillColor: AppThemes().whiteInputs,
            suffixIconConstraints:
                BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
            suffix: SizedBox(
              height: 4.h,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    passwordVisibilityOff = !passwordVisibilityOff;
                  });
                },
                icon: Icon(
                    passwordVisibilityOff
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: _errorMessage == null
                        ? AppThemes().secondary
                        : AppThemes().negative),
              ),
            ),
            enabled: true,
            labelStyle: const TextStyle(
              fontFamily: 'Quicksand',
            ),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: AppThemes().borderRadius),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppThemes().secondary, width: 2),
                borderRadius: AppThemes().borderRadius),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppThemes().borderRadius,
                borderSide: const BorderSide(color: Colors.transparent)),
            errorBorder: OutlineInputBorder(
                borderRadius: AppThemes().borderRadius,
                borderSide: BorderSide(color: AppThemes().negative, width: 2)),
            errorText: _errorMessage,
            errorStyle: TextStyle(
              fontFamily: 'Quicksand',
              color: AppThemes().negative,
              fontWeight: FontTypeWeight.getFontType(FontType.bold),
            )));
  }
}
