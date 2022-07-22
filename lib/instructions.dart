// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Proceed extends StatefulWidget {
  const Proceed({Key? key}) : super(key: key);

  @override
  State<Proceed> createState() => _ProceedState();
}

class _ProceedState extends State<Proceed> {
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            stretch: true,
            floating: false,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "How To Play",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                width: size.width,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You are to input any number from 1 - 9. "
                        "\nThe computer will generate 5 random numbers from the above "
                        "range as well "
                        "\n\n(Some digits may be repeated more than once)",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset("assets/images/enter-a-number.png"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If your input happens to be one of the randomly generated "
                        "numbers, you win 50 naira ",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset("assets/images/win.png"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If your number appears more than once, your profit will be "
                        "multiplied by the number of times it appeared "
                        "\n\n(eg. if it appears 3 times, you get 150 naira)",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset("assets/images/triple-win.png"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If your number isn't one of the randomly generated numbers "
                        "though, you lose 100 naira",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset("assets/images/lose.png"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "The game will continue until you have some debt, "
                        "which means you'll still have a chance when you have 0 - 50 naira left. "
                        "But if you lose that round, you've lost the game",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset("assets/images/about-to-lose.png"),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.purple[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "The game will last for a day and the first person on the leaderboard "
                        "gets whatever he or she earned in the game as his or her highest score."
                        "\n\nGood luck!",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(2000,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        tooltip: 'Scroll down',
        child: Icon(
          color: Colors.white,
          Icons.arrow_downward_rounded,
        ),
      ),
    );
  }
}

class UpdateIndex extends StatefulWidget {
  const UpdateIndex({Key? key}) : super(key: key);

  @override
  State<UpdateIndex> createState() => _UpdateIndexState();
}

class _UpdateIndexState extends State<UpdateIndex> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
