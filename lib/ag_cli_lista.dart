import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; 
import 'ag_cli_editar_perfil.dart';
import 'cadastracliente.dart';
import 'cor.dart';

class AgenciaClientesLista extends StatefulWidget {
  const AgenciaClientesLista({super.key});

  @override
  State<AgenciaClientesLista> createState() => _HomePageAgencia();
}

class _HomePageAgencia extends State<AgenciaClientesLista> {
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
          title: const Text("Clientes"),
          centerTitle: false,
          actions: <Widget>[
            PopupMenuButton(
                // add icon, by default "3 dot" icon
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AgenciaClientesLista()));
                  } else if (value == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CadastraCliente()));
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
                    .collection("Clientes")
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
                      if (!snapshot.hasData) return const Text('Sem dados');
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
                                        color: azul, //corCard,
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
                                                      /*botao2*/ Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.star),
                                                            color: corIcone,
                                                            onPressed:
                                                                () async {
                                                              return showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Atenção"),
                                                                      content:
                                                                          const Text(
                                                                              "Tem certeza que ele é seu cliente?"),
                                                                      actions: [
                                                                        TextButton(
                                                                          //cancelar button
                                                                          child:
                                                                              const Text("Cancelar"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context,
                                                                                false);
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          //enviar button
                                                                          child:
                                                                              const Text("Sim"),
                                                                          onPressed:
                                                                              () async {
                                                                            await FirebaseFirestore.instance.collection('Colaboradores').doc(auth.currentUser?.uid).collection("MeusClientes").doc(ds.id).set({
                                                                              'nome': ds['nome'],
                                                                              'sobrenome': ds['sobrenome'],
                                                                              'uid': ds['uid'],
                                                                              'imagemperfil': ds['imagemperfil'],
                                                                              'especialidade': ds['especialidade']
                                                                            });
                                                                            // ignore: use_build_context_synchronously
                                                                            Navigator.pop(context,
                                                                                false);
                                                                            Fluttertoast.showToast(
                                                                                msg: "Cliente seu!",
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

                                                              /*  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                                  AgenciaClienteHome(
                                                                                    //suid: widget.uid,
                                                                                    uid:
                                                                                        ds['uid'],
                                                                                    nome:
                                                                                        ds['nome'],
                                                                                    imagemperfil:
                                                                                        ds['imagemperfil'],
                                                                                  ))); */
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.edit),
                                                            color: corIcone,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => AgenciaClienteEditarPerfil(
                                                                          //suid: widget.uid,
                                                                          uid: ds['uid'],
                                                                          nome: ds['nome'],
                                                                          sobrenome: ds['sobrenome'],
                                                                          imagemperfil: ds['imagemperfil'],
                                                                          especialidade: ds['especialidade'])));
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      /*  /*botao*/ Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.photo),
                                                            color: corIcone,
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.edit),
                                                            color: corIcone,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AgenciaAddPost(
                                                                                //suid: widget.uid,
                                                                                uid: ds['uid'],
                                                                                nome: ds['nome'],
                                                                                imagemperfil: ds['imagemperfil'],
                                                                              )));
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                       */
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
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: corTexto,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            ds['especialidade'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
