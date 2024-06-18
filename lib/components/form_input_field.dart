import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final bool validator;

  const FormInputField({
    super.key,
    required this.textcontroller,
    required this.label,
    required this.validator,
  });

  final TextEditingController textcontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textcontroller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        validator: validator
            ? (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter The $label";
                }
                return null;
              }
            : null,
      ),
    );
  }
}
