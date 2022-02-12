import 'package:copy_of_wordle/models/tile_model.dart';
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

  RxInt test = 0.obs;

//initilizing game
  void init() {
    gameTable = [
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()],
      [TileModel(), TileModel(), TileModel(), TileModel(), TileModel()]
    ];
    gameText = RxString("");
    _currentRow = 0;
    _currentColumn = 0;
    test = RxInt(0);
    findText();
  }

// Keybord input to this method
  void addData(String data) {
    //debugPrint("Key pressed : '$data'  Enter  : ${data == "ENTER" && _currentColumn == _maxColumn && _currentRow < _maxRow}  BACKSPACE : ${data == "BACKSPACE" && _currentColumn != 0}  Letter : ${_currentColumn != _maxColumn + 1} ");
    if (data == "ENTER" && _currentColumn > _maxColumn) {
      findColumnColorAfterNewLine();
    }

    if (data == "ENTER" &&
        _currentColumn > _maxColumn &&
        _currentRow < _maxRow) {
      _currentRow++;
      _currentColumn = 0;
    } else if (data == "BACKSPACE" && _currentColumn != 0) {
      _currentColumn--;
      gameTable[_currentRow][_currentColumn].text = "";
    } else if (_currentColumn != _maxColumn + 1 && data.length == 1) {
      gameTable[_currentRow][_currentColumn].text = data;
      _currentColumn++;
    }
    test++;
  }

//set random text for game
  void findText() {
    gameText = RxString("SKILL");
  }

  findColumnColorAfterNewLine() {
    for (int i = 0; i < gameTable[_currentRow].length; i++) {
      String letter = gameTable[_currentRow][i].text;
      if (gameText.substring(i, i + 1) == letter) {
        gameTable[_currentRow][i].columnType = LetterType.onPosition;
      } else if (gameText.contains(letter)) {
        gameTable[_currentRow][i].columnType = LetterType.inText;
      }
    }
  }
}
