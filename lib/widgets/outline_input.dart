import 'package:flutter/material.dart';

import 'package:agenda/utils/constants.dart';

class MyInputValidator {
  final bool Function(String value) condition;
  final String errorMessage;
  MyInputValidator({
    required this.condition,
    required this.errorMessage,
  });
}

InputDecoration myInputDecoration(MyOutlineInput widget, bool hasError) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    suffixIconColor: AppColors.secondary,
    suffixIcon: widget.suffixIcon,
    labelText: widget.labelText,
    counterText: '',
    hintText: widget.hintText,
    labelStyle: TextStyle(
      color: hasError ? AppColors.error : AppColors.secondary,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: AppColors.secondary,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: AppColors.primary,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: AppColors.error,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorStyle: TextStyle(
      color: AppColors.error,
    ),
    errorText: hasError ? widget.controller.validator?.errorMessage : null,
  );
}

class MyTextEditingController extends TextEditingController {
  MyInputValidator? validator;
  MyTextEditingController({this.validator});

  final ValueNotifier<bool> hasErrorNotifier = ValueNotifier<bool>(false);

  bool get hasError => hasErrorNotifier.value;

  set hasError(bool value) {
    hasErrorNotifier.value = value;
  }

  bool validate() {
    if (validator != null) {
      if (validator!.condition(text)) {
        hasError = false;
      } else {
        hasError = true;
      }
    }
    return !hasError;
  }
}

class MyOutlineInput extends StatefulWidget {
  final MyTextEditingController controller;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String labelText;
  final String hintText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final MyInputValidator? validator;
  const MyOutlineInput({
    required this.controller,
    this.maxLength,
    this.keyboardType,
    this.obscureText,
    required this.labelText,
    required this.hintText,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    super.key,
  });

  @override
  State<MyOutlineInput> createState() => _MyOutlineInputState();
}

class _MyOutlineInputState extends State<MyOutlineInput> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.controller.hasErrorNotifier,
      builder: (context, hasError, _) {
        return TextField(
          controller: widget.controller,
          maxLines: null,
          autocorrect: false,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          obscureText: widget.obscureText != null ? widget.obscureText! : false,
          onChanged: widget.onChanged,
          cursorColor: AppColors.secondary,
          onEditingComplete: () => widget.controller.validate()
              ? FocusScope.of(context).nextFocus()
              : null,
          decoration: myInputDecoration(widget, hasError),
        );
      },
    );
  }
}

class MyOutlineDropdown<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String? errorMessage;
  const MyOutlineDropdown({
    this.value,
    required this.labelText,
    this.items,
    this.onChanged,
    this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items ?? [],
      onChanged: onChanged,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      style: TextStyle(
        color: AppColors.primary,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        suffixIconColor: AppColors.secondary,
        labelText: labelText,
        labelStyle: TextStyle(
          color: errorMessage != null ? AppColors.error : AppColors.secondary,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.secondary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
        ),
        errorText: errorMessage,
      ),
    );
  }
}
