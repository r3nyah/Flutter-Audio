import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState(){
    super.initState();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state){
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration){
      setState((){
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition){
      setState((){
        position = newPosition;
      });
    });
  }

  Future setAudio()async{
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    String url = 'https://github.com/r3nyah/Flutter-Audio/blob/main/Assets/Palette.mp3';
    audioPlayer.setSourceUrl(url);

    //https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
    /*final file = await File('Assets/Palette.mp3');
    audioPlayer.setSourceAsset(file.path);*/

  }

  @override
  void dispose(){
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://pbs.twimg.com/media/EvFVS_nXIA4SpqB?format=jpg&name=4096x4096',
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              )
            ),
            const SizedBox(height: 20),
            const Text(
              'Palette',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Tokoyami Towa',
              style: TextStyle(
                fontSize: 20,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);

                await audioPlayer.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration - position)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 32,
              child: IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying){
                    await audioPlayer.pause();
                  }else{
                    await audioPlayer.resume();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return[
      if(duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
