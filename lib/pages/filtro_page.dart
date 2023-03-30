import 'package:app_versao_1_entrega/model/ponto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPage extends StatefulWidget {
  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const CHAVE_USAR_ORDEM_DECRESCENTE = 'usarOrdemDecrescente';
  static const CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {

  final _camposParaOrdenacao = {
    Ponto.CAMPO_ID: 'Código', Ponto.CAMPO_DESCRICAO: 'Descrição',
    Ponto.CAMPO_DATA: 'Data',
  };

  //late final SharedPreferences _prefs;
  SharedPreferences? _prefs;

  final _descricaoController = TextEditingController();
  String _campoOrdenacao = Ponto.CAMPO_ID;
  bool _usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;

    setState(() {
      _campoOrdenacao = _prefs?.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO)
          ?? Ponto.CAMPO_ID;
      _usarOrdemDecrescente =
          _prefs?.getBool(FiltroPage.CHAVE_USAR_ORDEM_DECRESCENTE) ?? false;
      _descricaoController.text =
          _prefs?.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar( title: Text('Filtro e Ordenação'),),
        body: _criarBody(),
      ),
      onWillPop: _onVoltarClick,
    );
  }

  Widget _criarBody() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campo para ordenação'),
        ),
        for (final campo in _camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: _campoOrdenacao,
                onChanged: _onCampoOrdenacaoChanged,
              ),
              Text(_camposParaOrdenacao[campo] ?? ''),
            ],
          ),
        Divider(),
        Row(
          children: [
            Checkbox(
              value: _usarOrdemDecrescente,
              onChanged: _onUsarOrdemDecrescenteChange,
            ),
            Text('Usar ordem decrescente'),
          ],
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            decoration: InputDecoration(labelText: 'O nome começa com',),
            controller: _descricaoController,
            onChanged: _onFiltroDescricaoChange,
          ),
        ),
      ],
    );
  }

  Future<bool> _onVoltarClick() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onCampoOrdenacaoChanged(String? valor) {
    _prefs?.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    _alterouValores = true;
    setState(() {
      _campoOrdenacao = valor ?? '';
    });
  }

  void _onUsarOrdemDecrescenteChange(bool? valor) {
    _prefs?.setBool(FiltroPage.CHAVE_USAR_ORDEM_DECRESCENTE, valor == true);
    _alterouValores = true;
    setState(() {
      _usarOrdemDecrescente = valor == true;
    });
  }

  void _onFiltroDescricaoChange(String? valor) {
    _prefs?.setString(FiltroPage.CHAVE_FILTRO_DESCRICAO, valor ?? '');
    _alterouValores = true;
  }
}
