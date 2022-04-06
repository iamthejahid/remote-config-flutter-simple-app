// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meow/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // For using firebase services, thanks to flutterfireCLI.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RomoteConfiguredPage(),
    );
  }
}

class RomoteConfiguredPage extends StatefulWidget {
  const RomoteConfiguredPage({Key? key}) : super(key: key);

  @override
  State<RomoteConfiguredPage> createState() => _RomoteConfiguredPageState();
}

class _RomoteConfiguredPageState extends State<RomoteConfiguredPage> {
  DashRes _dashRes = DashRes();
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    super.initState();
    initFunc();
  }

  // I am breaking the code in various function for clarification

  initFunc() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(hours: 3), // When Cache will be removed.
        minimumFetchInterval: const Duration(hours: 3),
      ),
    );
    activateFunc();
  }

  activateFunc() async {
    await remoteConfig.fetchAndActivate(); // For activating .
    fetchh();
  }

  void fetchh() async {
    _setterVal = remoteConfig.getBool(
        'isRed'); // Fetching Specific value,  here , we are fetching a boolian value
    _dashRes =
        DashRes.fromJson(jsonDecode(remoteConfig.getString('dashBoardConfig')));
    setState(() {});
  }

  bool _setterVal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text('isRed : $_setterVal'),

                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _setterVal ? Colors.red : Colors.black,
                  ),
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      'If the value of "isRed" from remotconfig is true, the color of container will be red.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: _setterVal ? Colors.black : Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                // If the value in remote config is true, this Container will be in the scene.
                if (_dashRes.firstBox != null && _dashRes.firstBox!)
                  Container(
                    height: 100,
                    width: 200,
                    color: Colors.black,
                    child: Column(
                      children: const [
                        Text(
                          'This is first Box',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'If the value in remote config is true, this Container will be in the scene',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),

                Text(Platform.isIOS
                    ? "Platform is IOS"
                    : Platform.isAndroid
                        ? "Platform is Android"
                        : "Platform Unknown"),

                const Text(
                    "Intentionally, we setted a condition here, if the platform is ios, this box will not be in the scene"),
                const SizedBox(
                  height: 15,
                ),
                if (_dashRes.secondBox != null && _dashRes.secondBox!)
                  Container(
                    height: 100,
                    width: 200,
                    color: Colors.black,
                    child: Column(
                      children: const [
                        Text(
                          'This is Second Box',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'If the value in remote config is true, this Container will be in the scene',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),

                if (_dashRes.thirdPage != null && _dashRes.thirdPage!)
                  Container(
                    height: 100,
                    width: 200,
                    color: Colors.black,
                    child: Column(
                      children: const [
                        Text(
                          'This is third Box',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'If the value in remote config is true, this Container will be in the scene',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// For receiving the json data in structured way.
// You can use https://javiercbk.github.io/json_to_dart/ for json to dart convertion

class DashRes {
  bool? firstBox;
  bool? secondBox;
  bool? thirdPage;

  DashRes({this.firstBox, this.secondBox, this.thirdPage});

  DashRes.fromJson(Map<String, dynamic> json) {
    firstBox = json['first_box'];
    secondBox = json['second_box'];
    thirdPage = json['third_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_box'] = firstBox;
    data['second_box'] = secondBox;
    data['third_page'] = thirdPage;
    return data;
  }
}
