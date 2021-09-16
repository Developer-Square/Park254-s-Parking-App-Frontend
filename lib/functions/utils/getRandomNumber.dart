import 'dart:math';

getRandomNumber() {
  Random rng = new Random();
  List<String> randomList =
      new List<String>.generate(4, (_) => rng.nextInt(100).toString());
  return randomList.join();
}
