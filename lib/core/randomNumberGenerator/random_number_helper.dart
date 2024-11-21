import 'dart:math';

///Description
///Create a random number. Note max value is not inside the number range.
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes:
///https://stackoverflow.com/questions/11674820/how-do-i-generate-random-numbers-in-dart
abstract class GenerateRandomNumber {
  static int generateRandomNumber({required int min, required int max}) {
    return min + Random().nextInt(max - min);
  }
}
