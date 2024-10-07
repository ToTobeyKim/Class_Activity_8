import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const AnimatedAlignExampleApp());

class AnimatedAlignExampleApp extends StatelessWidget {
  const AnimatedAlignExampleApp({super.key});

  static const Duration duration = Duration(seconds: 1);
  static const Curve curve = Curves.fastOutSlowIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Halloween')),
        body: const AnimatedAlignExample(
          duration: duration,
          curve: curve,
        ),
      ),
    );
  }
}

class AnimatedAlignExample extends StatefulWidget {
  const AnimatedAlignExample({
    required this.duration,
    required this.curve,
    super.key,
  });

  final Duration duration;
  final Curve curve;

  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  bool selected = false;
  Timer? _timer;
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer backgroundPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        selected = !selected;
      });
    });
    playBackgroundMusic();
  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose();
    backgroundPlayer.dispose();
    super.dispose();
  }

  void playSound() async {
    try {
      await player.setAsset('Sounds/scream.mp3');
      player.play();
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void playBackgroundMusic() {
    backgroundPlayer.setAsset('Sounds/Halloween.mp3').then((_) {
      backgroundPlayer.play();
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (backgroundPlayer.playerState.processingState == ProcessingState.completed) {
          backgroundPlayer.seek(Duration.zero);
          backgroundPlayer.play();
        }
      });
    });
  }

  void showLoseImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You Lose'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'Images/Witch.jpg',
                width: 500,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You Win'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Images/Halloween.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ), 
          Expanded(
            child: GestureDetector(
              onTap: () {
                playSound();
                showLoseImage();
              },
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment: selected ? Alignment.topRight : Alignment.bottomLeft,
                    duration: widget.duration,
                    curve: widget.curve,
                    child: Image.asset('Images/BatShape.png', width: 200.0),
                  ),
                  AnimatedAlign(
                    alignment: selected ? Alignment.topLeft : Alignment.bottomRight,
                    duration: widget.duration,
                    curve: widget.curve,
                    child: Image.asset('Images/BatShape.png', width: 200.0),
                  ),
                  AnimatedAlign(
                    alignment: selected ? Alignment.bottomRight : Alignment.bottomCenter,
                    duration: widget.duration,
                    curve: widget.curve,
                    child: Image.asset('Images/BatShape.png', width: 200.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      showWinDialog();
                    },
                    child: AnimatedAlign(
                      alignment: selected ? Alignment.bottomLeft : Alignment.topCenter,
                      duration: widget.duration,
                      curve: widget.curve,
                      child: Image.asset('Images/BatShape.png', width: 200.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
