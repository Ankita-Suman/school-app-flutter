import 'package:flutter/material.dart';
import '../theme/dimens.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsets10_0_10_0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate dashes based on screen width
          int dashCount = (constraints.maxWidth / 10).ceil();
          return Row(
            children: List.generate(
              dashCount,
                  (index) => Expanded(
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}