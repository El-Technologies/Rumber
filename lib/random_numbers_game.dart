import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:rumber/data.dart';
import 'package:rumber/score_board.dart';
import 'package:rumber/main.dart';
import 'package:showcaseview/showcaseview.dart';

final formatCurrency = NumberFormat("#,###");
late int highestBalance;
late int animatedHighestBalance;

class StartGame extends StatefulWidget {
  const StartGame({Key? key}) : super(key: key);

  @override
  State<StartGame> createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  late List randomNumbers;
  bool display = false,
      play = true,
      newBal = false,
      scoreMessage = true,
      entered = false;
  int numberOfOccurrence = 0,
      initBalance = 200,
      balance = 200,
      animatedBalance = 200;

  bool playedMoneySong = false, hasShownShowCaseView = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    if (myBox.get("hasShownShowCaseView") == null) {
      myBox.put("hasShownShowCaseView", false);
    }
    hasShownShowCaseView = myBox.get("hasShownShowCaseView");
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  void generateRandomNumbers() {
    Random random = Random();
    numberOfOccurrence = 0;
    setState(() {
      randomNumbers = List.generate(5, (_) => 1 + random.nextInt(9));
    });
  }

  randomNumberColor(int randNumber) {
    return (randNumber == input) ? Colors.green : Colors.red;
  }

