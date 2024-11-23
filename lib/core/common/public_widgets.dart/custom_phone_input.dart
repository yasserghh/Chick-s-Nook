import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/styles_manager.dart';

Widget getCustomPhoneInput(
    {required String hint,
    required String? Function(String?)? validator,
    required void Function(PhoneNumber)? onInputChanged}) {
  return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorManager.grey2, borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: InternationalPhoneNumberInput(
          formatInput: false,
          countries: const ['DZ'],
          validator: validator,
          hintText: hint,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.right,
          textStyle:
              getSemiBoldStyle(16, ColorManager.primary, FontsConstants.cairo),
          inputDecoration: InputDecoration(
              constraints: const BoxConstraints(maxHeight: 60, minHeight: 60),
              contentPadding: const EdgeInsets.only(bottom: 5),
              errorStyle:
                  getRegularStyle(10, ColorManager.reed, FontsConstants.cairo),
              hintText: hint,
              border: InputBorder.none,
              hintStyle: getSemiBoldStyle(
                  14, ColorManager.greyBlue, FontsConstants.cairo)),
          onInputChanged: onInputChanged,
        ),
      ));
}
