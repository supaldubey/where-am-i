import 'dart:async';

import 'package:flutter/material.dart';
import 'package:where_am_i/error_view.dart';
import 'package:where_am_i/location/fetch.dart';
import 'package:where_am_i/result_view.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  final int _duration = 2000;
  final int _buffer = 500;

  late AnimationController _animationController;
  late Animation<double> _animation;
  CurrentLocation? currentLocation;

  late Timer _timer;

  startTime() async {
    var timerDuration = Duration(milliseconds: _duration);
    return _timer = Timer(timerDuration, onSplashComplete);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration + _buffer));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.bounceIn)));

    _animation.addListener(() => setState(() {}));
    _animationController.forward();

    startTime();
    Future<CurrentLocation> futureLocation = fetchLocation();

    futureLocation
        .then((value) => addLocation(value))
        .onError((error, stackTrace) => showError(error))
        .catchError((error) => showError(error));
  }

  void showError(error) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorView(error),
        ));
  }

  void addLocation(CurrentLocation fetchedLocation) {
    setState(() {
      currentLocation = fetchedLocation;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultView(fetchedLocation)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 275 * _animation.value,
                weight: 800,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    ));
  }

  String toText() {
    return currentLocation.toString();
  }

  void onSplashComplete() {}
}
