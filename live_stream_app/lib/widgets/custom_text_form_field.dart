import 'package:flutter/material.dart';
import 'package:live_stream_app/utils/validator.dart';
import 'package:live_stream_app/widgets/responsive_ui.dart';

enum InputType { email, password, phone, text }

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final TextEditingController? textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  late double _width;
  late double _pixelRatio;
  bool large = true;
  bool medium = false;
  bool? isRequired;
  InputType? inputType;

  CustomTextFormField({
    Key? key,
    required this.hint,
    this.textEditingController,
    required this.keyboardType,
    required this.icon,
    this.inputType,
    this.obscureText = false,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        keyboardType: keyboardType,
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange[200], size: 20),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (isRequired == true) {
            String result = _validateInputText(
                type: inputType ?? InputType.text, value: value ?? '');
            if (result != '') {
              return result;
            }
            return null;
          }
          return null;
        },
      ),
    );
  }

  String _validateInputText({required InputType type, required String value}) {
    String result = '';
    switch (type) {
      case InputType.email:
        if (value.isEmpty || !emailRegExp.hasMatch(value)) {
          result = 'Invalid email';
        }
        break;
      case InputType.text:
        if (value.isEmpty) {
          result = 'Invalid this field';
        }
        break;
      case InputType.phone:
        if (value.isEmpty || !phoneRegExp.hasMatch(value)) {
          result = 'Invalid phone';
        }
        break;
      case InputType.password:
        if (value.isEmpty || passwordRegExp.hasMatch(value)) {
          result = 'Invalid password';
        }
        break;
    }
    return result;
  }
}
