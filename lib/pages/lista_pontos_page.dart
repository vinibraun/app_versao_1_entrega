import 'package:flutter/material.dart';
import '../model/ponto.dart';
import '../widgets/cadastro_ponto_form.dart';
import 'filtro_page.dart';

class ListaPontosPage extends StatefulWidget {

  @override
  _ListaPontosPageState createState() => _ListaPontosPageState();

}

class _ListaPontosPageState extends State<ListaPontosPage> {

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final _pontos = <Ponto>[
    Ponto(id: 1, descricao: 'Somália', data: DateTime.now().add(Duration(days: 0)), diferenciais: ''),
  ];

  var _ultimoId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Ponto',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar() {

    return AppBar(
      title: Text('Pontos Turísticos'),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: _abrirPaginaFiltro,
        ),
      ],
    );
  }

  Widget _criarBody() {
    if (_pontos.isEmpty) {
      return Center(child: Text('Nenhuma ponto cadastrada',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
      ),);
    }

    return ListView.separated(
      itemCount: _pontos.length,
      itemBuilder: (BuildContext context, int index) {
        final ponto = _pontos[index];

        return PopupMenuButton<String>(

          child: ListTile(
            title: Text('${ponto.id} - ${ponto.descricao}'),
            subtitle: Text('${ponto.diferenciais}'),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text(ponto.dataFormatada)
          ])),
            itemBuilder: (BuildContext context) => criarItensMenuPopup(),
            onSelected: (String valorSelecionado) {
              if (valorSelecionado == ACAO_EDITAR) {
                _abrirForm(pontoAtual: ponto, indice: index);
              } else {
                _excluir(index);
              }
            },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopup() {
    return [
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            ),
          ],
        ),
      ),

    ];
  }

  void _abrirForm({Ponto? pontoAtual, int? indice}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pontoAtual == null
              ? 'Novo Ponto' : 'Alterar Ponto (${pontoAtual.id})'),
          content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual),
          actions: [
            TextButton(child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (key.currentState != null &&
                    key.currentState!.dadosValidos()) {
                  setState(() {
                    final novoPonto = key.currentState!.novoPonto;
                    if (indice == null) {
                      novoPonto.id = ++_ultimoId;
                      _pontos.add(novoPonto);
                    } else {
                      _pontos[indice] = novoPonto;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _excluir(int indice) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                ),
              ],
            ),
            content: Text('Esse registro será removido definitivamente.'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _pontos.removeAt(indice);
                  });
                },
              ),
            ],
          );
        }
    );
  }

  void _abrirPaginaFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores) {
      if (alterouValores == true) {
        // TODO
      }
    });
  }

}


