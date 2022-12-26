// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as Path;

import 'cor.dart';

class AgenciaAddImage extends StatefulWidget {
  const AgenciaAddImage(
      {super.key,
      required this.uid,
      required this.idpost,
      required this.editpost});

  final String idpost;
  final String uid;
  final String editpost;

  @override
  // ignore: no_logic_in_create_state
  State<AgenciaAddImage> createState() => _AgenciaAddImageState(
        uid: uid,
        idpost: idpost,
        editpost: editpost,
      );
}

class _AgenciaAddImageState extends State<AgenciaAddImage> {
  _AgenciaAddImageState(
      {required this.uid,
      required this.idpost,
      required this.editpost //this.formKey
      });
  // formKey = GlobalKey<FormState>();
  final String idpost;
  final String uid;
  final String editpost;

  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  final List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: corAppBar,
          title: const Text('Adicionar imagem...'),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: const Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enviando...',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    // ignore: unnecessary_null_comparison
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      // ignore: avoid_print
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });

      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Posts')
          .child(uid)
          .child(idpost)
          .child(Path.basename(img.path));
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef
              .doc(idpost)
              .collection("imgs")
              .add({'url': value, 'imagemcriadaem': Timestamp.now()});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance
        .collection('Clientes')
        .doc(uid)
        .collection('Posts');
  }
}