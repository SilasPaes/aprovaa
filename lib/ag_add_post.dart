import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'auth_service.dart';
import 'cor.dart';

class AgenciaAddPost extends StatefulWidget {
  const AgenciaAddPost(
      {super.key,
      required this.uid,
      required this.nome,
      required this.sobrenome,
      this.imagemperfil});

  final String nome;
  final String uid;
  final String sobrenome;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;

  @override
  // ignore: no_logic_in_create_state
  State<AgenciaAddPost> createState() => _AgenciaAddPostState(
      uid: uid, nome: nome, imagemperfil: imagemperfil, sobrenome: sobrenome);
}

class _AgenciaAddPostState extends State<AgenciaAddPost> {
  _AgenciaAddPostState(
      {required this.uid,
      required this.nome,
      required this.sobrenome,
      this.imagemperfil //this.formKey
      });
  // formKey = GlobalKey<FormState>();
  final String nome;
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;
  final String sobrenome;

  final posttexto = TextEditingController();
  final datacontroller = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  User? usuario;

  late FirebaseFirestore db;
  late AuthService auth;

  final bool _validate = false;

  int postagem = 0;
  void contagemPost(int valor) {
    postagem += valor;
  }

  sendText() async {
    //String id = const Uuid().v1();
    FirebaseFirestore.instance
        .collection("Clientes")
        .doc(uid)
        .collection("Posts")
        .doc()
        .set({
      'post': posttexto.text.trimRight().trimLeft(),
      'postcriadoem': Timestamp.now(),
      'status': 'analisar',
      'dataprevisao': datacontroller.text,
      'dtprevorderby': getText(), //metodo ordena ano mes dia
      'previsaomes': date.month,
      'previsaoano': date.year,
      'previsaodia': date.day,
      'corrigidoem': null
    });
  }

  DateTime dataa = DateTime.now();
  late DateTime date;

  String getText() {
    // ignore: unnecessary_null_comparison
    if (date == null) {
      return 'Escolha uma data';
    } else {
      //return DateFormat('yyyy MM dd', 'pt_BR').format(date);
      return '${date.year}/${date.month}/${date.day}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) => Theme(
          data: ThemeData().copyWith(
            colorScheme: const ColorScheme.light(
                primary: Colors.black,
                //background: marrom,
                //surface: Colors.orange,
                onPrimary: Colors.white,
                onSurface: Colors.black),
            //primaryColor: cinza,
          ),
          child: Center(child: child)),
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
      datacontroller.text = DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: corAppBar, // const Color(0xFF000000),
        title: const Text("Escreva o Texto"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: cinza, //corCard,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40.0,
                    backgroundImage: NetworkImage(imagemperfil),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        sobrenome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*Text(DateFormat("'Data numérica:' dd/MM/yyyy").format(dataa),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 20.0,
              )),
           Container(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.all(4),
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [               
                Text(DateFormat(
                        "'Data por extenso:' d 'de' MMMM 'de' y", "pt_BR")
                    .format(dataa)),
                Text(DateFormat("'Dia da semana:' EEEE", "pt_BR").format(dataa))
              ],
            ),
          ),
           */
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              readOnly: true,
              controller: datacontroller,
              decoration: const InputDecoration(
                filled: true, //<-- SEE HERE
                fillColor: Colors.grey,
                labelText: 'Previsão para postagem',
              ),
              onTap: () async {
                pickDate(context);
                /*  await showDatePicker(
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: cinza,
                          onPrimary: Colors.black,
                          onSurface: Colors.black,
                          //onBackground:
                        ),
                      ),
                      child: Center(child: child),
                    );
                  },
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2030),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    datacontroller.text = DateFormat('dd MMMM yyyy', 'pt_BR')
                        .format(selectedDate);
                  }
                }); */
              },
              /* validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Escolha a data.';
                }
                return null;
              }, */
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: bottom), //pro texto não ficar atras do teclado bottom
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextField(
                    controller: posttexto,
                    decoration: InputDecoration(
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.grey,
                        hintText: 'Inspire-se:',
                        labelText: 'Digite seu texto aqui:',
                        errorText: _validate ? 'Campo obrigatório' : null),
                    autofocus: false,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corButton1, // Colors.black,
                    ),
                    onPressed: () async {
                      if (datacontroller.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Escolha uma data prevista para publicar",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: corFlutterToast,
                            timeInSecForIosWeb: 6,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      } else
                      //  posttexto.text.isEmpty ? _validate = true : _validate = false;
                      if (posttexto.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Preencha o campo obrigatório",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: corFlutterToast,
                            timeInSecForIosWeb: 6,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      } else {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Atenção"),
                                content: const Text(
                                    "Já revisou seu texto? Posso enviar para o cliente?"),
                                actions: [
                                  TextButton(
                                    //cancelar button
                                    child: const Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                  TextButton(
                                    //enviar button
                                    child: const Text("Enviar"),
                                    onPressed: () {
                                      sendText();
                                      posttexto.clear();
                                      datacontroller.clear();
                                      Navigator.pop(context, false);
                                      Fluttertoast.showToast(
                                          msg: "Texto enviado com sucesso",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: corFlutterToast,
                                          timeInSecForIosWeb: 6,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    },
                                  )
                                ],
                              );
                            });
                      } //contagemPost(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Enviar",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

