import 'package:flutter/material.dart'; 
import 'ag_homepage.dart';
import 'cor.dart';

class SplashWait extends StatefulWidget {
  const SplashWait({Key? key}) : super(key: key);

  @override
  State<SplashWait> createState() => _SplashWaitState();
}

class _SplashWaitState extends State<SplashWait> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 5500), () {});
    // ignore: use_build_context_synchronously
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AgenciaHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
