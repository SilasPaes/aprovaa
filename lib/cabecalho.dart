import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'auth_service.dart'; 

class Cabecalho extends StatelessWidget {
  const Cabecalho({Key? key}) : super(key: key);

  /* startFirebase() async {
    late FirebaseFirestore database;
    database = DBFirestore.get();
  }
 */
  Future<String> getUserName() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Colaboradores');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uids = user?.uid;
    final result = await users.doc(uids).get();

    return result.get("nome");
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    //bool loading = false;
    return SizedBox(
      //color: corCard,
      /*  decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              corGradiente,
              corPrincipal
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
      ), */
      //  color: Colors.black,
      height: 170,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Colaboradores")
              .doc(auth.usuario?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.transparent,
                ),
              );
            }
            return ListView(children: <Widget>[
              const SizedBox(
                height: 25,
              ),
              Row(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* imagem   */ CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.black,
                    backgroundImage:
                        NetworkImage(snapshot.data?["imagemperfil"]),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(children: <Widget>[
                    //const SizedBox(height: 30),
                    Text("${snapshot.data?["nome"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w200)),
                    Text("${snapshot.data?["especialidade"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ))
                  ]),
                ],
              )
            ]);
          }),
    );
  }
}
