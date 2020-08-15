import 'dart:async';
import 'dart:convert';
import 'package:balterra/scanscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'constantes.dart';
import 'package:sprintf/sprintf.dart';

class ListaTomas extends StatefulWidget {
  @override
  State createState() => ListaTomasState();

}

class ListaTomasState extends State<ListaTomas> {

  List data;

  Future<String> getData() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapCatalogo,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeCatalogo, [Constantes.idApp]));

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.catalogoMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {
      data = parsedJson["Objeto"];
    });

    print(data[1]["Nombre"]);

    return "Success!";
  }

  @override
  void initState(){
    this.getData();
  }

  _navegar(String key) {

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ScanScreen(key),
        ));
    /*switch (key)
    {
      case "PT-P05-R01":
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PTP05R01(),
            ));*/
        break;
    }*/

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Lista Registros"), backgroundColor: Constantes.colorPrimario ),
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
                              new Text(data[index]["Nombre"]),
                              new Text(data[index]["Codigo"]),
                            ],
                          )
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child:Image(image: AssetImage('images/rightarrow.png'), height: 30, )
                      )
                    ],
                  )
              ),
              elevation: 5,
            ),
            onTap:  ()=>{
              _navegar(data[index]["ID"].toString())
            },
          );
        },
      ),
    );
  }

}