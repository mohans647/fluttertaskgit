import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'custom_app_button.dart';



class CustomError extends StatelessWidget {
  const CustomError({
    super.key,
    required this.title,
    required this.subtitle,
    this.onClick,
    required this.image,
    this.buttonText,
  });

  final String title;
  final String subtitle;
  final String image;
  final String? buttonText;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 180,
                width: 180,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: appSecondaryColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColorPrimary,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              buttonText != null
                  ? AppButton(
                      title: buttonText!,
                      onPressed: onClick,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      borderRadius: 4.0,
                      textColor: Colors.white,
                      bgColor: appSecondaryColor,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
