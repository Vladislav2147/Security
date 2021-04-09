import 'dart:math';

String intToHexByte(int value) {
  String result = (value % 256).toRadixString(16);
  if (result.length == 1) {
    result = "0" + result;
  }
  return result;
}

String intToBinaryByte(int value) {
  String result = (value % 256).toRadixString(2);
  if (result.length < 8) {
    String nulls = "";
    for (int i = 0; i < 8 - result.length; i++) {
      nulls += "0";
    }
    result = nulls + result;
  }
  return result;
}



String hexStringFromIntList(List<int> list) {
  String result = list.map(intToHexByte).join(" ").toUpperCase();
  return result;
}

double entropy(List<int> list) {
  String binaryString = list.map(intToBinaryByte).join("");
  print(binaryString);
  double prob0 = '0'.allMatches(binaryString).length / binaryString.length.toDouble();
  double prob1 = '1'.allMatches(binaryString).length / binaryString.length.toDouble();
  double entropy = -(prob0 * (log(prob0) / log(2)) + prob1 * (log(prob1) / log(2)));
  return entropy;
}
