import 'package:flutter/material.dart';
import 'package:consulting_platform/flutter_gen/gen_l10n/app_localizations.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.labelText,
    this.validator,
    this.onChanged,
    this.controller,
    this.errorText,
    this.maxLines = 1,
    this.isValid = true,
    this.obscure = false,
    this.keyboard = TextInputType.text,
  }) : super(key: key);

  final String labelText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextEditingController? controller;
  final String? errorText;
  final int? maxLines;
  final bool isValid;
  final bool obscure;
  final TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: TextFormField(
        minLines: 1,
        maxLines: maxLines,
        keyboardType: keyboard,
        obscureText: obscure,
        controller: controller,
        onChanged: onChanged,
        validator: isValid
            ? validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.not_empty;
                  }
                  return null;
                }
            : null,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
