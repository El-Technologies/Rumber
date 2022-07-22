// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rumber/data.dart';
import 'package:rumber/user.dart';

bool onLogInPage = true;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController(),
      phoneController = TextEditingController();
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    FocusScopeNode currentfocus = FocusScope.of(context);

    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: _connectionStatus == ConnectivityResult.none
          ? connectToInternet(context)
          : Form(
              key: formKey,
              child: Container(
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepOrangeAccent,
                      Colors.deepOrange,
                    ],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.3),
                              Colors.orangeAccent.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: size.height / 100),
                            const AutoSizeText(
                              "Please enter a username and mobile number for identification",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.limeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              minFontSize: 10,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                ),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                controller: usernameController,
                                keyboardType: TextInputType.name,
                                validator: (text) {
                                  if (text == null || text.trim().isEmpty) {
                                    return 'Please enter a valid username';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  label: Text("Username"),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (text) {
                                  if (text == null ||
                                      text.trim().isEmpty ||
                                      text.trim().length != 11) {
                                    return 'Please enter a valid mobile number';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  label: Text("Mobile Number"),
                                  prefixIcon: Icon(Icons.phone),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FloatingActionButton(
                              onPressed: () {
                                if (!currentfocus.hasPrimaryFocus) {
                                  currentfocus.unfocus();
                                }

                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    username = usernameController.text.trim();

                                    if (myBox.get("userId") == null) {
                                      myBox.put("userId", docUser.id);
                                    }

                                    userId = myBox.get("userId");
                                    myBox.put("userId", userId);
                                    isLoggedIn = true;
                                    myBox.put("isLoggedIn", true);
                                    myBox.put("username", username);
                                  });
                                  createUser(usernameController.text.trim(),
                                      int.parse(phoneController.text.trim()));
                                }
                              },
                              backgroundColor: Colors.white,
                              child: Icon(
                                size: 40,
                                color: Colors.green,
                                Icons.keyboard_arrow_right_rounded,
                              ),
                            ),
                            SizedBox(height: size.height / 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

final docUser = FirebaseFirestore.instance.collection("players").doc();

Future createUser(String name, int phone) async {
  final user = User(
    id: docUser.id,
    name: name,
    phone: phone,
    score: 0,
  );

  final json = user.toJson();

  await docUser.set(json);
}

Stream<List<User>> readUsers() => FirebaseFirestore.instance
    .collection("players")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
