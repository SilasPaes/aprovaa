import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'ag_cli_lista.dart';
import 'ag_col_lista.dart';
import 'ag_inicio.dart';

class AgenciaHomePage extends StatefulWidget {
  const AgenciaHomePage({super.key});

  @override
  State<AgenciaHomePage> createState() => _AgenciaHomePageState();
}

class _AgenciaHomePageState extends State<AgenciaHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  bool loading = false;
  String? imageUrl;

  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    setState(() {});
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  getImgProfileFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    //_cropImage(imgXFile!.path);
    setState(() {
      imgXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final User? user = auth.currentUser;
    //final uids = user?.uid;
    return SafeArea(
        child: Scaffold(
       body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const AgenciaInicio(),
          const AgenciaClientesLista(),
          const AgenciaColegasLista(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 155, 155, 155)),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              icon:
                  Icon(Icons.person, color: Color.fromARGB(255, 102, 127, 139)),
              label: 'Clientes'),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                color: Color.fromARGB(255, 123, 86, 73),
              ),
              label: 'Equipe'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Conta'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
      ),
    ));
  }
}
