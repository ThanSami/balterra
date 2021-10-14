import 'dart:core';
import 'dart:ui';
import 'package:flutter/services.dart';
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
import 'package:balterra/POCOs/visita.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

class VisitaPage extends StatefulWidget{

  @override
  State createState() => VisitaPageState();


}

class VisitaPageState extends State<VisitaPage> {

  GlobalKey globalKey = GlobalKey();
  double bodyHeight;
  static const MethodChannel _channel = const MethodChannel('wc_flutter_share');

  final _formKey = GlobalKey<FormState>();
  var _keyScaffold = new GlobalKey<ScaffoldState>();

  String _idUsuario = "";

  TextEditingController fechaInicioController;
  DateTime _fechaInicio;

  TextEditingController nombreController = new TextEditingController();
  TextEditingController placaController = new TextEditingController();
  TextEditingController cedulaController = new TextEditingController();

  List<dynamic> itemsList = List();

  Visita _visita = new Visita(
      idcliente: "",
      fecha: "",
      nombre: "",
      cedula: "",
      celular: "",
      cantidadpersonas: 0,
      placa: ""
  );

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _idUsuario = (prefs.getString('idUsuario') ?? '');
    _visita.idcliente = _idUsuario;
  }

  @override
  void initState(){
    _loadUser();
  }

  bool _mostrarIndicador = false;


  @override
  Widget build(BuildContext context) {

    bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return new Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Registro Visita'),
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
        child: SingleChildScrollView(
          child: new Column(
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
                          contentPadding: const EdgeInsets.only(left: 5.0, bottom: 8.0, top: 8.0),
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
                    padding: const EdgeInsets.all(30.0),
                    height: MediaQuery.of(context).size.height,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top:5.0),
                        ),
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  print("onTap fecha inicio");
                                  _showDatePickerInicio();
                                },
                                child: Icon(Icons.date_range),
                              ),
                            ),
                            Container(
                              child: new Flexible(
                                  child: new TextField(
                                      decoration: InputDecoration(
                                          labelText: "Fecha",
                                          hintText: "Fecha",
                                          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                      maxLines: 1,
                                      readOnly: true,
                                      controller: fechaInicioController)),
                            ),
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:10.0),
                        ),
                        new TextFormField(
                          controller: nombreController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Nombre",
                              hintText: "Nombre",
                              icon: const Icon(Icons.person)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar el nombre';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            setState(() {
                              _visita.nombre = value;
                            });
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          controller: cedulaController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Cédula",
                              hintText: "Cédula",
                              icon: const Icon(Icons.credit_card)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 12,
                          onSaved: (String value) {

                            setState(() {
                              _visita.cedula = value;
                            });


                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Celular ",
                              hintText: "Celular ",
                              icon: const Icon(Icons.settings_cell)
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onSaved: (String value) {
                            setState(() {
                              _visita.celular = value;
                            });
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          controller: placaController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "# Placa",
                              hintText: "# Placa",
                              icon: const Icon(Icons.aspect_ratio)
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          onSaved: (String value) {
                            setState(() {
                              _visita.placa = value;
                            });
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top:2.0),
                        ),
                        new TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                              labelText: "Cantidad Personas",
                              hintText: "Cantidad Personas",
                              icon: const Icon(Icons.people)
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          validator: (value) {
                            if  (value.isEmpty){
                              return 'Debe digitar cantidad de personas';
                            }

                            return null;
                          },
                          onSaved: (String value) {
                            _visita.cantidadpersonas = int.parse(value);
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Visibility(
                          visible: _mostrarIndicador,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Constantes.colorPrimario,
        child: FlatButton(
          color: Constantes.colorPrimario,
          textColor: Constantes.colorTextoBoton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Icon(Icons.save),
              SizedBox(width: 10,),
              new Text(
                "Guardar",
                style: TextStyle(fontSize: 20),
              ),
            ]
          ),
          onPressed: ()=>{

            if (_formKey.currentState.validate()) {
              setState((){
                _mostrarIndicador = true;
              }),
              _formKey.currentState.save(),

              _sendVisita()
            }
          },
          splashColor: Constantes.colorSplashBoton,

        ),
      ),
    );

  }

  Future _sendVisita() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapEnviarVisita,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeEnviarVisita, [_visita.idcliente, _visita.fecha, _visita.nombre, _visita.cedula, _visita.celular, _visita.placa, _visita.cantidadpersonas.toString(), Constantes.idApp])).catchError((e) {
      setState((){
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(sprintf("Error:%s", [e]), style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    });
    var _response = response.body;
    await _parsing(_response);

  }


  Future _parsing(var _response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.enviarVisitaMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        _mostrarIndicador = false;
      });
      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'Nueva Visita',
          desc:
          parsedJson["Mensaje"],
          //btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Principal()),
            );
          })
        ..show();


    } else
    {
      setState((){
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }


  }

  Future<Null> _showDatePickerInicio() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now()
            .year - 1, 1),
        lastDate: DateTime(DateTime
            .now()
            .year, 12));

    if (picked != null) {
      setState(() {
        _fechaInicio = picked;
        fechaInicioController =
        new TextEditingController(text:
        "${picked.day}/${picked.month}/${picked.year}");
        _visita.fecha = "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }


}