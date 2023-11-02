import 'package:record/record.dart';
import 'package:flutter/material.dart';

class ListenMusicPage extends StatefulWidget {
  const ListenMusicPage({super.key});

  @override
  State<ListenMusicPage> createState() => _ListenMusicPageState();
}

class _ListenMusicPageState extends State<ListenMusicPage> {
  final recorder = AudioRecorder();

  void startListening() async {
    if (await recorder.hasPermission()) {
      // //to start recording to a file.
      // await recorder.start(
      //     const RecordConfig(sampleRate: 44100, numChannels: 1),
      //     path: "assets/recorded/tmp.m4a");

      //to start recording to a stream.
      final stream =
          await recorder.startStream(const RecordConfig(sampleRate: 44100));
      print(stream);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: startListening,
        child: const Text("Start Recording"),
      )),
    );
  }
}
