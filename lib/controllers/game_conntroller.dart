import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:copy_of_wordle/models/tile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  static const int _maxColumn = 4;
  static const int _maxRow = 5;
  var gameTable = [
    [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
    [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
    [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
    [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
    [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
    [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()]
  ];
  var gameText = "".obs;

  int _currentRow = 0;
  int _currentColumn = 0;

  RxInt refreshingVar = 0.obs;

  List<String> inTextLetters = <String>[];
  List<String> onPositionLetters = <String>[];
  List<String> notFoundLetters = <String>[];

  RxBool isGameWon = false.obs;

  RxBool wordNotFount = false.obs;
  List<String> wordList = [];

//initilizing game
  void init() {
    gameTable = _getTileModelList();
    gameText.value = "";
    _currentRow = 0;
    _currentColumn = 0;
    inTextLetters = <String>[];
    onPositionLetters = <String>[];
    notFoundLetters = <String>[];
    isGameWon.value = false;
    findText();
    isGameWon.value = false;
  }

// Keybord input to this method returning true if game won!!!
  addData(String data) {
    //debugPrint("Key pressed : '$data'  Enter  : ${data == "ENTER" && _currentColumn == _maxColumn && _currentRow < _maxRow}  BACKSPACE : ${data == "BACKSPACE" && _currentColumn != 0}  Letter : ${_currentColumn != _maxColumn + 1} ");
    if (data == "ENTER" && _currentColumn > _maxColumn) {
      if (!_chekIfStringIntheWordList()) {
        int noCurrectLetter = findColumnColorAfterNewLine();
        isGameWon.value = noCurrectLetter == _maxColumn + 1;
        _currentColumn = 0;
        if (_currentRow < _maxRow) {
          _currentRow++;
        }
      } else {
        debugPrint("Word not fount");
        wordNotFount.value = true;
      }
    } else if (data == "BACKSPACE" && _currentColumn != 0) {
      _currentColumn--;
      gameTable[_currentRow][_currentColumn].text = "";
    } else if (_currentColumn != _maxColumn + 1 && data.length == 1) {
      gameTable[_currentRow][_currentColumn].text = data;
      _currentColumn++;
    }
    refreshingVar++;
    return false;
  }

//set random text for game
  Future<void> findText() async {
    await _loadWords();
    int index = math.Random().nextInt(wordList.length);
    gameText = RxString(wordList[index].toString().toUpperCase());
    debugPrint("Game Text : $gameText");
  }

// returning count of how many correct guess
  int findColumnColorAfterNewLine() {
    int onPossitionCount = 0;
    for (int i = 0; i < gameTable[_currentRow].length; i++) {
      String letter = gameTable[_currentRow][i].text;
      if (gameText.substring(i, i + 1) == letter) {
        gameTable[_currentRow][i].columnType = LetterType.onPosition;
        onPositionLetters.add(letter);
        onPossitionCount++;
      } else if (gameText.contains(letter)) {
        gameTable[_currentRow][i].columnType = LetterType.inText;
        inTextLetters.add(letter);
      } else {
        notFoundLetters.add(letter);
      }
    }
    return onPossitionCount;
  }

  List<List<TileModel>> _getTileModelList() {
    return [
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()]
    ];
  }

  bool _chekIfStringIntheWordList() {
    String s = "";
    for (int i = 0; i < gameTable[_currentRow].length; i++) {
      s += gameTable[_currentRow][i].text;
    }
    log("TEXT FOUBND  $s :  ${wordList.contains(s)}");
    return !wordList.contains(s);
  }

  Future _loadWords() async {
    if (wordList.isEmpty) {
      String response =
          await rootBundle.loadString('assets/json/json_file.json');
      Map<String, dynamic> data = await json.decode(response);
      for (var a in data['words']) {
        if (a.runtimeType == String) wordList.add(a.toString().toUpperCase());
      }
    }
    log("words loaded ${wordList.length}");
  }
}
