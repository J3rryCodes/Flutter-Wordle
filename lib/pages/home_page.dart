import 'package:copy_of_wordle/controllers/game_conntroller.dart';
import 'package:copy_of_wordle/widgets/game_board.dart';
import 'package:copy_of_wordle/widgets/keyboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var gameController = Get.put(GameController());

  @override
  void initState() {
    gameController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: const [GameBoard(), KeyboardLayout()],
      )),
    );
  }
}
