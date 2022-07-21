// import 'package:audioplayers/audioplayers.dart';
// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rumber/score_board.dart';
import 'package:rumber/data.dart';
import 'package:rumber/instructions.dart';
import 'package:rumber/login.dart';
import 'package:rumber/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:showcaseview/showcaseview.dart';

import 'random_numbers_game.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.openBox("myBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: 'Rumber',
      theme: ThemeData(
        fontFamily: "Sansita",
        primarySwatch: Colors.deepOrange,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool scoreMessage = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //initialize coins
    var myBox = Hive.box("myBox");

    if (myBox.get("isLoggedIn") == null) myBox.put("isLoggedIn", false);
    isLoggedIn = myBox.get("isLoggedIn");

    if (myBox.get("scores") == null) myBox.put("scores", []);
    scoreList = myBox.get("scores");

    if (myBox.get("highestScore") == null) myBox.put("highestScore", 200);
    highestScore = myBox.get("highestScore");

    if (myBox.get("username") == null) myBox.put("username", "");
    username = myBox.get("username");

    if (myBox.get("userId") == null) myBox.put("userId", docUser.id);
    userId = myBox.get("userId");

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        top: false,
        child: isLoggedIn
            ? Scaffold(
                body: Container(
                  width: size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: size.height / 1000,
                        ),
                        const AutoSizeText(
                          "Menu",
                          style: TextStyle(
                            fontSize: 70,
                            color: Colors.limeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 40,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: size.height / 5,
                        ),
                        SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowCaseWidget(
                                          builder: Builder(
                                            builder: (_) => const StartGame(),
                                          ),
                                        ),
                                      ));
                                  highestBalance = 200;
                                  animatedHighestBalance = 200;
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * .6,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(50))),
                                      child: Row(
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                                "assets/images/play.png"),
                                            width: 40,
                                            height: 40,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Start",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .08,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowCaseWidget(
                                          builder: Builder(
                                            builder: (_) => const Proceed(),
                                          ),
                                        ),
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: size.width * .6,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(20),
                                              topLeft: Radius.circular(50))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "How to Play",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .08,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          const Image(
                                            image: AssetImage(
                                                "assets/images/compliant.png"),
                                            width: 40,
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width * .6,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(50))),
                                      child: Row(
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                                "assets/images/competition.png"),
                                            width: 40,
                                            height: 40,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Score Board",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .08,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  quit(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: size.width * .6,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(50))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Quit",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .08,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          const Image(
                                            image: AssetImage(
                                                "assets/images/log-out.png"),
                                            width: 40,
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Login(),
      ),
    );
  }

  quit(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
      child: const Text(
        "Yeah",
        style: TextStyle(
          color: Colors.cyanAccent,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        SystemNavigator.pop();
      },
    );

    Widget noButton = TextButton(
      child: const Text(
        "Nah",
        style: TextStyle(
          color: Colors.tealAccent,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Colors.pink,
      title: const Text(
        "Quit Rumber?",
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 40,
        ),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Make sure you've taken a screenshot of your highest score if any.\nSure you wanna quit?",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
