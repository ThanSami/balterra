import 'package:balterra/cambiarcontrasena.dart';
import 'package:balterra/listavisitas.dart';
import 'package:balterra/visitaPage.dart';
import 'package:flutter/material.dart';
import 'constantes.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'listatomas.dart';
import 'listafacturas.dart';

class Principal extends StatefulWidget{


  @override
  State createState() => PrincipalState();
}

class PrincipalState extends State<Principal> {
  final appTitle = 'Menu Principal';
  String _idUsuario = "";
  String _email = "";
  String _nombreUsuario = "";
  String _tipoUsuario = "";

  List<ListTile> listaMenu = [];

  _clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('idUsuario') ?? '');
      _nombreUsuario = (prefs.getString('nombreUsuario') ?? '');
      _email = (prefs.getString('correoUsuario') ?? '');
      _tipoUsuario = (prefs.getString('tipoUsuario') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        backgroundColor: Constantes.colorPrimario,
        actions: <Widget>[
         /*Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.more_vert
                ),
              )
          ),*/
          PopupMenuButton<int>( // overflow menu
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: (_tipoUsuario=="C"),
                value: 1,
                child:Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Text('Cambiar contraseña'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    Text('Salir'),
                  ],
                ),
              ),
            ],
            onSelected: (value){
              switch(value)
              {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CambiarContrasenaPage()),
                  );
                  break;
                case 2:
                  _clearUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()),
                  );
                  break;
              }
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(child: Image(image: AssetImage('images/logo.png'), height: 200,) ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: _buildDrawerList(context)
        ),
      ),
    );
  }

  List<Widget> _buildDrawerList(BuildContext context) {
    List<Widget> children = [];
    children..addAll(_buildUserAccounts(context));

    if (_tipoUsuario == 'U') children..addAll(_tomaDatos(context));
    if (_tipoUsuario == 'C') {
      children..addAll(_agregarVisita(context))
        ..add( Divider(
            color: Colors.grey.shade300,
            thickness: 2.0))
        ..add(Text("Consultas",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
            )),)
        ..addAll(_listaFacturas(context))
        ..addAll(_listaVisitas(context));

    }

      //..addAll([new Divider()])
      //..addAll(_buildLabelWidgets(context))
      //..addAll(_buildActions(context))
      //..addAll([new Divider()])
      //..addAll(_buildSettingAndHelp(context));
      return children;

  }

  List<Widget> _buildUserAccounts(BuildContext context) {
    return [
      new UserAccountsDrawerHeader(
          accountName: Text(_nombreUsuario),
          accountEmail: Text(_email == '' ? _idUsuario : _email),
          currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white70,
              backgroundImage: AssetImage('images/myAvatar.png'),
          ),
      )
    ];
  }

  List<Widget> _tomaDatos(BuildContext context) {
    return [
      new ListTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.art_track),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Toma datos'),
            )
          ],
        ),
        onTap: () =>
        {
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListaTomas()),
          )
        },
      ),
    ];
  }

  List<Widget> _listaFacturas(BuildContext context) {
    return [
      new ListTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.format_list_numbered),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Lista de Facturas'),
            )
          ],
        ),
        onTap: () =>
        {
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListaFacturas()),
          )
        },
      ),
    ];
  }

  List<Widget> _listaVisitas(BuildContext context) {
    return [
      new ListTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.line_weight),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Histórico Visitas'),
            )
          ],
        ),
        onTap: () =>
        {
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListaVisitasPage()),
          )
        },
      ),
    ];
  }

  List<Widget> _agregarVisita(BuildContext context) {
    return [
      new ListTile(
        title: Row(
          children: <Widget>[
            Icon(Icons.people),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Nueva Visita'),
            )
          ],
        ),
        onTap: () =>
        {
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VisitaPage()),
          )
        },
      ),
    ];
  }
}

