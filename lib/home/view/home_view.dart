import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:upload_to_firebase/recorder/views/cloud_record_list_view.dart';
import 'package:upload_to_firebase/recorder/views/feature_buttons_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Reference> references = [];

  @override
  void initState() {
    super.initState();
    _onUploadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Example'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: references.isEmpty
                  ? Center(
                      child: Text('No File uploaded yet'),
                    )
                  : CloudRecordListView(
                      references: references,
                    ),
            ),
            Expanded(
              flex: 2,
              child: FeatureButtonsView(
                onUploadComplete: _onUploadComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('upload-voice-firebase').list();
    setState(() {
      references = listResult.items;
    });
  }
}