/* import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mktmanager/cor.dart';
import 'package:uuid/uuid.dart';

import 'auth_service.dart';

class AgenciaAddPost extends StatefulWidget {
  const AgenciaAddPost(
      {super.key, required this.uid, required this.nome, this.urlimage});

  final String nome;
  final String uid;
  final urlimage;

  @override
  State<AgenciaAddPost> createState() => _AgenciaAddPostState(
        uid: uid,
        nome: nome,
        urlimage: urlimage,
      );
}

class _AgenciaAddPostState extends State<AgenciaAddPost> {
  _AgenciaAddPostState(
      {required this.uid, required this.nome, this.urlimage //this.formKey
      });
  // formKey = GlobalKey<FormState>();
  final String nome;
  final String uid;
  final urlimage;

  final posttexto = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  User? usuario;

  late FirebaseFirestore db;
  late AuthService auth;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validate = false;

  int postagem = 0;
  void contagemPost(int valor) {
    postagem += valor;
  }

  sendText() async {
    String id = Uuid().v1();
    FirebaseFirestore.instance
        .collection("Clientes")
        .doc(uid)
        .collection("Posts")
        .doc()
        .set({
      'post': posttexto.text.trimRight().trimLeft(),
      'postcriadoem': Timestamp.now(),
      'status': 'analisar',
      'imagepost': null,
    });
    //.update({'post': posttexto.text.trimRight().trimLeft()});

    // Navigator.canPop(context) ? Navigator.pop(context) : null;
    //  imageFile = null;
    //} catch (error) {
    //   Fluttertoast.showToast(msg: error.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text("Enviar Texto"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            /*  decoration: BoxDecoration(
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
             */
            height: 150,
            width: MediaQuery.of(context).size.width,
            //margin: const EdgeInsets.all(20),
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(urlimage),
                  ), */
                  Expanded(
                    child: Text(
                      nome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black87,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: TextField(
                    controller: posttexto,
                    decoration: InputDecoration(
                        hintText: 'Inspire-se:',
                        labelText: 'Digite seu texto aqui:',
                        errorText: _validate ? 'Campo obrigatório' : null),
                    autofocus: false,
                    // focusNode: _focusnode,
                    //minLines: 1,
                    //maxLength: 4,
                    maxLines: null,
                    // controller: _newreplycontroller,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ],
          ),
          /*button*/ Padding(
            padding: EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                //  posttexto.text.isEmpty ? _validate = true : _validate = false;
                if (posttexto.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Preencha o campo obrigatório",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Atenção"),
                          content: Text(
                              "Já revisou seu texto? Posso enviar para o cliente?"),
                          actions: [
                            TextButton(
                              //cancelar button
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                            TextButton(
                              //enviar button
                              child: Text("Enviar"),
                              onPressed: () {
                                sendText();
                                posttexto.clear();
                                Navigator.pop(context, false);
                                Fluttertoast.showToast(
                                    msg: "Texto enviado com sucesso",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 4,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                            )
                          ],
                        );
                      });
                } //contagemPost(1);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (loading)
                    ? [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]
                    : [
                        Icon(Icons.check),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Enviar",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
 */
