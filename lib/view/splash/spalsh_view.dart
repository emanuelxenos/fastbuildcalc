import 'package:flutter/material.dart';

class SpalshView extends StatefulWidget {
  const SpalshView({super.key});

  @override
  State<SpalshView> createState() => _SpalshViewState();
}

class _SpalshViewState extends State<SpalshView> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    bootAnimation();
  }

  void bootAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: opacity,
            onEnd: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon-logo.png',
                    width: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fast Build Calc',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: opacity,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'by Emanuel Xenos',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
