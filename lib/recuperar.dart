import 'package:balterra/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprintf/sprintf.dart';
import 'constantes.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'principal.dart';

class RecuperarPage extends StatefulWidget{

  @override
  State createState() => RecuperarState();


}

class RecuperarState extends State<RecuperarPage> with SingleTickerProviderStateMixin{

  AnimationController _iconAnimationControler;
  Animation<double> _iconAnimation;
  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  List<dynamic> itemsList = List();
  TextEditingController _usuario = new TextEditingController();

  @override
  void initState(){
    super.initState();
    _iconAnimationControler = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 500)
    );
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationControler,
        curve: Curves.bounceOut
    );
    _iconAnimation.addListener(()=> this.setState(() { }));
    _iconAnimationControler.forward();


  }

  int _mostrarIndicador = 0;

  Widget ShowWaitIndicator()
  {
    switch (_mostrarIndicador)
    {
      case 0:
        return Text("");
        break;
      case 1:
        return CircularProgressIndicator();
        break;
      case 2:
        return AnimatedIcon(icon: AnimatedIcons.menu_home, progress: _iconAnimationControler, color: Colors.indigo, size: 50 );
        break;
    }

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image(
                image: new AssetImage("images/logo.png"),
                width: _iconAnimation.value * 300,
                height: 100.0,
              ),
              new Form(
                key: _formKey,
                child: new Theme(
                  data: new ThemeData(
                      brightness: Brightness.light,
                      primarySwatch: Constantes.colorPrimario,
                      inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                            color: Constantes.colorEtiquetaInput,
                            fontSize: 20.0,
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constantes.colorBorderInputLogin),
                            borderRadius: BorderRadius.circular(15.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Constantes.colorBorderInputLogin),
                            borderRadius: BorderRadius.circular(15.7),
                          )
                      )
                  ),
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: _usuario,
                            decoration: new InputDecoration(
                                labelText: "Identificación"
                            ),
                            keyboardType: TextInputType.text,
                            maxLength: 100,
                            validator: (value) {
                              if  (value.isEmpty){
                                return 'Debe digitar el usuario';
                              }
                              return null;
                            }
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: new MaterialButton(
                            color: Constantes.colorBoton,
                            textColor: Constantes.colorTextoBoton,
                            height: 50.0,
                            minWidth: 100.0,
                            child: new Text(
                              "Solicitar",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: ()=>{
                              if (_formKey.currentState.validate()) {
                                setState((){
                                  _mostrarIndicador = 1;
                                }),
                                _getPassword()
                              }
                            },
                            splashColor: Constantes.colorSplashBoton,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                        ShowWaitIndicator()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );

  }

  Future _getPassword() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapRecuperar,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeRecuperar, [_usuario.text, Constantes.idApp])).catchError((e) {
      setState((){
        _mostrarIndicador = 0;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(sprintf("Error:%s", [e]), style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    });
    var _response = response.body;
    await _parsing(_response);

  }


  Future _parsing(var _response) async {
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.recuperarMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        _mostrarIndicador = 2;
      });

      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Recuperación Contaseña"),
            //content: new Text("Hello World"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                  Center(
                    child: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Icon(
                              parsedJson["Error"] ? Icons.error : Icons.check_circle,
                              color: parsedJson["Error"] ? Colors.red : Colors.green),
                          new Text("Resultado : " + parsedJson["Mensaje"]),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  if (!parsedJson["Error"]) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginPage()),
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ));
    } else
    {
      setState((){
        _mostrarIndicador = 0;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }

    print("itemsList: $resultado");

    /*setState(() {
      _testValue = itemsList[0].toString();
      _add = true;
    });*/

  }

}