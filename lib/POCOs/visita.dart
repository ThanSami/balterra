class Visita {
  String idcliente;
  String fecha;
  String nombre;
  String cedula;
  String celular;
  String placa;
  int cantidadpersonas;


  Visita({this.idcliente,
    this.fecha,
    this.nombre,
    this.cedula,
    this.celular,
    this.placa,
    this.cantidadpersonas});

  factory Visita.fromJson(Map<String, dynamic> json) {
    return Visita(
        idcliente: json['idcliente'],
        fecha: json['fecha'],
        nombre: json['nombre'],
        cedula: json['cedula'],
        celular: json['telefono'],
        placa: json['placa'],
        cantidadpersonas: int.parse(json['cantidad'])
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["idcliente"] = idcliente;
    map["fecha"] = fecha;
    map["nombre"] = nombre;
    map["cedula"] = cedula;
    map["telefono"] = celular;
    map["placa"] = placa;
    map["cantidad"] = cantidadpersonas.toString();
    return map;
  }


}