import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  
import 'cor.dart';

class AgenciaColegasLista extends StatefulWidget {
  const AgenciaColegasLista({super.key});

  @override
  State<AgenciaColegasLista> createState() => _AgenciaColegasLista();
}

class _AgenciaColegasLista extends State<AgenciaColegasLista> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Clientes');
  FirebaseAuth auth = FirebaseAuth.instance;

  bool sairdoapp = false;
  Future<bool?> showConfirmaSairdoApp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja sair do App?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sair'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!sairdoapp) {
          final confirmaSairdoApp = await showConfirmaSairdoApp();
          return confirmaSairdoApp ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: corAppBar,
          title: const Text("Equipe"),
          centerTitle: false,
          actions: <Widget>[
            PopupMenuButton(
                icon: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return [
                    /* const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Clientes"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Cadastrar"),
                    ), */
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Logout"),
                    ),
                  ];
                },
                onSelected: (value) async {
                  if (value == 0) {
                  } else if (value == 1) {
                  } else if (value == 2) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Atenção"),
                            content:
                                const Text("Você deseja sair da sua conta?"),
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
                                  await FirebaseAuth.instance.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, false);
                                },
                              )
                            ],
                          );
                        });
                  }
                }),
          ],
        ),
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
                    .collection("Colaboradores")
                    .orderBy("nome", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) return Text('${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return const Text('Sem dados');
                      }
                      return Center(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data!.docs[index];
                                return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        margin: const EdgeInsets.all(10),
                                        elevation: 20,
                                        color: marrom, //Colors.brown,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              //mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      /*botao*/ Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.message),
                                                            color: corIcone,
                                                            onPressed: () {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Função indisponível",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      6,
                                                                  backgroundColor:
                                                                      corFlutterToast,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0);
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.edit),
                                                            color: corIcone,
                                                            onPressed: () {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Função indisponível",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      6,
                                                                  backgroundColor:
                                                                      corFlutterToast,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0);

                                                              /*  Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AgenciaAddPost(
                                                                            //suid: widget.uid,
                                                                            uid: ds[
                                                                                'uid'],
                                                                            nome: ds[
                                                                                'nome'],
                                                                            imagemperfil: ds[
                                                                                'imagemperfil'],
                                                                          )));
                                                             */
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      const VerticalDivider(
                                                        width: 40,
                                                        endIndent: 10,
                                                        indent: 10,
                                                        thickness: 4,
                                                        //height: 20,
                                                        color: Colors.black,
                                                      ),
                                                      /*imagem*/ Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius: 30.0,
                                                            backgroundImage:
                                                                NetworkImage(ds[
                                                                    'imagemperfil']),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      /*nome especialidade*/ Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            ds['nome'] +
                                                                ' ' +
                                                                ds['sobrenome'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              color: corTexto,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            ds['especialidade'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              color: corTexto,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              //}).toList()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              }));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
