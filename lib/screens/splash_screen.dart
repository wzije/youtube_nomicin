import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 200),
      child: Image.asset('assets/image/splash_logo.png'),
    );

    LinearProgressIndicator(
      color: Colors.white,
      backgroundColor: Colors.grey[300],
    );

    // animasi loading bar
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    // delay ke halaman utama
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// splash_logo TENGAH
          Center(
            child: Image.asset(
              'assets/images/splash_logo.png', // pake splash_logo !Micin kamu
              width: 180,
            ),
          ),

          /// LOADING BAR BAWAH
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 200 * _controller.value,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.red, // khas YouTube
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
