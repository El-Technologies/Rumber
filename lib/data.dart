// ignore_for_file: avoid_print

import 'package:glowstone/glowstone.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

var myBox = Hive.box("myBox");

String username = "";
late String userId;
bool isLoggedIn = false;
late int input, userIndex, nextUserIndex;
List scoreList = [],
    leaderboardList = [
      ["User1", 1000],
      ["User6", 700],
      ["User4", 700],
      ["User7", 600],
      ["User5", 700],
      ["User2", 900],
      ["User10", 350],
      ["User8", 500],
      ["User3", 800],
      ["User9", 400],
    ];
int highestScore = 200;

Colors colors = [
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.yellowAccent,
  Colors.purpleAccent,
  Colors.white,
  Colors.pinkAccent,
  Colors.grey[500],
  Colors.brown[400],
  Colors.cyanAccent,
  Colors.blueGrey[200],
  Colors.greenAccent,
  Colors.indigoAccent
] as Colors;

leaderboardColors(int index) {
  switch (index) {
    case (0):
      return const Color.fromARGB(255, 230, 174, 8);
    case (1):
      return const Color.fromARGB(255, 187, 185, 185);
    case (2):
      return const Color.fromARGB(255, 211, 113, 77);
    default:
      return const Color.fromARGB(255, 241, 110, 101);
  }
}

leaderboardPositions(int index) {
  switch (index) {
    case (0):
      return const Image(
        width: 30,
        height: 30,
        image: AssetImage("assets/images/crown.png"),
      );
    case (1):
      return const Image(
        width: 30,
        height: 30,
        image: AssetImage("assets/images/diamond.png"),
      );
    case (2):
      return const Image(
        width: 30,
        height: 30,
        image: AssetImage("assets/images/coins.png"),
      );
    default:
      return Text(
        (index + 1).toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
  }
}

connectToInternet(context) {
  return Center(
    child: Glowstone(
      radius: 20,
      velocity: 10,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow,
        ),
        child: const Center(
          child: Text(
            "Please connect to the internet",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
