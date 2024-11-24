import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Function()? ontap;
  final String? labelText;
  final TextEditingController controller;
  final TextInputFormatter? format;
  final TextInputType? type;
  final Icon? prefixIcon;
  final String? suffixText;
  final bool? readOnly;
  final bool? datePicker;
  final int? minLines;
  final int? maxLines;
  final String? hintText;
  final bool? focus;
  final TextInputAction? action;
  const CustomTextField({super.key, this.ontap, this.labelText, required this.controller, this.format, this.type, this.prefixIcon, this.readOnly, this.datePicker, this.minLines, this.maxLines, this.action, this.hintText, this.focus, this.suffixText});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    child: TextField(
      inputFormatters: format!=null?[format!]:[],
      keyboardType: type,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: action,
      autofocus: focus!=null?true:false,
      controller: controller,
      decoration: InputDecoration(
        suffixText: suffixText,
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      readOnly: (readOnly ?? false),
      onTap: ontap,
    ),
  );
  }
}
