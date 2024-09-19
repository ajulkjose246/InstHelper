import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final String regexlabel;
  final RegExp regex;
  final Icon icon;
  final bool validator;
  final bool numberkeyboard;
  final double fontSize;

  const FormInputField({
    super.key,
    required this.textcontroller,
    required this.label,
    required this.validator,
    required this.icon,
    required this.regex,
    required this.regexlabel,
    required this.numberkeyboard,
    required this.fontSize,
  });

  final TextEditingController textcontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textcontroller,
        keyboardType:
            numberkeyboard ? TextInputType.number : TextInputType.text,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: fontSize),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          prefixIcon: icon, // Add your desired icon here
        ),
        validator: validator
            ? (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter The $label";
                }

                if (!regex.hasMatch(value)) {
                  return "Invalid $label format $regexlabel";
                }
                return null;
              }
            : null,
      ),
    );
  }
}
