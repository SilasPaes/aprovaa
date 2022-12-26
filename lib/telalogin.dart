import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'cadastracliente.dart';
import 'cor.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  late FirebaseFirestore db;
  late AuthService auth;

  //final FirebaseAuth _auth = FirebaseAuth.instance;

  bool mostrarSenha = false;

  @override
  void initState() {
    //PreferenciaTema();
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      } else {
        actionButton = 'Cadastrar';
        toggleButton = 'Fazer Login.';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              /* decoration: BoxDecoration(
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
               */ //backgroundColor: Colors.yellow[100],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Bem-vindo",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              hoverColor: Colors.white,
                              icon: Icon(Icons.email, color: Colors.black),
                              labelText: 'E-mail',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o e-mail corretamente!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          child: TextFormField(
                            controller: senha,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.key, color: Colors.black),
                              border: const OutlineInputBorder(),
                              labelText: 'Senha',
                              suffixIcon: GestureDetector(
                                child: Icon(
                                    mostrarSenha == false
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black),
                                onTap: () {
                                  setState(() {
                                    mostrarSenha = !mostrarSenha;
                                  });
                                },
                              ),
                            ),
                            obscureText: mostrarSenha == false ? true : false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informa sua senha!';
                              } else if (value.length < 6) {
                                return 'Sua senha deve ter no mínimo 6 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corButton1,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (isLogin) {
                                  login();
                                } else {
                                  //CadastraCliente();
                                }
                              }
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
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          actionButton,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                            ),
                          ),
                        ),
                        /*  Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () async {
                                    (loading);
                                    if (formKey.currentState!.validate()) {
                                      //if (isLogin) {
                                      //  if (auth.usuario == null) {
                                      login();
                                      /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AgenciaHomePage(),
                                          )); */
                                      // });
                                      //setState(() => loading = true);
                                      // } else {
                                      //CadastraCliente();
                                      // }
                                    }
                                  },
                                  child: Text('login')),
                            ),
                             */
                        TextButton(
                          //onPressed: () => setFormAction(!isLogin),
                          onPressed: () {
                            //setFormAction(!isLogin);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CadastraCliente()));
                          },
                          child: Text(
                            toggleButton,
                            style: const TextStyle(
                                //fontSize: 35,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
