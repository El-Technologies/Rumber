// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rumber/data.dart';
import 'package:rumber/random_numbers_game.dart';

class PersonalScores extends StatefulWidget {
  const PersonalScores({Key? key}) : super(key: key);

  @override
  State<PersonalScores> createState() => _PersonalScoresState();
}

class _PersonalScoresState extends State<PersonalScores> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepOrangeAccent, Colors.deepOrange],
          ),
        ),
        child: scoreList.isNotEmpty
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Personal Best",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Stack(
                          children: [
                            Card(
                              color: scoreColors(highestScore),
                              elevation: 20,
                              shape: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        formatCurrency.format(highestScore),
                                        style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
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
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                        itemCount: scoreList.length,
                        itemBuilder: (_, int index) {
                          int itemCount = scoreList.length;
                          int reversedIndex = itemCount - 1 - index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.yellow),
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(50),
                                  left: Radius.circular(10)),
                            ),
                            child: ListTile(
                              leading: Card(
                                elevation: 20,
                                color: scoreColors(int.parse(
                                    scoreList[reversedIndex][0].toString())),
                                shape: const CircleBorder(),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                      child: Text(formatCurrency.format(
                                          int.parse(scoreList[reversedIndex][0]
                                              .toString())))),
                                ),
                              ),
                              title: const Text(
                                "Tap to view",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              trailing: Text(
                                scoreList[reversedIndex][1].toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return displayScore(
                                      formatCurrency.format(int.parse(
                                          "${scoreList[reversedIndex][0]}")),
                                      "${scoreList[reversedIndex][1]}",
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : const Center(
                child: Text(
                  "Your scores will show here\n\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  Color scoreColors(hBalance) {
    if (hBalance == 200) {
      return Colors.redAccent.shade100;
    }

    if (hBalance < 300) {
      return Colors.orangeAccent;
    }

    if (hBalance < 400) {
      return Colors.yellowAccent;
    }

    if (hBalance < 500) {
      return Colors.lightGreen;
    }

    if (hBalance < 600) {
      return Colors.greenAccent;
    }

    if (hBalance < 700) {
      return Colors.lightBlue.shade300;
    }

    if (hBalance < 800) {
      return Colors.blue.shade500;
    }

    if (hBalance < 900) {
      return Colors.indigoAccent;
    }

    if (hBalance < 1000) {
      return Colors.grey.shade500;
    }

    return Colors.white;
  }

  Widget displayScore(String score, String time) {
    return Dialog(
      elevation: 70,
      backgroundColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: GestureDetector(
        onTap: () {
          showClickOutsideMessage(context);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$username's Score",
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              Container(
                height: 200,
                width: 200,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red, Colors.yellow, Colors.blue],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        score,
                        style: const TextStyle(
                          fontFamily: "Alef",
                          color: Colors.white,
                          fontSize: 50,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(5.0, 5.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                        maxLines: 1,
                      ),
                      Text(time)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
