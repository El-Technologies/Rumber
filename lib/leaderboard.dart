import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rumber/data.dart';
import 'package:rumber/random_numbers_game.dart';

class LeaderBoardScores extends StatefulWidget {
  const LeaderBoardScores({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScores> createState() => _LeaderBoardScoresState();
}

class _LeaderBoardScoresState extends State<LeaderBoardScores> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    initConnectivity();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    userIndex = 0;
    int userScore = 0;

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
        child: _connectionStatus == ConnectivityResult.none
            ? connectToInternet(context)
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: leaderboardColors(0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              leaderboardPositions(0),
                              const SizedBox(width: 10),
                              const Text(
                                "First",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .025),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: leaderboardColors(1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              leaderboardPositions(1),
                              const SizedBox(width: 10),
                              const Text(
                                "Second",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .025),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: leaderboardColors(2),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              leaderboardPositions(2),
                              const SizedBox(width: 10),
                              const Text(
                                "Third",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: SizedBox(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("players")
                              .orderBy("score", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            } else if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (_, int index) {
                                  DocumentSnapshot user =
                                      snapshot.data!.docs[index];
                                  if (index == 0) {
                                    userScore = user["score"];
                                    userIndex = index;
                                  } else {
                                    if (userScore != user["score"]) {
                                      userScore = user["score"];
                                      userIndex = index;
                                    } else {
                                      userIndex = userIndex;
                                    }
                                  }

                                  return Column(
                                    children: [
                                      if (userIndex == index)
                                        const SizedBox(height: 10),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: leaderboardColors(userIndex),
                                          border:
                                              Border.all(color: Colors.yellow),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          trailing: Card(
                                            elevation: 20,
                                            color: leaderboardColors(userIndex),
                                            shape: const CircleBorder(),
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                child: Text(
                                                  formatCurrency
                                                      .format(user["score"]),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            user["name"],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          leading:
                                              leaderboardPositions(userIndex),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
