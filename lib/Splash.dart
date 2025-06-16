import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notezilla/NoteList.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);


    _controller.forward();





    Timer(const Duration(milliseconds: 800), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          UpgradeAlert(
            upgrader: Upgrader(
            //debugDisplayAlways: true,
            ),
              dialogStyle: UpgradeDialogStyle.cupertino,
              showIgnore: false,
              showLater: true,

             child: Notelist(),),)); // Change as needed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildLine() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 2,
            width: MediaQuery.of(context).size.width * _animation.value * 0.5,
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Notezilla',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                  fontFamily: 'Caveat',
                ),
              ),
              const SizedBox(height: 8),
              buildLine(),
            ],
          ),
        ),
      ),
    );
  }
}
