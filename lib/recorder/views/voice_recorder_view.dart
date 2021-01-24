import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recorder'),
        ),
        body: _RecorderMainView(),
      ),
    );
  }
}

class _RecorderMainView extends StatefulWidget {
  @override
  __RecorderMainViewState createState() => __RecorderMainViewState();
}

class __RecorderMainViewState extends State<_RecorderMainView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RecordButtonView(),
    );
  }
}

class RecordButtonView extends StatefulWidget {
  const RecordButtonView({
    Key key,
  }) : super(key: key);

  @override
  _RecordButtonViewState createState() => _RecordButtonViewState();
}

class _RecordButtonViewState extends State<RecordButtonView> {
  FlutterAudioRecorder _audioRecorder;
  bool _isRecording;
  bool _isRecordingFinished;
  bool _isAudioPlaying;
  String _recordFilePath;

  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _isRecording = false;
    _isRecordingFinished = false;
    _isAudioPlaying = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return _isRecordingFinished
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: () {
                    setState(() {
                      _isRecordingFinished = false;
                    });
                  }),
              IconButton(
                icon: Icon(_isAudioPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (!_isAudioPlaying) {
                    setState(() {
                      _isAudioPlaying = true;
                    });
                    _audioPlayer.play(_recordFilePath, isLocal: true);
                    _audioPlayer.onPlayerCompletion.listen((duration) {
                      setState(() {
                        _isAudioPlaying = false;
                      });
                    });
                  } else {
                    _audioPlayer.stop();
                    _isAudioPlaying = false;
                    setState(() {});
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.cloud_upload),
                onPressed: null,
              ),
            ],
          )
        : GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              height: 150,
              width: 150,
              color: Colors.pink,
              child: Center(
                child: Icon(
                  _isRecording ? Icons.stop : Icons.fiber_manual_record,
                ),
              ),
            ),
          );
  }

  Future<void> _startRecording() async {
    final bool hasRecordingPermission =
        await FlutterAudioRecorder.hasPermissions;
    if (hasRecordingPermission) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _isRecording = true;
      _recordFilePath = filepath;
      setState(() {});
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text('Please enable recording permission'),
        ),
      ));
    }
  }

  Future<void> _stopRecording() async {
    _audioRecorder.stop();
    _isRecording = false;
    _isRecordingFinished = true;
    print('Recording completed : $_recordFilePath');
    setState(() {});
  }
}
