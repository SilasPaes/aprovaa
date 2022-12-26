import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'cor.dart'; 

class AgenciaClienteEditTextoPost extends StatefulWidget {
  const AgenciaClienteEditTextoPost(
      {Key? key,
      required this.uid,
      required this.idpost,
      required this.editpost})
      : super(key: key);
  final String uid;
  final String idpost;
  final String editpost;
  @override
  State<AgenciaClienteEditTextoPost> createState() =>
      // ignore: no_logic_in_create_state
      _AgenciaClienteEditTextoPostState(
        uid: uid,
        idpost: idpost,
        editpost: editpost,
      );
}

class _AgenciaClienteEditTextoPostState
    extends State<AgenciaClienteEditTextoPost> {
  _AgenciaClienteEditTextoPostState(
      {required this.uid,
      required this.idpost,
      required this.editpost //this.formKey
      });
  final String idpost;
  final String uid;
  final String editpost;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final idPostController = TextEditingController();
  final editPostController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  //final bool _isSubmitting = false;
  bool uploading = false;
  final datacontrolleredit = TextEditingController();

  @override
  initState() {
    //PreferenciaTema.setTema();
    idPostController.text = widget.idpost;
    editPostController.text = widget.editpost;
    super.initState();
  }

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
      datacontrolleredit.text =
          DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final User? user = auth.currentUser;
    //final uids = user?.uid;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: corAppBar,
          title: const Text('Editar texto...'),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () async {
                  if (datacontrolleredit.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Confirme a data para publicar",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: corFlutterToast,
                        timeInSecForIosWeb: 6,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  } else if (editPostController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Preencha o campo obrigatório",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: corFlutterToast,
                        timeInSecForIosWeb: 6,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('Clientes')
                        .doc(uid)
                        .collection("Posts")
                        .doc(idpost)
                        .update({
                      'post': editPostController.text,
                      'corrigidoem': Timestamp.now(),
                      'status': 'aguardando',
                      'dataprevisao': datacontrolleredit.text,
                      'dtprevorderby': getText(), //metodo ordena ano mes dia
                      'previsaomes': date.month,
                      'previsaoano': date.year,
                      'previsaodia': date.day,
                    }).whenComplete(() => Navigator.of(context).pop());
                    /* showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Atenção"),
                            content: const Text(
                                "Seu texto será corrigido, deseja continuar?"),
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
                                child: const Text("ok"),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('Clientes')
                                      .doc(uid)
                                      .collection("Posts")
                                      .doc(idpost)
                                      .update({
                                    'post': editPostController.text,
                                    'corrigidoem': Timestamp.now(),
                                    'status': 'aprovado'
                                  }).whenComplete(
                                          () => Navigator.of(context).pop());

                                  Fluttertoast.showToast(
                                      msg: "Texto corrigido com sucesso",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 6,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  //  _color = Colors.blue; // This change Container color
                                  //});
                                },
                              )
                            ],
                          );
                        });
                  */
                  }
                },
                child: const Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                reverse: false,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: datacontrolleredit,
                          decoration: const InputDecoration(
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.transparent,
                            labelText: 'Previsão para postagem:',
                          ),
                          onTap: () async {
                            pickDate(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                bottom), //pro texto não ficar atras do teclado bottom
                        child: TextField(
                          controller: editPostController,
                          decoration: const InputDecoration(
                            hintText: 'Inspire-se:',
                            labelText: 'Digite seu texto aqui:',
                            //errorText: _validate ? 'Campo obrigatório' : null
                          ),
                          autofocus: false,
                          // focusNode: _focusnode,
                          //minLines: 1,
                          //maxLength: 4,
                          maxLines: null,
                          // controller: _newreplycontroller,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 40),
                      /* _isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text("Corrigir e aprovar texto"),
                          onPressed: () async {
                            if (editPostController.text.isEmpty) {
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
                                      title: const Text("Atenção"),
                                      content: const Text(
                                          "O texto será corrigido e enviado para nossa equipe prosseguir.\nDeseja continuar?"),
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
                                          child: const Text("Sim"),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Clientes')
                                                .doc(uid)
                                                .collection("Posts")
                                                .doc(idpost)
                                                .update({
                                              'post': editPostController.text,
                                              'corrigidoem': Timestamp.now(),
                                              'status': 'aprovado'
                                            }).whenComplete(() =>
                                                    Navigator.of(context)
                                                        .pop());
                                            //Navigator.of(context).pop();
                                            //Navigator.pop(context, false);
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Texto corrigido e aprovado com sucesso",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 4,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            //  _color = Colors.blue; // This change Container color
                                            //});
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                        ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text("Apenas corrigir o texto"),
                    onPressed: () async {
                      if (editPostController.text.isEmpty) {
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
                                title: const Text("Atenção"),
                                content: const Text(
                                    "Ao clicar em OK, seu texto será corrigido e enviado para a aba analisar e aguardará sua aprovação."),
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
                                    child: const Text("ok"),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Clientes')
                                          .doc(uid)
                                          .collection("Posts")
                                          .doc(idpost)
                                          .update({
                                        'post': editPostController.text,
                                        'corrigidoem': Timestamp.now(),
                                        'status': 'analisar',
                                        'daff': 'null'
                                      });
                                      setState(() {});
                                      /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AgenciaClienteAnalisar(uid: uid, nome: nome),
                                        )); */
                                      Navigator.of(context).pop();
                                      //Navigator.pop(context, false);
                                      Fluttertoast.showToast(
                                          msg:
                                              "Texto corrigido e aprovado com sucesso",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 4,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      //  _color = Colors.blue; // This change Container color
                                      //});
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                  ),
                 */
                    ],
                  ),
                ))));
  }
}
