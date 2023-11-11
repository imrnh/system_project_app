import 'package:record/record.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class ListenMusicPage extends StatefulWidget {
  const ListenMusicPage({super.key});

  @override
  State<ListenMusicPage> createState() => _ListenMusicPageState();
}

class _ListenMusicPageState extends State<ListenMusicPage> {
  final recorder = AudioRecorder();
  List<dynamic> audioData = [];
  late DateTime startTime;
  late double totalWTime = 0.0;
  late String rpath = "";
  final String audio_filename= randomString();

  void uploadFile() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$audio_filename.mp3');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.24.65.30:8000/music/uploadfile/'),
    );

    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: file.path.split('/').last);

    request.files.add(multipartFile);

    try {
      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {totalWTime = DateTime.now().difference(startTime).inMilliseconds / 1000.0;
      print('Error uploading file: $e');
    }
  }

  void recordOnFile() async {
    if (await recorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      startTime = DateTime.now();
      await recorder.start(const RecordConfig(sampleRate: 44100),
          path: '${directory.path}/$audio_filename.mp3');
    }
  }

  // void startListening() async {
  //   audioData = []; //cleanign list before starting.
  //   startTime = DateTime.now();
  //   if (await recorder.hasPermission()) {
  //     final stream = await recorder
  //         .startStream(const RecordConfig(sampleRate: 44100, bitRate: 350000));
  //
  //     stream.listen((data) {
  //       audioData.add(data);
  //     });
  //   }
  // }

  void stopRecording() async {
    final path = await recorder.stop();

    setState(() {
      // rpath = path!;
      totalWTime = DateTime.now().difference(startTime).inMilliseconds / 1000.0;
    });
    uploadFile();
  }

  void printData() {
    // print("\n\n\n\n\n\n\n\n\n\n\n\n\n\naudio data is: \n\n\n\n\n\n\n\n ${audioData[2].length}");
    print("Total length:  ${audioData.length}");
    int lsum = 0;
    audioData.forEach((element) {
      print("L: ${element.length}");
      lsum = lsum + element.length as int;
    });
    print("Bits: $lsum");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
          child: Column(
        children: [
          Text("Worked for $totalWTime}"),
          ElevatedButton(
            onPressed: recordOnFile,
            child: const Text("Start Recording"),
          ),
          ElevatedButton(
              onPressed: stopRecording, child: const Text("Stop recording")),
          const SizedBox(
            height: 100,
          ),
          ElevatedButton(onPressed: printData, child: const Text("Show data")),
          // Text("Rec path $rpath"),
        ],
      )),
    );
  }
}