  Widget displayResult(context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Chosen Number",
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Card(
                              elevation: 10,
                              color: Colors.orangeAccent,
                              shadowColor: Colors.red,
                              shape: const CircleBorder(),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 23),
                                child: Text(
                                  "$input",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Random Numbers",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Card(
                              color: randomNumberColor(randomNumbers[0]),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 13, 10, 13),
                                child: Text(
                                  "${randomNumbers[0]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Card(
                              color: randomNumberColor(randomNumbers[1]),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 13),
                                child: Text(
                                  "${randomNumbers[1]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Card(
                              color: randomNumberColor(randomNumbers[2]),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 13),
                                child: Text(
                                  "${randomNumbers[2]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Card(
                              color: randomNumberColor(randomNumbers[3]),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 13),
                                child: Text(
                                  "${randomNumbers[3]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Card(
                              color: randomNumberColor(randomNumbers[4]),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 13),
                                child: Text(
                                  "${randomNumbers[4]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              winOrLose(),
            ],
          ),
        ),
        if (!play)
          SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shadowColor: Colors.red,
                    padding: const EdgeInsets.all(15),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowCaseWidget(
                          builder: Builder(
                            builder: (_) => const LeaderBoard(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View Scores",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartGame()));
                    highestBalance = 200;
                    animatedHighestBalance = 200;
                  },
                  child: const Text(
                    "Play Again",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MenuPage()));
                  },
                  child: const Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  AlertDialog gameOver = const AlertDialog(
    backgroundColor: Colors.red,
    title: Text(
      "Game Over!",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.yellow,
        fontSize: 50,
      ),
    ),
    content: Text(
      "You can view your scores or keep playing. "
      "Play as many times as you can till 8pm tomorrow\n",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    ),
  );

  Future<void> animateB(int amount) async {
    for (int i = 0; i < amount.abs(); i++) {
      await Future.delayed(
          const Duration(microseconds: 500),
          () => (amount > 0)
              ? setState(() {
                  animatedBalance++;
                })
              : setState(() {
                  animatedBalance--;
                }));
    }
  }

  Future<void> animateHB(int amount) async {
    for (int i = 0; i < amount.abs(); i++) {
      await Future.delayed(
          const Duration(microseconds: 500),
          () => (amount > 0)
              ? setState(() {
                  animatedHighestBalance++;
                })
              : setState(() {
                  animatedHighestBalance--;
                }));
    }
  }

  void updateBalance(size, context) {
    if (numberOfOccurrence == 0) {
      if (balance - 100 >= 0) {
        if (balance - 100 > 50) {
          AudioCache player = AudioCache();
          player.play("effects/bruh_proper.mp3");
        }
        balance -= 100;
        animateB(-100);
      } else {
        AudioCache player = AudioCache();
        player.play("effects/untitled3_12.mp3");
        play = false;
        List scoreData = [
          highestBalance,
          DateFormat('hh : mm a').format(DateTime.now())
        ];

        for (int i = 0; i < scoreList.length; i++) {
          if (scoreList[i][0] == (highestBalance)) {
            scoreList.removeAt(i);
            showDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    showClickOutsideMessage(context);
                  },
                  child: updatedDuplicated,
                );
              },
            );
            break;
          }
        }

        scoreList.add(scoreData);
        myBox.put("scores", scoreList);

        if ((highestBalance > highestScore)) {
          final docUser =
              FirebaseFirestore.instance.collection("players").doc(userId);
          highestScore = highestBalance;
          myBox.put("highestScore", highestScore);
          docUser.update({"score": highestScore});

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  showClickOutsideMessage(context);
                },
                child: newHighScore,
              );
            },
          );
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                showClickOutsideMessage(context);
              },
              child: gameOver,
            );
          },
        );
      }

      if (balance <= 50 && play) {
        AudioCache player = AudioCache();
        player.play("effects/watchout_159RfBh.mp3");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                showClickOutsideMessage(context);
              },
              child: alert,
            );
          },
        );
      }
    } else {
      balance += numberOfOccurrence * 50;
      animateB(numberOfOccurrence * 50);

      if ((balance >= 500) & (!playedMoneySong)) {
        AudioCache player = AudioCache();
        player.play("effects/money_2.mp3");
        playedMoneySong = true;
      } else {
        AudioCache player = AudioCache();
        player.play("effects/correct.mp3");
      }

      if (highestBalance < balance) {
        newBal = true;
        animateHB(balance - highestBalance);
        highestBalance = balance;
      }

      if (balance <= 50 && play) {
        AudioCache player = AudioCache();
        player.play("effects/watchout_159RfBh.mp3");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                showClickOutsideMessage(context);
              },
              child: alert,
            );
          },
        );
      }
    }
  }

  void showKeyPad(size, context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext builder) {
        return keyPad(size, context);
      },
    );
  }

  void doThings(size, context) {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        newBal = false;
        display = true;
        generateRandomNumbers();
        checkMatch();
        updateBalance(size, context);
      });
    });
  }

  void checkMatch() {
    for (var r in randomNumbers) {
      if (r.toString() == input.toString()) {
        numberOfOccurrence++;
      }
    }
  }

  Widget winOrLose() {
    if (numberOfOccurrence > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            height: 30,
            image: AssetImage("assets/images/profit.png"),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "You just ",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const Text(
            "WON ",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent),
          ),
          Text(
            "${numberOfOccurrence * 50} naira!",
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      );
    } else {
      if (play) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              height: 30,
              image: AssetImage("assets/images/loss.png"),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "You just ",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              "LOST ",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Text(
              "100 naira!",
              style: TextStyle(fontSize: 30),
            ),
          ],
        );
      }
      return const Text(
        "GAME OVER!",
        style: TextStyle(
            color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),
      );
    }
  }

  AlertDialog updatedDuplicated = const AlertDialog(
    backgroundColor: Colors.purpleAccent,
    title: Text(
      "Duplicate score",
      style: TextStyle(
        color: Colors.yellow,
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
    ),
    content: Text(
      "Your duplicate score was updated",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    ),
  );

  AlertDialog alert = const AlertDialog(
    backgroundColor: Colors.yellow,
    title: Text(
      "Good Luck!",
      style: TextStyle(
        color: Colors.purple,
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
    ),
    content: Text(
      "If you lose this round, it's game over!",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
        fontSize: 25,
      ),
    ),
  );

  AlertDialog newHighScore = const AlertDialog(
    backgroundColor: Colors.yellow,
    title: Text(
      "New High Score!",
      style: TextStyle(
        color: Colors.purpleAccent,
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
    ),
    content: Text(
      "You have a new high score! You can check your (new) position on the leaderboard.",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
        fontSize: 25,
      ),
    ),
  );

  keyPad(size, context) {
    double width = size.width / 5;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      insetPadding: const EdgeInsets.all(0),
      elevation: 100,
      backgroundColor: Colors.black54,
      alignment: AlignmentDirectional.bottomCenter,
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "1",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 1;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "2",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 2;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "3",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 3;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "4",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 4;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "5",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 5;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "6",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 6;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "7",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 7;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "8",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 8;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
                GestureDetector(
                  child: AnimatedContainer(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: const Center(
                      child: AutoSizeText(
                        "9",
                        minFontSize: 0,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    input = 9;
                    Navigator.pop(context);
                    doThings(size, context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final one = GlobalKey(), two = GlobalKey(), three = GlobalKey();
    if (!hasShownShowCaseView) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([
          one,
          two,
          three,
        ]),
      );
    }

    Size size = MediaQuery.of(context).size;

    Color changeBalanceColor() {
      Color newColor;
      if (balance < highestBalance) {
        newColor = Colors.redAccent;
      } else if (balance == highestBalance) {
        if (newBal) {
          newColor = Colors.lightGreen;
        } else {
          newColor = Colors.yellowAccent;
        }
      } else {
        newColor = Colors.lightGreen;
      }

      return newColor;
    }

    Color changePBColor() {
      Color newColor;
      if (balance < highestScore * .25) {
        newColor = Colors.redAccent;
      } else if (balance >= highestScore * .75) {
        newColor = Colors.lightGreen;
      } else {
        newColor = Colors.amber;
      }

      return newColor;
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepOrange, Colors.yellow],
            ),
          ),
          child: _connectionStatus == ConnectivityResult.none
              ? connectToInternet(context)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.deepOrange],
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Showcase(
                                          key: three,
                                          showcaseBackgroundColor:
                                              Colors.lightGreen,
                                          textColor: Colors.white,
                                          description:
                                              "This shows how close you are to beating your personal best",
                                          contentPadding:
                                              const EdgeInsets.all(20),
                                          shapeBorder: const CircleBorder(),
                                          child:
                                              LiquidCircularProgressIndicator(
                                            value: play
                                                ? animatedBalance / highestScore
                                                : balance - 100,
                                            valueColor: AlwaysStoppedAnimation(
                                                animatedBalance > highestScore
                                                    ? Colors.purple
                                                    : changePBColor()),
                                            backgroundColor: Colors.black26,
                                            borderColor: Colors.black26,
                                            borderWidth: 1,
                                            direction: Axis.vertical,
                                            center: Text(
                                              "${formatCurrency.format(play ? balance : balance - 100)} / ${formatCurrency.format(highestScore)}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Card(
                                        color: Colors.amberAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const AutoSizeText(
                                                      "Highest Balance:      ",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                      minFontSize: 20,
                                                      maxLines: 1,
                                                    ),
                                                    Showcase(
                                                      key: one,
                                                      showcaseBackgroundColor:
                                                          Colors.yellow,
                                                      description:
                                                          "This shows the maximum balance you've gotten. \nYour final highest balance becomes your score after the game is over",
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: AutoSizeText(
                                                        formatCurrency.format(
                                                            highestBalance),
                                                        style: const TextStyle(
                                                          fontSize: 30,
                                                        ),
                                                        minFontSize: 20,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const AutoSizeText(
                                                      "Current Balance: ",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                      minFontSize: 20,
                                                      maxLines: 1,
                                                    ),
                                                    Card(
                                                      color:
                                                          changeBalanceColor(),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      child: Showcase(
                                                        key: two,
                                                        showcaseBackgroundColor:
                                                            Colors.yellow,
                                                        description:
                                                            "This shows the current balance you've gotten so far",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        shapeBorder:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: AutoSizeText(
                                                              (play)
                                                                  ? formatCurrency
                                                                      .format(
                                                                          balance)
                                                                  : "Debt",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 25,
                                                              ),
                                                              minFontSize: 20,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          if (display) displayResult(context),
                          if (play)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (play) showKeyPad(size, context);
                                });

                                myBox.put("hasShownShowCaseView", true);
                                hasShownShowCaseView =
                                    myBox.get("hasShownShowCaseView");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 100,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 100,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [Colors.grey, Colors.white]),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Tap here to enter a number from 1 to 9",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

void showClickOutsideMessage(context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text(
        "Click outside the dialog to exit",
        textAlign: TextAlign.center,
      )));
}
