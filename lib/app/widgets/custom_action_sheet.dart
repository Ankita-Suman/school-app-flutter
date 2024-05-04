import 'package:school_app/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// [BukiActionActionCupertino] widget show action sheet for IOS Devises.
///
class BukiActionActionCupertino extends StatelessWidget {
  const BukiActionActionCupertino({
    Key? key,
    @required this.buttons,
  }) : super(key: key);

  final List<Map<String, dynamic>>? buttons;

  @override
  Widget build(BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          ...List.generate(
            buttons!.length,
            (index) => (buttons![index]['isCancleButton'] as bool)
                ? Dimens.box0
                : CupertinoActionSheetAction(
                    child: Text(
                      buttons![index]['buttonName'] as String,
                      style: buttons![index]['textStyle'] != null
                          ? buttons![index]['textStyle'] as TextStyle
                          : Styles.primaryMed14,
                    ),
                    onPressed: buttons![index]['onTap'] as Function(),
                  ),
          ).toList(),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: const Text('Cancel'),
          onPressed: Get.back,
        ),
      );
}
