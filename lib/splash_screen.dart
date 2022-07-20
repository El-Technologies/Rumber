import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rumber/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = const Duration(seconds: 6);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MenuPage()));
  }

  initScreen(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: size.width,
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: const [
                    Text(
                      "Rumber",
                      style: TextStyle(
                          fontFamily: "Sansita",
                          color: Colors.red,
                          fontSize: 70,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "USCUP GAMES",
                      style: TextStyle(
                          fontFamily: "Alef",
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Image.asset("assets/launcher/launcher.jpg"),
                const Text(
                  "© 2022 USCUP Games, lnc",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.black,
                    fontSize: 17,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
