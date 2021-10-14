import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'constantes.dart';
import 'package:sprintf/sprintf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaVisitasPage extends StatefulWidget {
  @override
  State createState() => ListaVisitasState();

}

class ListaVisitasState extends State<ListaVisitasPage> {


  List data;
  var _keyScaffold = new GlobalKey<ScaffoldState>();
  bool _mostrarSpinner = false;
  String _idUsuario = "";
  String _fechaInicioConsulta = "";
  String _fechaFinConsulta = "";
  int idVisita = 0;


  TextEditingController fechaInicioController = new TextEditingController();
  TextEditingController fechaFinController = new TextEditingController();

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('idUsuario') ?? '');
    });
  }


  @override
  void initState(){
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _keyScaffold,
      appBar: new AppBar(title: new Text("Lista Visitas"), backgroundColor: Constantes.colorPrimario ),
      body: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            image:  new DecorationImage(
              image: new AssetImage("images/borderbackground.jpg"),
              fit: BoxFit.fill,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.05), BlendMode.dstATop),
            )
        ),
        child: Form(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(child:
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
                                      labelText: "Desde",
                                      hintText: "Fecha Inicio",
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                  maxLines: 1,
                                  readOnly: true,
                                  controller: fechaInicioController)),
                        ),
                      ],
                    ),
                    ),
                    Expanded(
                      child: new Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                print("onTap fecha fin");
                                _showDatePickerFin();
                              },
                              child: Icon(Icons.date_range),
                            ),
                          ),
                          Container(
                            child: new Flexible(
                                child: new TextField(
                                    decoration: InputDecoration(
                                        labelText: "Hasta",
                                        hintText: "Fecha Fin",
                                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                    maxLines: 1,
                                    readOnly: true,
                                    controller: fechaFinController)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Visibility(
                  visible: _mostrarSpinner,
                  child: CircularProgressIndicator(
                  ),
                ),
                Expanded(
                  child: new ListView.builder(
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, int index){
                      final item = data[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key(data[index]["id"].toString()),
                        // Provide a function that tells the app
                        // what to do after an item has been swiped away.
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Desea eliminar la visita?"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
                                        child: new SingleChildScrollView(
                                          child: new ListBody(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.priority_high,
                                                color: Constantes.colorPrimario,
                                                size: 60,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("Eliminar")
                                  ),
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Cancelar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          // Remove the item from the data source.
                          setState(() {
                            idVisita = data[index]["idVisita"];
                            data.removeAt(index);
                            _mostrarSpinner = true;
                          });

                          _delVisita();
                          // Then show a snackbar.
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text("${data[index]["Nombre"]} eliminado")));
                        },
                        // Show a red background as the item is swiped away.
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.redAccent,
                          child: Icon(Icons.delete, color: Colors.grey.shade900,),
                        ),
                        child: new GestureDetector(
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
                                            new Text('Nombre: ${data[index]["Nombre"]}'),
                                            new Text('Fecha: ${data[index]["FechaFormateada"]}'),
                                          ],
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start ,
                                          children: <Widget>[
                                            new Text('Identificación: ${data[index]["Identificacion"] }'),
                                            new Text('Telefono: ${data[index]["Telefono"]}'),
                                          ],
                                        )
                                    )
                                  ],
                                )
                            ),
                            elevation: 5,
                          ),
                          onTap:  ()=>{
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditarVisitaPage( int.parse(data[index]["id"]))),
                            )*/
                          },
                        ),
                      );
                    },
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: ()=>{
                    setState((){
                      _mostrarSpinner = true;
                    }),
                    _getVisitas()
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VisitaPage()),
                    )*/
                  },
                  label: Text('Consultar'),
                  icon: Icon(Icons.search),
                  backgroundColor: Constantes.colorPrimario,
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
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
        DateTime _fechaInicio = picked;
        fechaInicioController = new TextEditingController(text: "${picked.day}/${picked.month}/${picked.year}");
        _fechaInicioConsulta = "${picked.year}-${picked.month}-${picked.day}";
      });

    }
  }

  Future<Null> _showDatePickerFin() async {
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
        DateTime _fechaFin = picked;
        fechaFinController = new TextEditingController(text: "${picked.day}/${picked.month}/${picked.year}");
        _fechaFinConsulta = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future _getVisitas() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapHistoricoVisitas,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeHistoricosVisitas, [_idUsuario, _fechaInicioConsulta, _fechaFinConsulta, Constantes.idApp])).catchError((e) {
      setState((){
        _mostrarSpinner = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(sprintf("Error:%s", [e]), style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    });
    var _response = response.body;
    await _parsing(_response);

  }

  Future _parsing(var _response) async {

    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.getHistoricoVisitasMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        _mostrarSpinner = false;
        data = parsedJson["Objeto"];
      });

    } else
    {
      setState((){
        _mostrarSpinner = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }

  }

  Future _delVisita() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapEliminarVisita,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeEliminarVisita, [idVisita])).catchError((e) {
      setState((){
        _mostrarSpinner = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(sprintf("Error:%s", [e]), style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    });
    var _response = response.body;

    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.eliminarVisitaMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        _mostrarSpinner = false;
      });

    } else
    {
      setState((){
        _mostrarSpinner = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }


  }

}
