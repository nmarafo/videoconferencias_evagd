import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TalkNube extends StatelessWidget {
  const TalkNube({Key? key}) : super(key: key);

  void _launchURL(String path) async {
    if (!await launch(path)) throw 'Could not launch $path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pulse para navegar al lugar de la videoconferencia (Talk nube_Medusa)',style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 50,),
                  const Image(image: AssetImage('assets/Talk_tutorial.jpg'),),
                  const SizedBox(height: 50,),
                  ElevatedButton(
                      onPressed: () =>  Navigator.pushNamedAndRemoveUntil(context, '/',(route)=>false),
                      child: const Icon(Icons.arrow_back,color: Colors.white,size: 50,)
                  )
                ],
              ),
              onTap: (){
                _launchURL('https://nube.canariaseducacion.org/index.php/apps/spreed/');
              },
            ),

          )
        ],
      ),
    );
  }
}
