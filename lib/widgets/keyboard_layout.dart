import 'package:copy_of_wordle/controllers/game_conntroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardLayout extends StatelessWidget {
  const KeyboardLayout({Key? key}) : super(key: key);
  static const List<List<String>> _keyboard = [
    ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
    ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
    ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "BACKSPACE"]
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _keyboard[0].map((e) => _button(width, e)).toList()),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _keyboard[1].map((e) => _button(width, e)).toList()),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _keyboard[2].map((e) => _button(width, e)).toList()),
        ],
      ),
    );
  }

  Widget _button(double width, String text) {
    // this paramiter will check if its ENTER or BACKSPACE
    bool isSpecialButton = text.length > 1;
    final double buttonWidth = width > 900
        ? 80
        : isSpecialButton
            ? width / 8
            : width / 12;
    final double buttonHeight = width > 820 ? 80 : width / 12;
    return GetX<GameController>(builder: (gameController) {
      debugPrint(gameController.refreshingVar.toString());

      bool shouldRejectText = false;
      Color color = Colors.pink;
      if (gameController.onPositionLetters.contains(text)) {
        color = Colors.green;
      } else if (gameController.inTextLetters.contains(text)) {
        color = Colors.orange;
      } else if (gameController.notFoundLetters.contains(text)) {
        color = Colors.transparent;
        shouldRejectText = true;
      }
      return InkWell(
        onTap: () {
          if (!shouldRejectText) {
            if (gameController.addData(text)) {
              Get.defaultDialog(title: "", middleText: "Game Won");
            }
          }
        },
        child: Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
              border: Border.all(color: Colors.white)),
          margin: const EdgeInsets.all(2),
          alignment: Alignment.center,
          child: text == "BACKSPACE"
              ? const Icon(Icons.backspace_outlined, color: Colors.white)
              : Text(text, style: const TextStyle(color: Colors.white)),
        ),
      );
    });
  }
}
