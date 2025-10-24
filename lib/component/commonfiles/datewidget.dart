
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget datePickerFormField({
  required String labelText,
  required TextEditingController controller,
  required BuildContext context,
}) {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  return Row(
    children: [
      Text(labelText),
      SizedBox(width: 8),
      GestureDetector(
        onTap: () {
          _selectDate(context);
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'DOB',
              hintStyle: TextStyle(color:Colors.lime ),
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.lightBlue,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            readOnly: true,
          ),
        ),
      ),
    ],
  );
}