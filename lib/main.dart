import 'package:app_versao_1_entrega/pages/filtro_page.dart';
import 'package:app_versao_1_entrega/pages/lista_pontos_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CadastroApp());
}

class CadastroApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Pontos Turísticos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaPontosPage(),
      routes: {
        FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
      },
    );
  }

}
