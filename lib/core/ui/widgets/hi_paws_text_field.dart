import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsTextField extends StatelessWidget {
  const HiPawsTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: HiPawsTextStyles.body
                .copyWith(color: HiPawsColors.textSecondary.withOpacity(0.6)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(HiPawsSpacing.textFieldBorderRadius),
              borderSide: const BorderSide(color: HiPawsColors.fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(HiPawsSpacing.textFieldBorderRadius),
              borderSide: const BorderSide(color: HiPawsColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(HiPawsSpacing.textFieldBorderRadius),
              borderSide: const BorderSide(
                  color: HiPawsColors.primaryOrange, width: 1.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ],
    );
  }
}
