import 'dart:async';
import 'dart:convert';
import 'package:balterra/scanscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'constantes.dart';
import 'package:sprintf/sprintf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListaFacturas extends StatefulWidget {
  @override
  State createState() => ListaFacturasState();

}

class ListaFacturasState extends State<ListaFacturas> {

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  List data;
  String _idUsuario = "";
  String _email = "";
  String _nombreUsuario = "";
  String _tipoUsuario = "";
  var _keyScaffold = new GlobalKey<ScaffoldState>();

  Future<String> getData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('idUsuario') ?? '');
      _nombreUsuario = (prefs.getString('nombreUsuario') ?? '');
      _email = (prefs.getString('correoUsuario') ?? '');
      _tipoUsuario = (prefs.getString('tipoUsuario') ?? '');
    });

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapFacturas,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeFacturas, [ _idUsuario, Constantes.idApp]));

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.facturasMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (parsedJson["Error"])
      {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
      }
    else {
      this.setState(() {
        data = parsedJson["Objeto"];
      });
    }


    return "Success!";
  }


  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _keyScaffold,
      appBar: new AppBar(title: new Text("Lista Facturas"), backgroundColor: Constantes.colorPrimario ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new GestureDetector(
            child: new Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                            children: <Widget>[
                              new Text(data[index]["folio"]),
                              new Text(data[index]["fecha"]),
                            ],
                          )
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                            children: <Widget>[
                              new Text(oCcy.format(data[index]["monto"])),
                              new Text(oCcy.format(data[index]["montoIVA"])),
                            ],
                          )
                      )
                    ],
                  )
              ),
              elevation: 5,
            ),
            onTap:  ()=>{

            },
          );
        },
      ),
    );
  }

}