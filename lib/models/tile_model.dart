enum LetterType { onPosition, inText, notFound }

class TileModel {
  String text = "";
  LetterType columnType = LetterType.notFound;
}
