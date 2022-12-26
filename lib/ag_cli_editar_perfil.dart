import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; 
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart'; 
import 'ag_homepage.dart'; 
import 'cor.dart';

class AgenciaClienteEditarPerfil extends StatefulWidget {
  const AgenciaClienteEditarPerfil({super.key, 
    required this.uid,
    required this.nome,
    required this.sobrenome,
    required this.especialidade,
    required this.imagemperfil,
  });

  final String uid;
  final String nome;
  final String sobrenome;
  final String especialidade;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;

  @override
  // ignore: library_private_types_in_public_api
  _AgenciaClienteEditarPerfilState createState() =>
      // ignore: no_logic_in_create_state
      _AgenciaClienteEditarPerfilState(
          uid: uid,
          nome: nome,
          sobrenome: sobrenome,
          especialidade: especialidade,
          imagemperfil: imagemperfil);
}

class _AgenciaClienteEditarPerfilState
    extends State<AgenciaClienteEditarPerfil> {
  _AgenciaClienteEditarPerfilState({
    required this.uid,
    required this.nome,
    required this.sobrenome,
    required this.especialidade,
    required this.imagemperfil,
  });

  final String uid;
  final String nome;
  final String sobrenome;
  final String especialidade;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;
  final formKey = GlobalKey<FormState>();
  final nomeedit = TextEditingController();
  final sobrenomeedit = TextEditingController();
  final especialidadeedit = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  User? usuarioo;

  XFile? imgXFile;
  //XFile? imageUrl;
  final ImagePicker imagePicker = ImagePicker();

  late FirebaseFirestore db;
  //late AuthService auth;

  FirebaseAuth auth = FirebaseAuth.instance;

  File? imageFile;
  String? imageUrl;

  bool isChecked = false;

  int radioValuedois = 0;
  String funcUsuario = '';
  CroppedFile? _croppedFile;
  String? image;
  String? imges;

  @override
  void initState() {
    super.initState();
    nomeedit.text = widget.nome;
    sobrenomeedit.text = widget.sobrenome;
    especialidadeedit.text = widget.especialidade;
    image = widget.imagemperfil;
    //_croppedFile = widget.imagemperfil;
    //final foto = NetworkImage(widget.imagemperfil);
  }

  getImgProfileFromGallery() async {
    imgXFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    _cropImage();
    setState(() {
      imgXFile;
    });
  }

  Future<void> _cropImage() async {
    if (imgXFile == null) {
      Navigator.pop(context, false);
      //_croppedFile = image as CroppedFile?;
    } else if (imgXFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgXFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          //imges = _croppedFile!.toString();
        });
      }
    }
  }

  atualizarPerfilCliente() async {
    //String id = Uuid().v1();
    final ref = FirebaseStorage.instance
        .ref()
        .child('ImgPerfilCliente')
        .child(uid)
        .child('${DateTime.now()}jpg');
    await ref.putFile((File(_croppedFile!.path)));
    imageUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Clientes").doc(uid).update({
      'nome': nomeedit.text.trim(),
      'sobrenome': sobrenomeedit.text.trim(),
      //'email': _auth.currentUser!.email,
      //'plano': null,
      //'id': id,
      //'uid': _auth.currentUser!.uid,
      'perfileditadoem': Timestamp.now(),
      'imagemperfil': imageUrl.toString(),
      'especialidade': especialidadeedit.text.trim(),
    });
  }

  atualizarPerfilClienteFavoritos() async {
    //String id = Uuid().v1();
    final ref = FirebaseStorage.instance
        .ref()
        .child('ImgPerfilCliente')
        .child(uid)
        .child('${DateTime.now()}jpg');
    await ref.putFile((File(_croppedFile!.path)));
    imageUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('Colaboradores')
        .doc(auth.currentUser?.uid)
        .collection("MeusClientes")
        .doc(uid)
        .update({
      'nome': nomeedit.text.trim(),
      'sobrenome': sobrenomeedit.text.trim(),
      //'email': auth.currentUser!.email,
      //'plano': null,
      //'id': id,
      //'uid': _auth.currentUser!.uid,
      'perfileditadoem': Timestamp.now(),
      'imagemperfil': imageUrl.toString(),
      'especialidade': especialidadeedit.text.trim(),
    });
  }

  atualizarPerfilClienteSemImagem() async {
    FirebaseFirestore.instance.collection("Clientes").doc(uid).update({
      'nome': nomeedit.text.trim(),
      'sobrenome': sobrenomeedit.text.trim(),
      //'email': _auth.currentUser!.email,
      //'plano': null,
      //'id': id,
      //'uid': _auth.currentUser!.uid,
      'perfileditadoem': Timestamp.now(),
      //'imagemperfil': imageUrl.toString(),
      'especialidade': especialidadeedit.text.trim(),
    });
  }

  atualizarPerfilClienteFavoritosSemImagem() async {
    FirebaseFirestore.instance
        .collection('Colaboradores')
        .doc(auth.currentUser?.uid)
        .collection("MeusClientes")
        .doc(uid)
        .update({
      'nome': nomeedit.text.trim(),
      'sobrenome': sobrenomeedit.text.trim(),
      //'email': auth.currentUser!.email,
      //'plano': null,
      //'id': id,
      //'uid': _auth.currentUser!.uid,
      'perfileditadoem': Timestamp.now(),
      //'imagemperfil': imageUrl.toString(),
      'especialidade': especialidadeedit.text.trim(),
    });
  }

  bool mostrarSenha = false;
  bool mostrarSenha2 = false;

  bool img = false;

  void imge(img) {
    if (img == false) {
      NetworkImage(image!);
    } else {
      _croppedFile;
    }
  }
  // foto = NetworkImage(imagemperfil);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
        color: Colors.white,
        /*   decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    corPrincipal,
                    corsegunda,
                    /*AppColours.appgradientfirstColour,
                              AppColours.appgradientsecondColour*/
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  //begin: const FractionalOffset(0.0, 0.0),
                  //end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              // borderRadius: BorderRadius.circular(12.0),
            ),
             */ //backgroundColor: Colors.yellow[100],
      ),
      SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image == image
                            ? GestureDetector(
                                onTap: () async {
                                  getImgProfileFromGallery();
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _croppedFile == null
                                      ? null
                                      : FileImage(File(_croppedFile!
                                          .path)), // NetworkImage(image!),
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width *
                                        0.10,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  getImgProfileFromGallery();
                                },
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: _croppedFile == null
                                        ? null
                                        : FileImage(File(_croppedFile!.path)),
                                    child: null),
                              ),
                        /*nome*/ Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            controller: nomeedit,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(),
                              labelText: 'Primeiro nome',
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o nome corretamente!';
                              }
                              return null;
                            },
                          ),
                        ),
                        /*sobrenome*/ Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            controller: sobrenomeedit,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(),
                              labelText: 'Sobrenome',
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o nome corretamente!';
                              }
                              return null;
                            },
                          ),
                        ),
                        /*especialidade*/ Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            controller: especialidadeedit,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.app_registration_sharp,
                                    color: Colors.black),
                                border: OutlineInputBorder(),
                                labelText: 'Especialidade',
                                hintText: 'Dermatologia'),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o plano corretamente!';
                              }
                              return null;
                            },
                          ),
                        ),
                        /*button*/ Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: corButton1 //Colors.black,
                                  ),
                              child: const Text('Atualizar dados'),
                              onPressed: () async {
                                //       if (formKey.currentState!.validate()) {
                                if (_croppedFile != null) {
                                  atualizarPerfilCliente();
                                  atualizarPerfilClienteFavoritos();
                                } else {
                                  atualizarPerfilClienteSemImagem();
                                  atualizarPerfilClienteFavoritosSemImagem();
                                }
                                Fluttertoast.showToast(
                                    msg: "Dados atualizados com sucesso",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 6,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AgenciaHomePage()));

                                /* await Future.delayed(
                                      Duration(milliseconds: 1500), () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AgenciaClientesLista()));
                                  }); 
 */
                                /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                TelaLogin()), (Route<dynamic> route) => false); */
                                //        }
                              }),
                        ),
                      ]))))
    ])));
  }
}
