import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart'; 
import 'package:image_picker/image_picker.dart'; 
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; 
import 'auth_service.dart';
import 'cor.dart';
import 'wait.dart';

class CadastraCliente extends StatefulWidget {
  const CadastraCliente({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CadastraClienteState createState() => _CadastraClienteState();
}

class _CadastraClienteState extends State<CadastraCliente> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final senhaa = TextEditingController();
  final nome = TextEditingController();
  final sobrenome = TextEditingController();
  final especialidade = TextEditingController();

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
  late AuthService auth;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;
  String? imageUrl;

  bool isChecked = false;

  int radioValuedois = 0;
  String funcUsuario = '';

  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();

    setState(() {
      radioValuedois = 0;
    });
  }

  handleRadioValueChangeddois(value) {
    setState(() {
      radioValuedois = value;

      switch (radioValuedois) {
        case 0:
          //Fluttertoast.showToast(msg: 'Entre 18 e 30 anos',toastLength: Toast.LENGTH_SHORT);
          funcUsuario = "cliente";
          break;
        case 1:
          //Fluttertoast.showToast(msg: 'Entre 30 e 40 anos',toastLength: Toast.LENGTH_SHORT);
          funcUsuario = "colaborador";
          break;
      }
    });
  }

  getImgProfileFromGallery() async {
    imgXFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    //_cropImage(imgXFile!.path);]
    setState(() {
      imgXFile;
    });
    _cropImage();
  }

  Future<void> _cropImage() async {
    if (imgXFile != null) {
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
        });
      }
    }
  }

  sendInfoCliente() async {
    String id = const Uuid().v1();
    final ref = FirebaseStorage.instance
        .ref()
        .child('ImgPerfilCliente')
        .child(id)
        .child('${DateTime.now()}jpg');
    await ref.putFile((File(imgXFile!.path)));
    imageUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("Clientes")
        .doc(_auth.currentUser!.uid)
        .set({
      'nome': nome.text.trim(),
      'sobrenome': sobrenome.text.trim(),
      'email': _auth.currentUser!.email,
      'plano': null,
      'id': id,
      'uid': _auth.currentUser!.uid,
      'perfilcriadoem': Timestamp.now(),
      'imagemperfil': imageUrl.toString(),
      'senha': senha.text.trim(),
      'especialidade': especialidade.text.trim(),
      'updateem': null,
      'status': 'cliente'
    });
  }

  sendInfoColaborador() async {
    String id = const Uuid().v1();
    final ref = FirebaseStorage.instance
        .ref()
        .child('ImgPerfilColab')
        .child(_auth.currentUser!.uid)
        .child('${DateTime.now()}jpg');
    await ref.putFile((File(_croppedFile!.path)));
    imageUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("Colaboradores")
        .doc(_auth.currentUser!.uid)
        .set({
      'nome': nome.text.trim(),
      'sobrenome': sobrenome.text.trim(),
      'email': _auth.currentUser!.email,
      'plano': null,
      'id': id,
      'uid': _auth.currentUser!.uid,
      'perfilcriadoem': Timestamp.now(),
      'imagemperfil': imageUrl.toString(),
      'senha': senha.text.trim(),
      'especialidade': especialidade.text.trim(),
      'updateem': null,
      'status': 'colaborador'
    });
  }

  registrar() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().registrar(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  bool mostrarSenha = false;
  bool mostrarSenha2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
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
                    GestureDetector(
                      onTap: () async {
                        getImgProfileFromGallery();
                       },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.10,
                        backgroundColor: Colors.black,
                        backgroundImage: _croppedFile == null
                            ? null
                            : FileImage(File(_croppedFile!.path)),
                        child: _croppedFile == null
                            ? Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.10,
                              )
                            : null,
                      ),
                    ),
                    /*nome*/ Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextFormField(
                        controller: nome,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person, color: Colors.black),
                          border: OutlineInputBorder(),
                          labelText: 'Nome',
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
                        controller: sobrenome,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person, color: Colors.black),
                          border: OutlineInputBorder(),
                          labelText: 'Sobrenome',
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe seu sobrenome corretamente!';
                          }
                          return null;
                        },
                      ),
                    ),
                    /*email*/ Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email, color: Colors.black),
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe o e-mail corretamente!';
                          }
                          return null;
                        },
                      ),
                    ),
                    /*senha*/ Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: TextFormField(
                        controller: senha,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.key, color: Colors.black),
                          border: const OutlineInputBorder(),
                          labelText: 'Senha',
                          suffixIcon: GestureDetector(
                            child: Icon(
                                mostrarSenha == false
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black),
                            onTap: () {
                              setState(() {
                                mostrarSenha = !mostrarSenha;
                              });
                            },
                          ),
                        ),
                        obscureText: mostrarSenha == false ? true : false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informa sua senha!';
                          } else if (value.length < 6) {
                            return 'Sua senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    /*senhaa*/ Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: TextFormField(
                        controller: senhaa,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.key, color: Colors.black),
                          border: const OutlineInputBorder(),
                          labelText: 'Repita a senha',
                          suffixIcon: GestureDetector(
                            child: Icon(
                                mostrarSenha2 == false
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black),
                            onTap: () {
                              setState(() {
                                mostrarSenha2 = !mostrarSenha2;
                              });
                            },
                          ),
                        ),
                        obscureText: mostrarSenha2 == false ? true : false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informa sua senha!';
                          } else if (value.length < 6) {
                            return 'Sua senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    /*especialidade*/ Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextFormField(
                        controller: especialidade,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.app_registration_sharp,
                                color: Colors.black),
                            border: OutlineInputBorder(),
                            labelText: 'Especialidade',
                            hintText: 'Dermatologia'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe sua especialidade corretamente!';
                          }
                          return null;
                        },
                      ),
                    ),
                    /*
                  Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  */
                    /*
     radiobuttons   Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          width: 20,
                        ),
                        Radio<int>(
                          value: 0,
                          groupValue: radioValuedois,
                          onChanged: handleRadioValueChangeddois,
                        ),
                        const Text("Sou um cliente",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          width: 20,
                        ),
                        Radio<int>(
                          value: 1,
                          groupValue: radioValuedois,
                          onChanged: handleRadioValueChangeddois,
                        ),
                        const Text(" Sou um colaborador",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    */
                    /*button*/ Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: corButton1 //Colors.black,
                              ),
                          child: const Text('Cadastrar'),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (senha.text != senhaa.text) {
                                Fluttertoast.showToast(
                                    msg: "As senhas não correspondem",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 6,
                                    backgroundColor: corFlutterToast,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              } else if (imgXFile == null) {
                                Fluttertoast.showToast(
                                    msg: "Escolha uma foto para o seu perfil",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 6,
                                    backgroundColor: corFlutterToast,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              } else {
                                registrar();
                                await Future.delayed(
                                    const Duration(milliseconds: 2600));
                                sendInfoColaborador();
                                //sendInfoCliente();
                                await Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SplashWait()));
                                });
                                }
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}