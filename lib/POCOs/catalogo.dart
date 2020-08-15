class Catalogo {
  int id;
  String nombre;

  Catalogo(
      {this.id,
        this.nombre});

  Catalogo.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nombre = json['Nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    return data;
  }
}