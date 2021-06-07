import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasks/application/home/home_bloc.dart';
import 'package:tasks/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Hive.initFlutter().then((value) {
      context.read<HomeBloc>().add(HomeEvent.started());
      Future.delayed(Duration(seconds: 1)).then(
        (value) => Navigator.of(context).pushReplacementNamed('/home'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Image(
              width: 150.0,
              height: 150.0,
              image: AssetImage("assets/images/icon.png"),
            ),
          ),
          Positioned(
            left: .0,
            right: .0,
            bottom: 80.0,
            child: Text(
              "#TeamCardinal",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                letterSpacing: 1.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
