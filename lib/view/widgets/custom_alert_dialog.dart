import 'dart:ui';


import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    this.isError = false,
    this.onContinue,
    this.wantAction = false,
    this.buttonText = "Continue",
  }) : super(key: key);

  final String title, description;
  final bool isError;
  final Function()? onContinue;
  final bool wantAction;
  final String buttonText;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return
      BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 4,
        sigmaY: 3,
      ),
      child: Dialog(
        elevation: 10,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Text(
              widget.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: Center(
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: widget.isError ? Colors.red : appGreenColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(
              height: 2,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: widget.wantAction
                    ? widget.onContinue
                    : () {
                        // Navigator.of(context).pop();
                      },
                child: Center(
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: appColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
