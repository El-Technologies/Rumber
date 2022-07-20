import 'package:flutter/material.dart';
import 'package:rumber/leaderboard.dart';
import 'package:rumber/personal_scores.dart';
import 'package:showcaseview/showcaseview.dart';

import 'data.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  bool hasShownScoreShowCaseView = false;

  @override
  void initState() {
    if (myBox.get("hasShownScoreShowCaseView") == null) {
      myBox.put("hasShownScoreShowCaseView", false);
    }
    hasShownScoreShowCaseView = myBox.get("hasShownScoreShowCaseView");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final one = GlobalKey();
    if (!hasShownScoreShowCaseView) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([
          one,
        ]),
      );
      myBox.put("hasShownScoreShowCaseView", true);
      hasShownScoreShowCaseView = myBox.get("hasShownScoreShowCaseView");
    }

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
            title: const Text(
              "Score Board",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 40,
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              physics: const BouncingScrollPhysics(),
              enableFeedback: true,
              tabs: [
                Showcase(
                  key: one,
                  showcaseBackgroundColor: Colors.deepOrange,
                  textColor: Colors.white,
                  description: "You can view the leaderboard here",
                  contentPadding: const EdgeInsets.all(20),
                  child: const Tab(
                    child: Text("Leaderboard"),
                  ),
                ),
                const Tab(child: Text("Personal Scores")),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              LeaderBoardScores(),
              PersonalScores(),
            ],
          ),
        ),
      ),
    );
  }
}
