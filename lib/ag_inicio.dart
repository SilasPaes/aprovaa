import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'ag_add_post.dart';
import 'ag_cli_home.dart';
import 'auth_service.dart';
import 'cabecalho.dart';
import 'cor.dart';
import 'telalogin.dart';

class AgenciaInicio extends StatefulWidget {
  const AgenciaInicio({super.key});

  @override
  State<AgenciaInicio> createState() => _AgenciaInicioState();
}

class _AgenciaInicioState extends State<AgenciaInicio> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  bool loading = false;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

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
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                      Navigator.pop(context, true);
                    } else if (Platform.isIOS) {
                      Navigator.pop(context, true);
                      exit(0);
                    }
                  },
                  child: const Text('Sair')),
            ],
          );
        });
  }

  bool _isVisible = false;
  int selectedIndex = -1;

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
            title: const Text('Home'),
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
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AgenciaClientesLista()));
                     */
                    } else if (value == 1) {
                    } else if (value == 2) {
                      await context.read<AuthService>().logout();
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const TelaLogin()));
                    }
                  }),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          corPrincipal,
                          corsegunda,
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
                SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      const Cabecalho(),
                      //const SizedBox(height: 20,),
                      Text("Meus clientes:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: cinza,
                          )),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Colaboradores')
                              .doc(auth.currentUser?.uid)
                              .collection("MeusClientes")
                              .orderBy("nome", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.active:
                              case ConnectionState.done:
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }
                                if (!snapshot.hasData) {
                                  return const Text('Sem dados');
                                }
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data!.docs[index];
                                      return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isVisible = !_isVisible;
                                                selectedIndex = index;
                                              });
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              margin: const EdgeInsets.all(10),
                                              elevation: 20,
                                              color:
                                                  cinza, //_isPressed ? cinza : azul,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      IntrinsicHeight(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            /*buttons*/ Visibility(
                                                              visible: !_isVisible
                                                                  ? _isVisible
                                                                  : selectedIndex ==
                                                                      index,
                                                              //_isVisible,
                                                              child: Row(
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      /*image*/ IconButton(
                                                                        icon: const Icon(
                                                                            Icons.photo),
                                                                        color:
                                                                            corIcone,
                                                                        onPressed:
                                                                            () {
                                                                          Fluttertoast.showToast(
                                                                              msg: "Função indisponível",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 6,
                                                                              backgroundColor: corFlutterToast,
                                                                              textColor: Colors.black,
                                                                              fontSize: 16.0);
                                                                        },
                                                                      ),
                                                                      /*Text*/ IconButton(
                                                                        icon: const Icon(
                                                                            Icons.text_format),
                                                                        color:
                                                                            corIcone,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => AgenciaAddPost(
                                                                                        //suid: widget.uid,
                                                                                        uid: ds['uid'],
                                                                                        nome: ds['nome'],
                                                                                        imagemperfil: ds['imagemperfil'],
                                                                                        sobrenome: ds['sobrenome'],
                                                                                      )));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  /*cliente&DEsfavoritar*/ Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      IconButton(
                                                                        icon: const Icon(
                                                                            Icons.person),
                                                                        color:
                                                                            corIcone,
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => AgenciaClienteHome(
                                                                                        //suid: widget.uid,
                                                                                        uid: ds['uid'],
                                                                                        nome: ds['nome'],
                                                                                        imagemperfil: ds['imagemperfil'],
                                                                                      )));
                                                                        },
                                                                      ),
                                                                      /*remover*/ IconButton(
                                                                        icon: const Icon(
                                                                            Icons.person_off_outlined),
                                                                        color:
                                                                            corIcone,
                                                                        onPressed:
                                                                            () async {
                                                                          return showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: const Text("Atenção"),
                                                                                  content: const Text("Tem certeza que você deseja remover da sua lista de clientes?"),
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
                                                                                        await FirebaseFirestore.instance.collection('Colaboradores').doc(auth.currentUser?.uid).collection("MeusClientes").doc(ds.id).delete();
                                                                                        // ignore: use_build_context_synchronously
                                                                                        Navigator.pop(context, false);
                                                                                        Fluttertoast.showToast(msg: "Cliente removido com sucesso!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 6, backgroundColor: corFlutterToast, textColor: Colors.black, fontSize: 16.0);
                                                                                        //  _color = Colors.blue; // This change Container color
                                                                                        //});
                                                                                      },
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const VerticalDivider(
                                                              width: 40,
                                                              endIndent: 10,
                                                              indent: 10,
                                                              thickness: 4,
                                                              //height: 20,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            /*imagem*/ Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 40.0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          ds['imagemperfil']),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            /*nome*/ Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  ds['nome'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        corTexto,
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ds['sobrenome'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        corTexto,
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ds['especialidade'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style:
                                                                      TextStyle(
                                                                    /* fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold, */
                                                                    color:
                                                                        corTexto,
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    //)
                                                    //}).toList()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ));
                                    });
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

/* import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mktmanager/cabecalho.dart';
import 'package:mktmanager/telalogin.dart';
import 'package:mktmanager/teste.dart';
import 'package:provider/provider.dart';
import 'agencia_add_image.dart';
import 'agencia_cliente_home.dart';
import 'agencia_clientes_lista.dart';
import 'agencia_add_post.dart';
import 'auth_service.dart';
import 'cadastracliente.dart';
import 'cor.dart';
import 'database.dart';
import 'db_firestore.dart';
import 'model_cliente.dart';

class AgenciaInicio extends StatefulWidget {
  const AgenciaInicio({super.key});

  @override
  State<AgenciaInicio> createState() => _AgenciaInicioState();
}

class _AgenciaInicioState extends State<AgenciaInicio> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  bool loading = false;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  getImgProfileFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    //_cropImage(imgXFile!.path);
    setState(() {
      imgXFile;
    });
  }

  late FirebaseFirestore database;
  startFirebase() async {
    database = DBFirestore.get();
  }

  logout() async {
    await context.read<AuthService>().logout();
    //await FirebaseAuth.instance.signOut();
  }

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
          //backgroundColor: Colors.red[200],
          appBar: AppBar(
            backgroundColor: const Color(0xFF000000),
            title: Text('Home'),
            centerTitle: false,
            actions: <Widget>[
              PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  icon: Icon(Icons.menu),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Clientes"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Cadastrar"),
                      ),
                      PopupMenuItem<int>(
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
                              builder: (context) => AgenciaClientesLista()));
                    } else if (value == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastraCliente()));
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
                                    setState(() => loading = false);
                                    logout();
                                    /* await FirebaseAuth.instance.signOut();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TelaLogin()));
 */
                                    //Navigator.pop(context, false);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  }),
            ],
          ),
          body: SafeArea(
            child: Container(
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
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                // borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Container(child: Cabecalho()),
                    //const SizedBox(height: 20,),
                    const Text("Meus clientes:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        )),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Colaboradores')
                            .doc(auth.currentUser?.uid)
                            .collection("MeusClientes")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.hasError)
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              if (!snapshot.hasData)
                                return Text('No data finded!');
                              return ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  //physics: const AlwaysScrollableScrollPhysics(),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot ds =
                                        snapshot.data!.docs[index];
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            margin: const EdgeInsets.all(10),
                                            elevation: 20,
                                            color: Colors.black,
                                            /*    child: Container(
                                                  height: 50,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black,                                            
                                                        Colors.black87,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                   ),*/

                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              //physics: const NeverScrollableScrollPhysics(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*imagem&texto*/ Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            /*image*/ IconButton(
                                                              icon: Icon(
                                                                  Icons.photo),
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AgenciaAddImage(
                                                                              //suid: widget.uid,
                                                                              uid: ds['uid'],
                                                                              nome: ds['nome'],
                                                                              imagemperfil: ds['imagemperfil'],
                                                                            )));
                                                              },
                                                            ),
                                                            /*Edit*/ IconButton(
                                                              icon: Icon(
                                                                  Icons.edit),
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AgenciaAddPost(
                                                                              //suid: widget.uid,
                                                                              uid: ds['uid'],
                                                                              nome: ds['nome'],
                                                                              urlimage: ds['imagemperfil'],
                                                                            )));
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        /*lista&remover*/ Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.list),
                                                              color:
                                                                  Colors.white,
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AgenciaClienteHome(
                                                                              //suid: widget.uid,
                                                                              uid: ds['uid'],
                                                                              nome: ds['nome'],
                                                                              imagemperfil: ds['imagemperfil'],
                                                                            )));
                                                              },
                                                            ),
                                                            /*remover*/ IconButton(
                                                              icon: Icon(Icons
                                                                  .person_off_outlined),
                                                              color:
                                                                  Colors.white,
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
                                                                            const Text("Tem certeza que você deseja remover da sua lista de clientes?"),
                                                                        actions: [
                                                                          TextButton(
                                                                            //cancelar button
                                                                            child:
                                                                                const Text("Cancelar"),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context, false);
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            //enviar button
                                                                            child:
                                                                                const Text("Sim"),
                                                                            onPressed:
                                                                                () async {
                                                                              await FirebaseFirestore.instance.collection('Colaboradores').doc(auth.currentUser?.uid).collection("MeusClientes").doc(ds.id).delete();
                                                                              Navigator.pop(context, false);
                                                                              Fluttertoast.showToast(msg: "Cliente removido com sucesso!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 4, textColor: Colors.white, fontSize: 16.0);
                                                                              //  _color = Colors.blue; // This change Container color
                                                                              //});
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                    });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        /*imagem*/ Column(
                                                          children: [
                                                            /* CircleAvatar(
                                                              radius: 20.0,
                                                              backgroundColor:
                                                                  Colors.black,
                                                              backgroundImage:
                                                                  NetworkImage(ds[
                                                                      'imagemperfil']),
                                                            ), */
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        /*nome*/
                                                        Column(
                                                          children: [
                                                            Text(
                                                              ds['nome'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style:
                                                                  const TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  //)
                                                  //}).toList()),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  });
                          }
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
 */
