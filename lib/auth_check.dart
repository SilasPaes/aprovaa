import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'telalogin.dart';
import 'wait.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthCheckState createState() => _AuthCheckState();
}
/* 
Future<User> isAdmin(String nominho) async {
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  final DocumentSnapshot db = await FirebaseFirestore.instance
      .collection('Clientes')
      .doc(currentUserUid)
      .get();

  var nominho = db['nome'];
  return nominho;
} */

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return const TelaLogin();
    } else {
      return const SplashWait();
    }
    //return ClienteHomePage();
    // return AuthCheck2();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => CadastraCliente()));
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mktmanager/agenciaaddpost.dart';
import 'package:mktmanager/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:mktmanager/cliente_tela_analisar.dart';
import 'package:mktmanager/homepageagencia.dart';
import 'package:mktmanager/telalogin.dart';
import 'package:mktmanager/teste.dart';
import 'package:mktmanager/ztela_login_cadastrar.dart';
import 'package:provider/provider.dart';

import 'cliente_home_page.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}
Future<User> isAdmin(String nominho) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final DocumentSnapshot db = await FirebaseFirestore.instance
        .collection('Clientes')
        .doc(currentUserUid)
        .get();

    var nominho = db['nome'];
    return nominho;
  }

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    String email;
    var nominho;

    if (auth.isLoading)
      return loading();
    else if (auth.usuario == null)
      return TelaLogin();
    else // if (auth.usuario == nominho) 
    return ClienteHomePage();
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
 */
