import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ag_cli_aguardando.dart';
import 'ag_cli_analisar.dart';
import 'ag_cli_aprovados.dart';
import 'ag_cli_reprovados.dart';
import 'ag_homepage.dart';
import 'cadastracliente.dart';
import 'cor.dart';

class AgenciaClienteHome extends StatefulWidget {
  const AgenciaClienteHome(
      {super.key, required this.uid, required this.nome, this.imagemperfil});

  final String nome;
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;

  @override
  // ignore: no_logic_in_create_state
  State<AgenciaClienteHome> createState() => _AgenciaClienteHomeState(
        uid: uid,
        nome: nome,
        imagemperfil: imagemperfil,
      );
}

class _AgenciaClienteHomeState extends State<AgenciaClienteHome> {
  _AgenciaClienteHomeState(
      {required this.uid, required this.nome, this.imagemperfil //this.formKey
      });
  // formKey = GlobalKey<FormState>();
  final String nome;
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final imagemperfil;

  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corAppBar,
        title: Text(nome),
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              icon: const Icon(Icons.menu),
              itemBuilder: (context) {
                return [
                  /*  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Cadastrar"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Admin"),
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
                          builder: (context) => const CadastraCliente()));
                } else if (value == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AgenciaHomePage()));
                } else if (value == 2) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Atenção"),
                          content: const Text("Você deseja sair da sua conta?"),
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
      body: PageView(
        controller: pc,
        // ignore: sort_child_properties_last
        children: [
           AgenciaClienteAnalisar(
              uid: uid, nome: nome, imagemperfil: imagemperfil),
           AgenciaClienteAprovados(
              uid: uid, nome: nome, imagemperfil: imagemperfil),
           AgenciaClienteReprovados(
              uid: uid, nome: nome, imagemperfil: imagemperfil),
           AgenciaClienteAguardando(
              uid: uid, nome: nome, imagemperfil: imagemperfil),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.content_paste_search_outlined),
              label: 'Analisar'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.check,
                color: Colors.green[700],
              ),
              label: 'Aprovados'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.clear_outlined,
                color: Colors.red[700],
              ),
              label: 'Reprovados'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_bottom, color: Colors.black),
              label: 'Aguardando'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        // backgroundColor: Colors.grey[100],
      ),
    );
  }
}
