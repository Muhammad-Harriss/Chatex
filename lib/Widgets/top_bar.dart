import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String barTitle;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final double? fontSize;

  const TopBar({
    super.key,
    required this.barTitle,
    this.fontSize,
    this.primaryAction,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      height: deviceHeight * 0.10,
      width: deviceWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          secondaryAction ?? const SizedBox(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    barTitle,
                    style: TextStyle(
                      fontSize: fontSize ?? 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          primaryAction ?? const SizedBox(),
        ],
      ),
    );
  }
}
