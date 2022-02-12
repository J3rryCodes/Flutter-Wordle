import 'dart:developer';

import 'package:copy_of_wordle/controllers/game_conntroller.dart';
import 'package:copy_of_wordle/models/tile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double height = 450;
    final double width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: GetX<GameController>(builder: (controller) {
          log(controller.refreshingVar.toString());
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.gameTable
                  .map(
                    (row) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.map((data) => _textField(data)).toList(),
                    ),
                  )
                  .toList()
                  .toList());
        }),
      ),
    );
  }

  Widget _textField(TileModel data) {
    Color color = Colors.transparent;
    switch (data.columnType) {
      case LetterType.onPosition:
        color = Colors.green;
        break;
      case LetterType.inText:
        color = Colors.orange;
        break;
      default:
        break;
    }
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(4),
          color: color),
      alignment: Alignment.center,
      child: Text(
        data.text,
        style: const TextStyle(
            color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
  }
}
