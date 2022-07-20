// ignore_for_file: avoid_print

import 'dart:io';

class Data {
  List<List> scoreList = [];
  String s = "";

  Future<void> storeScores(List<List> listOfScoresAndTimes) async {
    String scores = "", times = "";

    for (var score in listOfScoresAndTimes) {
      scores += "${score[0].toString()} ";
    }

    for (var score in listOfScoresAndTimes) {
      times += "${score[1].toString()}  ";
    }

    File('store/scoresAsString').writeAsString(scores);
    File('store/timesAsString').writeAsString(times);

  }

  Future<List> getScores() async {
    String scores = "", times = "";

    File scoreFile = File('store/scoresAsString');
    scores = await scoreFile.readAsString();

    File timeFile = File('store/timesAsString');
    times = await timeFile.readAsString();


    for (int i = 0; i < scores.split(" ").length; i++) {
      List<String> scorelist = scores.split(" ");
      String score = scorelist[i].toString();
      String time = times.split("  ")[i].toString();
      List list = [score, time];
      scoreList.add(list);
    }

    scoreList.removeLast();

    return scoreList;

  }

  List<List> assignScores() {
    return scoreList;
  }
}

Future<void> main() async {
  List<List> scorelist = [[112, "12:34"], [222, "56:78"], [333, "91:01"]];

  Data data = Data();
  data.storeScores(scorelist);

  List s = await data.getScores();
  print(s);
}