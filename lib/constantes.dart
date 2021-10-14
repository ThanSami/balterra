import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Constantes {

  static final Color colorPrimario = Colors.indigo;
  static final Color colorBoton = Colors.indigo;
  static final Color colorBotonSecundario = Colors.blueAccent;
  static final Color colorTextoBoton = Colors.white;
  static final Color colorSplashBoton = Colors.blue;
  static final Color colorEtiquetaInput = Colors.blue;
  static final Color colorBorderInputLogin = Colors.white;

  //Produccion
  /*static String host = "facturas.opuscr.com";
  static String ulrWebService = sprintf("https://%s/ssi/WSCRM/crm.asmx", [host]);*/

  //Produccion
/*static String host = "201.191.122.56";
  static String ulrWebService = sprintf("http://%s/wsFEBuilder/wsFEBuilder.asmx", [host]);*/

  //Pruebas
  static String host = "thanworld";
  static String ulrWebService = sprintf("http://%s/wsFEBuilder/wsFEBuilder.asmx", [host]);

  static String soap = "http://tempuri.org/%s";
  static final String idApp = 'balterra';


  /* Region Login */
  static String loginMethod = "getLoginApp";
  static String urlSoapLogin = sprintf(soap, [loginMethod]);
  static String envelopeLogin =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getLoginApp xmlns=\"http://tempuri.org/\"> <pUsuario>%s</pUsuario> <pPassword>%s</pPassword> <pIdApp>%s</pIdApp></getLoginApp></soap:Body></soap:Envelope>";

  /* Region recuperar contraseña */
  static String recuperarMethod = "getPasswordApp";
  static String urlSoapRecuperar = sprintf(soap, [recuperarMethod]);
  static String envelopeRecuperar =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getPasswordApp xmlns=\"http://tempuri.org/\"> <pUsuario>%s</pUsuario> <pIdApp>%s</pIdApp></getPasswordApp></soap:Body></soap:Envelope>";

  /* Region actualiza contraseña */
  static String actualizaContrasenaMethod = "updatePasswordApp";
  static String urlSoapActualizaContrasena = sprintf(soap, [actualizaContrasenaMethod]);
  static String envelopeActualizaContrasena =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <updatePasswordApp xmlns=\"http://tempuri.org/\"> <pUsuario>%s</pUsuario> <pContransenaActual>%s</pContransenaActual> <pContrasenaNueva>%s</pContrasenaNueva> <pIdApp>%s</pIdApp></updatePasswordApp></soap:Body></soap:Envelope>";

  /* Region Consultar Catalogo */
  static String catalogoMethod = "getCatalogApp";
  static String urlSoapCatalogo = sprintf(soap, [catalogoMethod]);
  static String envelopeCatalogo =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getCatalogApp xmlns=\"http://tempuri.org/\"> <pIdApp>%s</pIdApp></getCatalogApp></soap:Body></soap:Envelope>";

  /* Region envia lectura */
  static String enviarLecturaMethod = "setLecturaApp";
  static String urlSoapEnviarLectura = sprintf(soap, [enviarLecturaMethod]);
  static String envelopeEnviarLectura =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <setLecturaApp xmlns=\"http://tempuri.org/\"> <pidCliente>%s</pidCliente> <pIdCatalogo>%s</pIdCatalogo> <pLectura>%s</pLectura> <pIdApp>%s</pIdApp> <pidUsuario>%s</pidUsuario></setLecturaApp></soap:Body></soap:Envelope>";

  /* Region Consultar facturas */
  static String facturasMethod = "getFacturasApp";
  static String urlSoapFacturas = sprintf(soap, [facturasMethod]);
  static String envelopeFacturas =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getFacturasApp xmlns=\"http://tempuri.org/\"><pCedula>%s</pCedula> <pIdApp>%s</pIdApp></getFacturasApp></soap:Body></soap:Envelope>";

  /* Region Login */
  static String getClienteMethod = "getClienteApp";
  static String urlSoapGetCliente = sprintf(soap, [getClienteMethod]);
  static String envelopeGetCliente =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getClienteApp xmlns=\"http://tempuri.org/\"> <idCliente>%s</idCliente> <pIdApp>%s</pIdApp> </getClienteApp></soap:Body></soap:Envelope>";

  /* Region Visita */
  static String enviarVisitaMethod = "setVisitaApp";
  static String urlSoapEnviarVisita = sprintf(soap, [enviarVisitaMethod]);
  static String envelopeEnviarVisita =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <setVisitaApp xmlns=\"http://tempuri.org/\"> <pIdCliente>%s</pIdCliente> <pFecha>%s</pFecha> <pNombre>%s</pNombre> <pIdentificacion>%s</pIdentificacion> <pTelefono>%s</pTelefono> <pPlaca>%s</pPlaca> <pCantidad>%s</pCantidad> <pIdApp>%s</pIdApp></setVisitaApp></soap:Body></soap:Envelope>";

  static String getHistoricoVisitasMethod = "getHistoricoVisitasApp";
  static String urlSoapHistoricoVisitas = sprintf(soap, [getHistoricoVisitasMethod]);
  static String envelopeHistoricosVisitas =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getHistoricoVisitasApp xmlns=\"http://tempuri.org/\"> <pidentificacion>%s</pidentificacion> <pFechaDesde>%s</pFechaDesde> <pFechaHasta>%s</pFechaHasta> <pIdApp>%s</pIdApp></getHistoricoVisitasApp></soap:Body></soap:Envelope>";

  static String eliminarVisitaMethod = "delVisitaApp";
  static String urlSoapEliminarVisita = sprintf(soap, [eliminarVisitaMethod]);
  static String envelopeEliminarVisita =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <delVisitaApp xmlns=\"http://tempuri.org/\"> <idvisita>%s</idvisita></delVisitaApp></soap:Body></soap:Envelope>";

}