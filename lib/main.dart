import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(AnimatedHeartbeatApp());
}

class AnimatedHeartbeatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeartbeatScreen(),
    );
  }
}

class HeartbeatScreen extends StatefulWidget {
  @override
  _HeartbeatScreenState createState() => _HeartbeatScreenState();
}

class _HeartbeatScreenState extends State<HeartbeatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _countdownSeconds = 10;
  late Timer _timer;

  String _userMessage = '';

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Define heartbeat animation
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    // Start heartbeat animation
    _animationController.forward();

    // Start countdown timer
    _startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          timer.cancel(); // Stop the timer when countdown reaches 0
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Heartbeat App',
        style: TextStyle(
          color: const Color.fromARGB(255, 244, 54, 197),
        ),
      ),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Icon(
                    Icons.favorite,
                    color: const Color.fromARGB(255, 244, 54, 197),
                    size: 100.0,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Countdown: $_countdownSeconds seconds',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _userMessage = value;
                });
              },
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _userMessage.isNotEmpty ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                _userMessage,
                style: TextStyle(
                  fontSize: 18,
                  color:  const Color.fromARGB(255, 244, 54, 197),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
