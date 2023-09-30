import 'package:chat_app/core/constsnts/constsnts.dart';
import 'package:chat_app/core/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultTextFiled({
  required TextEditingController textEditingController,
  required String labelText,
  required String? Function(String?) validator,
  required bool isPassword,
  required IconData? prefixIcon,
  FocusNode? passwordFocusNode,
  IconData? suffixIcon,
  Function? onPressed,
}) {
  return TextFormField(
    keyboardType: TextInputType.name,
    obscureText: isPassword,
    controller: textEditingController,
    decoration: InputDecoration(
      prefixIcon: Icon(prefixIcon),
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      suffixIcon: suffixIcon != null
          ? IconButton(
              onPressed: () {
                onPressed!();
              },
              icon: Icon(suffixIcon),
            )
          : null,
    ),
    validator: (value) {
      return validator(value);
    },
  );
}

Widget defaultFlatButton(
    {required String text, required Function onPressed, double? width}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: buttonHeight,
    child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(text)),
  );
}

Widget defaultElevatedButton(
    {required String text,
    required Function onPressed,
    double? width,
    Color? backgroundColor,
    Color? textColor}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: buttonHeight,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,

          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        onPressed: () {
          onPressed();
        },

        child: Text(text)),
  );
}

Widget defaultOutlinedButton(
    {required String text, required Function onPressed, double? width}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: buttonHeight,
    child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
                color: secLightColor!, width: 2, style: BorderStyle.solid),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(text)),
  );
}

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

defaultErrorToast({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

defaultSuccessToast({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}
