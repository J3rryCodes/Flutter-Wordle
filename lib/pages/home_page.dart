import 'package:copy_of_wordle/controllers/game_conntroller.dart';
import 'package:copy_of_wordle/widgets/game_board.dart';
import 'package:copy_of_wordle/widgets/keyboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
        title: const Text("COPY"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              const GameBoard(),
              _info(),
              const KeyboardLayout(),
              _playRealGame(),
            ],
          ),
          GetX<GameController>(builder: (controller) {
            if (controller.wordNotFount.isTrue) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Word not found")));
                controller.wordNotFount.value = false;
              });
              //controller.wordNotFount.value = false;
            }
            return controller.isGameWon.isTrue
                ? _dialog(controller)
                : const SizedBox();
          })
        ],
      )),
    );
  }

  Center _dialog(GameController controller) {
    return Center(
      child: Container(
        height: 130,
        width: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  spreadRadius: 0,
                  blurRadius: 1)
            ],
            color: Colors.black.withOpacity(0.1)),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "You Won the game",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.init();
                controller.refreshingVar++;
              },
              child: const Text("New Game"),
            )
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.grey,
          ),
          const SizedBox(width: 5),
          InkWell(
            onDoubleTap: () {
              launch(
                  "https://github.com/J3rryCodes/Flutter-Wordle/blob/main/assets/json/json_file.json");
            },
            child: const Text(
              "Only 21952 words are available, Some of them are not real words.",
              maxLines: 5,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _playRealGame() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launch("https://www.powerlanguage.co.uk/wordle/");
        },
        child: const Text(
          "Go to REAL GAME",
          maxLines: 5,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
