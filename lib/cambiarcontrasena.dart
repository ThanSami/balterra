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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class CambiarContrasenaPage extends StatefulWidget{

  @override
  State createState() => CambiarContrasenaState();


}

class CambiarContrasenaState extends State<CambiarContrasenaPage> {

  final _formKey = GlobalKey<FormState>();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  TextEditingController _controladorNueva = new TextEditingController();
  TextEditingController _controladorConfirmacion = new TextEditingController();

  List<dynamic> itemsList = List();
  String _contrasenaPreferencias = "";
  String _contrasenaActual = "";
  String _contrasenaNueva = "";
  String _confirmacion = "";
  String _idUsuario = "";

  @override
  void initState(){
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _idUsuario = (prefs.getString('idUsuario') ?? '');
    _contrasenaPreferencias = (prefs.getString('contrasenaActual') ?? '');
  }

  bool _mostrarIndicador = false;


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Cambio de contraseña'),
        backgroundColor: Constantes.colorPrimario,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            image:  new DecorationImage(
              image: new AssetImage("images/borderbackground.jpg"),
              fit: BoxFit.fill,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
            )
        ),
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                  labelText: "Contraseña Actual"
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              maxLength: 20,
                              validator: (value) {
                                if  (value.isEmpty){
                                  return 'Debe digitar la contraseña';
                                }

                                if (value != _contrasenaPreferencias)
                                  {
                                    return 'Contraseña no coincide con la actual';
                                  }
                                return null;
                              },
                              onSaved: (String value) {
                                _contrasenaActual = value;
                              },
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top:10.0),
                          ),
                          new TextFormField(
                            controller: _controladorNueva,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: new InputDecoration(
                                labelText: "Contraseña Nueva"
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            maxLength: 20,
                            validator: (value) {
                              if  (value.isEmpty){
                                return 'Debe digitar la contraseña nueva';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _contrasenaNueva = value;
                            },
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top:10.0),
                          ),
                          new TextFormField(
                            controller: _controladorConfirmacion,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: new InputDecoration(
                                labelText: "Confirmacióm Contraseña"
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            maxLength: 20,
                            validator: (value) {
                              if  (value.isEmpty){
                                return 'Debe digitar la confirmación de contraseña';
                              }

                              if (value != _controladorNueva.text){
                                return 'Contraseña y confirmación deben ser iguales';
                              }

                              return null;
                            },
                            onSaved: (String value) {
                              _confirmacion = value;
                            },
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: new MaterialButton(
                              color: Constantes.colorBoton,
                              textColor: Constantes.colorTextoBoton,
                              height: 50.0,
                              minWidth: 100.0,
                              child: new Text(
                                "Cambiar",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: ()=>{

                                if (_formKey.currentState.validate()) {
                                  setState((){
                                    _mostrarIndicador = true;
                                  }),
                                  _formKey.currentState.save(),
                                  _updatePassword()
                                }
                              },
                              splashColor: Constantes.colorSplashBoton,
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                          ),
                          Visibility(
                            visible: _mostrarIndicador,
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

  }

  Future _updatePassword() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapActualizaContrasena,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeActualizaContrasena, [ _idUsuario, _contrasenaActual, _contrasenaNueva, Constantes.idApp])).catchError((e) {
      setState((){
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(sprintf("Error:%s", [e]), style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    });
    var _response = response.body;
    await _parsing(_response);

  }


  Future _parsing(var _response) async {
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.actualizaContrasenaMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        _mostrarIndicador = false;
      });

      AwesomeDialog(
          context: context,
          dialogType: parsedJson["Error"] ? DialogType.ERROR : DialogType.SUCCES,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'Cambio Contaseña',
          desc:
          "Resultado : " + parsedJson["Mensaje"],
          //btnCancelOnPress: () {},
          btnOkOnPress: () {
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
          })
        ..show();

    } else
    {
      setState((){
        _mostrarIndicador = false;
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