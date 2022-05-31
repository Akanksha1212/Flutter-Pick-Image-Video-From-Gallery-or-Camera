import 'package:flutter/material.dart';
import 'package:imagepicker/utils/size_config.dart';

class Button extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const Button({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: double.infinity,
      height: getPropotionateScreenHeight(80),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: getPropotionateScreenWidth(50.0),
              fontFamily: "BebasNeue",
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
