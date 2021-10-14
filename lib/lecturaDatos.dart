import 'dart:async';
import 'package:balterra/POCOs/catalogo.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'constantes.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class LecturaDatos extends StatefulWidget {
  final _idTipoToma;
  LecturaDatos(this._idTipoToma);
  @override
  _LecturaDatosState createState() => new _LecturaDatosState(_idTipoToma);
}

class _LecturaDatosState extends State<LecturaDatos> {
  final _formKey = GlobalKey<FormState>();
  final List<DropdownMenuItem> _catalogo = [];
  final Catalogo _datosCatalogo = new Catalogo(id: -1, nombre: "");

  var _keyScaffold = new GlobalKey<ScaffoldState>();
  bool _mostrarIndicador = false;
  int _idCliente = -1;
  double _lectura = 0.00;
  var _idCatalogo;
  String _idUsuario = "";
  String _nombreCliente = "";

  _LecturaDatosState(this._idCatalogo);

  Future<String> getCatalogo() async {
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
    String resultado = _document
        .findAllElements(sprintf("%sResult", [Constantes.catalogoMethod]))
        .elementAt(0)
        .text;

    var parsedJson = json.decode(resultado);

    this.setState(() {
      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i) => Catalogo.fromJson(i)).toList().forEach((catalogo) =>
      {
        _catalogo.add(DropdownMenuItem(
          child: Text(catalogo.nombre),
          value: catalogo.id,
        ))
      });
    });

    return "Success!";
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = (prefs.getString('idUsuario') ?? '');
    });
  }

  @override
  initState() {
    this._datosCatalogo.id = int.parse(_idCatalogo);
    getCatalogo();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _keyScaffold,
        appBar: new AppBar(
          title: new Text('Lecturas'),
        ),
        body: new Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              image:  new DecorationImage(
                image: new AssetImage("images/borderbackground.jpg"),
                fit: BoxFit.fill,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
              )
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scanQR,
                    child: const Text('Leer Código Cliente')
                ),
              ),

              new Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Text(_nombreCliente,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20
                        ),
                      ),
                      SearchableDropdown.single(
                        isExpanded: true,
                        items: _catalogo,
                        value: _datosCatalogo.id,
                        hint: "Seleccione el tipo de toma",
                        searchHint: "Seleccione el tipo de toma",
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            _datosCatalogo.id = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Debe seleccionar el tipo de toma';
                          }
                          return null;
                        },
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                      ),
                      new TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: new InputDecoration(
                            labelText: "Lectura",
                            hintText: "Lectura"
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Debe digitar la lectura';
                          }

                          if (double.parse(value, (e) => null) == null) {
                            return 'La lectura debe ser numérico';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _lectura = double.parse(value);
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

            ],
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
                    "Enviar",
                    style: TextStyle(fontSize: 20),
                  ),
                ]
            ),
            onPressed: ()=>{

              if (_formKey.currentState.validate()) {
                setState(() {
                  _mostrarIndicador = true;
                }),
                _formKey.currentState.save(),
                _enviarLectura()
              }
            },
            splashColor: Constantes.colorSplashBoton,

          ),
        )
    );
  }

  Future<void> scanQRTest() async {
    String barcodeScanRes;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _idCliente = int.parse(barcodeScanRes);
    });

    _getCliente();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _idCliente = int.parse(barcodeScanRes);
    });

    _getCliente();
  }


  Future _enviarLectura() async {
    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapEnviarLectura,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeEnviarLectura, [
          _idCliente,
          _datosCatalogo.id,
          _lectura,
          Constantes.idApp,
          _idUsuario
        ])).catchError((e) {
      setState(() {
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
        sprintf("Error:%s", [e]), style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white));
    });
    var _response = response.body;
    await _parsing(_response);
  }

  Future _parsing(var _response) async {
    var _document = xml.parse(_response);
    String resultado = _document
        .findAllElements(sprintf("%sResult", [Constantes.enviarLecturaMethod]))
        .elementAt(0)
        .text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"]) {
      setState(() {
        _mostrarIndicador = false;
      });

      AwesomeDialog(
          context: context,
          dialogType: parsedJson["Error"] ? DialogType.ERROR : DialogType.SUCCES,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'Registro Lectura',
          desc:
            parsedJson["Mensaje"],
          //btnCancelOnPress: () {},
          btnOkOnPress: () {
            if (!parsedJson["Error"]) {
              Navigator.of(context).pop();
              _lectura = 0.00;
              _idCliente = -1;
            } else {
              Navigator.of(context).pop();
            }
          })
        ..show();

    } else {
      setState(() {
        _mostrarIndicador = false;
      });
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
        parsedJson["Mensaje"], style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white));
    }

    print("itemsList: $resultado");

    /*setState(() {
      _testValue = itemsList[0].toString();
      _add = true;
    });*/

  }


  Future _getCliente() async {
    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapGetCliente,
          "Host": Constantes.host
        },
        body: sprintf(
            Constantes.envelopeGetCliente, [_idCliente, Constantes.idApp]))
        .catchError((e) {
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(
        sprintf("Error:%s", [e]), style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white));
    });
    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.getClienteMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    if (!parsedJson["Error"])
    {
      setState((){
        if (parsedJson["Objeto"]["RazonSocial"] != "")
          {
            _nombreCliente = 'Cliente: ${parsedJson["Objeto"]["RazonSocial"]} ';
          }
        else {
          _nombreCliente = 'Cliente: ${parsedJson["Objeto"]["Nombre"]} ${parsedJson["Objeto"]["Apellidos"]}';
        }
      });

    } else
    {
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(parsedJson["Mensaje"], style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }

  }

}
