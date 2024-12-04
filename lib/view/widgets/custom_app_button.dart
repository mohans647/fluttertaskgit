
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final double? width;
  final Color bgColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final double height;
  final bool isBoxShadow;
  final String? image;
  final FontWeight fontWeight;
  final bool isBorder;
  final Color? imageColor;
  const AppButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.width,
    this.bgColor = appColor,
    this.fontSize = 18,
    this.borderRadius = 10.0,
    this.height = 50,
    this.isBoxShadow = true,
    this.image,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.isBorder = false,
    this.imageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isBorder ? Colors.white : bgColor,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(
        borderRadius,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
        customBorder: isBorder
            ? Border.all(
                color: bgColor,
              )
            : null,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(
            horizontal: 3.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            border: isBorder
                ? Border.all(
                    color: bgColor,
                  )
                : null,
            // boxShadow: isBoxShadow
            //     ? const [
            //         BoxShadow(
            //           color: Colors.black38,
            //           offset: Offset(
            //             5,
            //             5,
            //           ),
            //           blurRadius: 5.0,
            //         ),
            //       ]
            //     : null,
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image != null
                    ? Image.asset(
                        image!,
                        height: 20,
                        width: 20,
                        color: imageColor,
                      )
                    : const SizedBox.shrink(),
                image != null
                    ? const SizedBox(
                        width: 10,
                      )
                    : const SizedBox.shrink(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: isBorder ? bgColor : textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
