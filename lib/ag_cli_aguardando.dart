import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ag_add_image.dart';
import 'ag_cli_editar_texto.dart';
import 'cor.dart';

class AgenciaClienteAguardando extends StatefulWidget {
  const AgenciaClienteAguardando(
      {super.key, required this.uid, required this.nome, this.imagemperfil});

  final String nome;
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;

  @override
  State<AgenciaClienteAguardando> createState() =>
      // ignore: no_logic_in_create_state
      _AgenciaClienteAguardandoState(
        uid: uid,
        nome: nome,
        imagemperfil: imagemperfil,
      );
}

class _AgenciaClienteAguardandoState extends State<AgenciaClienteAguardando> {
  _AgenciaClienteAguardandoState(
      {required this.uid, required this.nome, this.imagemperfil //this.formKey
      });
  // formKey = GlobalKey<FormState>();
  final String nome;
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  // ignore: unused_field
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // final User? user = auth.currentUser;
    //final uids = user?.uid;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
              // borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Clientes")
                  .doc(uid)
                  .collection("Posts")
                  .orderBy("dtprevorderby", descending: false)
                  .where("status", isEqualTo: 'aguardando')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                var data = snapshot.data;
                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var datalength = data.docs.length;
                  if (datalength == 0) {
                    return const Center(
                      child: Text('Não tem posts Aguardando',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            //fontWeight: FontWeight.w200
                          )),
                    );
                  } else {
                    return Center(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              return Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.all(20),
                                    elevation: 20,
                                    color: Colors.white, // _color,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /*CARROSSEL*/ StreamBuilder<
                                                  QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("Clientes")
                                                  .doc(uid)
                                                  .collection("Posts")
                                                  .doc(ds.id)
                                                  .collection("imgs")
                                                  .orderBy('imagemcriadaem',
                                                      descending: false)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                var data = snapshot.data;
                                                if (data == null) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  var datalength =
                                                      data.docs.length;
                                                  if (datalength == 0) {
                                                    return const Center(
                                                      child: Text('Sem imagens',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            //fontWeight: FontWeight.w200
                                                          )),
                                                    );
                                                  } else {
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          CarouselSlider.builder(
                                                              itemCount: snapshot.data?.docs.length,
                                                              // itemCount: snapShot.data()!.length,
                                                              itemBuilder: (BuildContext context,
                                                                  index,
                                                                  // ignore: avoid_types_as_parameter_names
                                                                  int) {
                                                                DocumentSnapshot
                                                                    ds =
                                                                    snapshot.data!
                                                                            .docs[
                                                                        index];
                                                                return Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    /* width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,*/
                                                                    height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height,
                                                                    child: Image
                                                                        .network(
                                                                      ds['url'],
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ));
                                                              },
                                                              options: CarouselOptions(
                                                                  aspectRatio: 4 / 5,
                                                                  viewportFraction: 1,
                                                                  enableInfiniteScroll: false,
                                                                  initialPage: 0,
                                                                  autoPlay: false,
                                                                  //height: 480,
                                                                  onPageChanged: (int i, carouselPageChangedReason) {
                                                                    setState(
                                                                        () {
                                                                      _index =
                                                                          i;
                                                                    });
                                                                  })),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                              }),
                                          /*PREVISÃO*/ Container(
                                            //height: 170,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey[300],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  const Text('Data prevista:',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0)),
                                                  Text(
                                                    ds['dataprevisao'],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      //fontStyle: FontStyle.italic,
                                                      //fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          /*TEXTO*/ Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    ds['post'],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      //fontStyle: FontStyle.italic,
                                                      //fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          /* const Divider(
                                            thickness: 2,
                                            indent: 10,
                                            endIndent: 10,
                                            height: 5,
                                            color: Colors.grey,
                                          ),
                                           */
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey[300],
                                            child: /*ação */ Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*analisar */ ElevatedButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        "Atenção"),
                                                                    content:
                                                                        const Text(
                                                                            "Deseja enviar este texto para o cliente analisar novamente?"),
                                                                    actions: [
                                                                      TextButton(
                                                                        //cancelar button
                                                                        child: const Text(
                                                                            "Cancelar"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        //enviar button
                                                                        child: const Text(
                                                                            "Sim"),
                                                                        onPressed:
                                                                            () async {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  'Clientes')
                                                                              .doc(
                                                                                  uid)
                                                                              .collection(
                                                                                  "Posts")
                                                                              .doc(ds
                                                                                  .id)
                                                                              .update({
                                                                            'status':
                                                                                'analisar'
                                                                          });
                                                                          // ignore: use_build_context_synchronously
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                          Fluttertoast.showToast(
                                                                              msg: "Texto enviado com sucesso",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 6,
                                                                              backgroundColor: corFlutterToast,
                                                                              textColor: Colors.black,
                                                                              fontSize: 16.0);
                                                                          //  _color = Colors.blue; // This change Container color
                                                                          //});
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                const CircleBorder(),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            backgroundColor: Colors
                                                                .green, // <-- Button color
                                                            foregroundColor: Colors
                                                                .white, // <-- Splash color
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .content_paste_search_outlined,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        /*excluir post */ ElevatedButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        "Atenção"),
                                                                    content:
                                                                        const Text(
                                                                            "Deseja excluir este texto permanentemente?"),
                                                                    actions: [
                                                                      TextButton(
                                                                        //cancelar button
                                                                        child: const Text(
                                                                            "Cancelar"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        //enviar button
                                                                        child: const Text(
                                                                            "Sim"),
                                                                        onPressed:
                                                                            () async {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection('Clientes')
                                                                              .doc(uid)
                                                                              .collection("Posts")
                                                                              .doc(ds.id)
                                                                              .delete();
                                                                          // ignore: use_build_context_synchronously
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                          Fluttertoast.showToast(
                                                                              msg: "Texto excluído com sucesso!",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 6,
                                                                              backgroundColor: corFlutterToast,
                                                                              textColor: Colors.black,
                                                                              fontSize: 16.0);
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                               const CircleBorder(),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            backgroundColor: Colors
                                                                .red, // <-- Button color
                                                            foregroundColor: Colors
                                                                .white, // <-- Splash color
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .clear_rounded,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*add imagens */ ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => AgenciaAddImage(
                                                                      uid: widget
                                                                          .uid,
                                                                      idpost:
                                                                          ds.id,
                                                                      editpost:
                                                                          ds['post']),
                                                                ));
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                const CircleBorder(),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            backgroundColor: Colors
                                                                .blueAccent, // <-- Button color
                                                            foregroundColor: Colors
                                                                .white, // <-- Splash color
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .add_a_photo_outlined,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        /*excluir imagens */ ElevatedButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        "Atenção"),
                                                                    content:
                                                                        const Text(
                                                                            "Deseja excluir as imagens permanentemente?"),
                                                                    actions: [
                                                                      TextButton(
                                                                        //cancelar button
                                                                        child: const Text(
                                                                            "Cancelar"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        //enviar button
                                                                        child: const Text(
                                                                            "Sim"),
                                                                        onPressed:
                                                                            () async {
                                                                          var collection = FirebaseFirestore
                                                                              .instance
                                                                              .collection("Clientes")
                                                                              .doc(uid)
                                                                              .collection("Posts")
                                                                              .doc(ds.id)
                                                                              .collection("imgs");
                                                                          var snaps =
                                                                              await collection.get();
                                                                          for (var doc
                                                                              in snaps.docs) {
                                                                            await doc.reference.delete();
                                                                          }
                                                                          // ignore: use_build_context_synchronously
                                                                          Navigator.pop(
                                                                              context,
                                                                              false);
                                                                          Fluttertoast.showToast(
                                                                              msg: "Imagens excluídas com sucesso!",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 6,
                                                                              backgroundColor: corFlutterToast,
                                                                              textColor: Colors.black,
                                                                              fontSize: 16.0);
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                const CircleBorder(),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            backgroundColor: Colors
                                                                .orange, // <-- Button color
                                                            foregroundColor: Colors
                                                                .white, // <-- Splash color
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .no_photography_outlined,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // const SizedBox(width: 15,),
                                                        //const Text('Texto:      '),
                                                        /*edit texto */ ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => AgenciaClienteEditTextoPost(
                                                                      uid: widget
                                                                          .uid,
                                                                      idpost: ds
                                                                          .id,
                                                                      editpost:
                                                                          ds['post']),
                                                                ));
                                                          },
                                                          style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                            shape:
                                                                const CircleBorder(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            backgroundColor:
                                                                Colors
                                                                    .grey, // <-- Button color
                                                            foregroundColor:
                                                                Colors
                                                                    .white, // <-- Splash color
                                                          ),
                                                          child: const Icon(
                                                              Icons
                                                                  .edit_note_sharp,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          /* Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey[300],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                /*ação */ Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    /*analisar */ ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Atenção"),
                                                                content: const Text(
                                                                    "Deseja enviar este texto para o cliente analisar novamente?"),
                                                                actions: [
                                                                  TextButton(
                                                                    //cancelar button
                                                                    child: const Text(
                                                                        "Cancelar"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    //enviar button
                                                                    child: const Text(
                                                                        "Sim"),
                                                                    onPressed:
                                                                        () async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Clientes')
                                                                          .doc(
                                                                              uid)
                                                                          .collection(
                                                                              "Posts")
                                                                          .doc(ds
                                                                              .id)
                                                                          .update({
                                                                        'status':
                                                                            'analisar'
                                                                      });
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Texto enviado com sucesso",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              6,
                                                                          backgroundColor:
                                                                              corFlutterToast,
                                                                          textColor: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16.0);
                                                                      //  _color = Colors.blue; // This change Container color
                                                                      //});
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Icon(Icons.check,
                                                          color: Colors.white),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        backgroundColor: Colors
                                                            .green, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    const Text('< ação >'),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    /*excluir post */ ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Atenção"),
                                                                content: const Text(
                                                                    "Deseja excluir este texto permanentemente?"),
                                                                actions: [
                                                                  TextButton(
                                                                    //cancelar button
                                                                    child: const Text(
                                                                        "Cancelar"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    //enviar button
                                                                    child: const Text(
                                                                        "Sim"),
                                                                    onPressed:
                                                                        () async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Clientes')
                                                                          .doc(
                                                                              uid)
                                                                          .collection(
                                                                              "Posts")
                                                                          .doc(ds
                                                                              .id)
                                                                          .delete();
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Texto excluído com sucesso!",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              6,
                                                                          backgroundColor:
                                                                              corFlutterToast,
                                                                          textColor: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16.0);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Icon(
                                                          Icons.clear_rounded,
                                                          color: Colors.white),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        backgroundColor: Colors
                                                            .red, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                /*imagens */ Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    /*add imagens */ ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AgenciaAddImage(
                                                                      uid: widget
                                                                          .uid,
                                                                      idpost:
                                                                          ds.id,
                                                                      editpost:
                                                                          ds['post']),
                                                            ));
                                                      },
                                                      child: Icon(Icons.add,
                                                          color: Colors.white),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        backgroundColor: Colors
                                                            .green, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    const Text('< Imagens >'),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    /*excluir imagens */ ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Atenção"),
                                                                content: const Text(
                                                                    "Deseja excluir as imagens permanentemente?"),
                                                                actions: [
                                                                  TextButton(
                                                                    //cancelar button
                                                                    child: const Text(
                                                                        "Cancelar"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    //enviar button
                                                                    child: const Text(
                                                                        "Sim"),
                                                                    onPressed:
                                                                        () async {
                                                                      var collection = FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "Clientes")
                                                                          .doc(
                                                                              uid)
                                                                          .collection(
                                                                              "Posts")
                                                                          .doc(ds
                                                                              .id)
                                                                          .collection(
                                                                              "imgs");
                                                                      var snaps =
                                                                          await collection
                                                                              .get();
                                                                      for (var doc
                                                                          in snaps
                                                                              .docs) {
                                                                        await doc
                                                                            .reference
                                                                            .delete();
                                                                      }
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Imagens excluídas com sucesso!",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              6,
                                                                          backgroundColor:
                                                                              corFlutterToast,
                                                                          textColor: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16.0);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: Icon(
                                                          Icons.clear_rounded,
                                                          color: Colors.white),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        backgroundColor: Colors
                                                            .red, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                /*  edit texto */ Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // const SizedBox(width: 15,),
                                                    //const Text('Texto:      '),
                                                    /*edit texto */ ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AgenciaClienteEditTextoPost(
                                                                      uid: widget
                                                                          .uid,
                                                                      idpost:
                                                                          ds.id,
                                                                      editpost:
                                                                          ds['post']),
                                                            ));
                                                      },
                                                      child: Icon(
                                                          Icons.edit_note_sharp,
                                                          color: Colors.white),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: CircleBorder(),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        backgroundColor: Colors
                                                            .grey, // <-- Button color
                                                        foregroundColor: Colors
                                                            .white, // <-- Splash color
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                         */
                                        ],
                                        //}).toList()),
                                      ),
                                    ),
                                  ));
                            }));
                  }
                }
              }),
        ],
      ),
    );
  }
}
