class Factura {
  String folio;
  String claveFiscal;
  String fecha;
  double monto;
  double montoIVA;
  String estadoComercial;
  String estadoHacienda;
  String correo;

  Factura(
      {this.folio,
        this.claveFiscal,
        this.fecha,
        this.monto,
        this.montoIVA,
        this.estadoComercial,
        this.estadoHacienda,
        this.correo
      });

  Factura.fromJson(Map<String, dynamic> json) {
    folio = json['folio'];
    claveFiscal = json['claveFiscal'];
    fecha = json['fecha'];
    monto = json['monto'];
    monto = json['montoIVA'];
    estadoComercial = json['estadoComercial'];
    estadoHacienda = json['estadoHacienda'];
    correo = json['emailReceptor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folio'] = this.folio;
    data['claveFiscal'] = this.claveFiscal;
    data['fecha'] = this.fecha;
    data['monto'] = this.monto;
    data['montoIVA'] = this.montoIVA;
    data['estadoComercial'] = this.estadoComercial;
    data['estadoHacienda'] = this.estadoHacienda;
    data['emailReceptor'] = this.correo;
    return data;
  }
}