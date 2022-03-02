

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videoconferencias_evagd/bbb.dart';
import 'package:videoconferencias_evagd/google_meet.dart';
import 'package:videoconferencias_evagd/jitsi_evagd.dart';
import 'package:videoconferencias_evagd/teams.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Videoconferencias EVAGD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => NewGameScreen(),
        '/bbb': (context) => const BBBPage(),
        '/jitsi_evagd': (context) => const JitsiEVAGD(),
        '/google_meet': (context) => const GoogleMeet(),
        '/teams': (context) => const Teams(),
      },
    );
  }
}

class NewGameScreen extends StatefulWidget {
  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  List<Player> _availablePlayers = [];
  List<Player> _selectedPlayers = [];
  List<Player> _provisionalPlayers = [];
  List<bool> mapa=[false,false,false,false,false,false];
  bool isDialogOn=false;

  @override
  void initState() {
    super.initState();
    _availablePlayers = [
      Player(id: 0, name: "BBB EVAGD", path:'/bbb',
          bools: [true,true,false,true,true,false],picture: 'assets/bbb.png'),
      Player(id: 1, name: "Jitsi EVAGD", path: '/jitsi_evagd',
          bools: [true,false,true,false,true,true], picture: 'assets/jitsi_logo.jpeg'),
      Player(id: 2, name: "Google Meet", path: '/google_meet',
          bools: [false,false,true,false,true,true], picture: 'assets/google_meet.png'),
      Player(id: 3, name: "Microsoft Teams", path: '/teams',
          bools: [false,true,true,false,true,false], picture: 'assets/microsoft_teams.jpeg'),
    ];
    _provisionalPlayers=_availablePlayers;
    //_selectedPlayers=_availablePlayers;
  }

  final ScrollController _scrollController=ScrollController();
  final ScrollController _scrollControllerVertical=ScrollController();

  List<String> casos=['Servidores de la CEUCD','Grabar sesión','Invitar a usuarios externos',
    'Crear salas de grupo','Sala de espera','Compartir pantalla varios usuarios'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Servicios de Videoconferencia")
      ),
      body: ConstrainedBox(
          constraints: BoxConstraints.tight(MediaQuery.of(context).size),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width,100)),
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: mapa.length,
                      itemBuilder: (context, mapIndex) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: mapIndex==0? const Icon(Icons.computer):
                              mapIndex==1? const Icon(Icons.fiber_manual_record):
                              mapIndex==2? const Icon(Icons.supervised_user_circle_sharp):
                              mapIndex==3? const Icon(Icons.meeting_room_outlined):
                              mapIndex==4? const Icon(Icons.timer):
                              mapIndex==5? const Icon(Icons.screen_share_outlined):const Icon(Icons.computer),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(casos[mapIndex]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Checkbox(
                                value: mapa[mapIndex],
                                onChanged: (bool? value) {
                                  mapa[mapIndex]=value!;
                                  _selectedPlayers.clear();
                                  if(!value){
                                    mapa=[false,false,false,false,false,false];
                                    isDialogOn=false;
                                    setState(() {});
                                  }
                                  for(int i=0;i<_availablePlayers.length;i++){
                                    int index=0;
                                    for(int i1=0;i1<mapa.length;i1++){
                                      if(mapa[i1]!=_availablePlayers[i].bools[i1]&&mapa[i1]){
                                        index++;
                                      }
                                    }
                                    print('i=$i index=$index');
                                    if(index==0&&_availablePlayers[i].bools[mapIndex]&&mapa[mapIndex]&&value){
                                      isDialogOn=true;
                                      _selectedPlayers.add(_availablePlayers[i]);
                                      _scrollControllerVertical.jumpTo(0);
                                    }
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  height: 100,
                                  child: VerticalDivider(color: Colors.grey,),
                                )
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollControllerVertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(500,MediaQuery.of(context).size.height)),
                    child: ListView(
                      controller: _scrollControllerVertical,
                      children: [
                        Column(
                          children: _selectedPlayers.isNotEmpty?_selectedPlayers.map((player) {
                            return ListTile(
                              minVerticalPadding: 20,
                              key: ValueKey(player.id),
                              title: TextButton(
                                child: Text(player.name,softWrap: true,),
                                onPressed: (){
                                  Navigator.pushNamed(context, player.path);
                                  //_launchURL(player.path);
                                },
                              ),
                              leading: IconButton(
                                icon: Image(image: AssetImage(player.picture),),
                                iconSize: 50,
                                onPressed: (){
                                  Navigator.pushNamed(context, player.path);
                                },
                              ),
                            );
                          }).toList() :
                          !isDialogOn?_provisionalPlayers.map((player) {
                            return ListTile(
                              minVerticalPadding: 20,
                              key: ValueKey(player.id),
                              title: TextButton(
                                child: Text(player.name),
                                onPressed: (){
                                  Navigator.pushNamed(context, player.path);
                                  //_launchURL(player.path);
                                },
                              ),
                              leading: IconButton(
                                icon: Image(image: AssetImage(player.picture),),
                                iconSize: 50,
                                onPressed: (){
                                  Navigator.pushNamed(context, player.path);
                                },
                              ),
                            );
                          }).toList() :
                          _selectedPlayers.map((player) {
                            return ListTile(
                              minVerticalPadding: 20,
                              key: ValueKey(player.id),
                              title: TextButton(
                                child: Text(player.name),
                                onPressed: (){
                                  Navigator.pushNamedAndRemoveUntil(context, player.path,(route)=>false);
                                  //_launchURL(player.path);
                                },
                              ),
                              leading: IconButton(
                                icon: Image(image: AssetImage(player.picture),),
                                iconSize: 50,
                                onPressed: (){
                                  Navigator.pushNamed(context, player.path);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 200,)
                      ],
                    ),
                  )
                  ,
                ),
              )
            ],
          )
      )
    );
  }
}

Container columnCheck(String string, List<bool> mapa,int index){
  return Container(
    color: mapa[index]?Colors.deepOrangeAccent:const Color.fromARGB(0, 255, 255, 255),
    child: Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                  index==0?Icons.computer:
                  index==1?Icons.fiber_manual_record:
                  index==2?Icons.supervised_user_circle_sharp:
                  index==3?Icons.meeting_room_outlined:
                  index==4?Icons.timer:
                  index==5?Icons.screen_share_outlined:
                  Icons.computer
              ),
            ),
          ),
        ),
        Flexible(
          child:       Column(
            children: [
              const SizedBox(height: 10,),
              Text(string),
              const SizedBox(height: 10,),
              mapa[index]?const Text('X'):const Text(''),
              const SizedBox(height: 20,),
            ],
          )
          ,
        )
      ],
    ),
  );
}

class Player {
  int id;
  String name;
  String picture;
  String path;
  List<bool> bools;

  Player({
    required this.id,
    required this.name,
    required this.picture,
    required this.path,
    required this.bools
  });
}