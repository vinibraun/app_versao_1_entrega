import 'package:app_versao_1_entrega/model/ponto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Ponto? pontoAtual;
  ConteudoFormDialog({Key? key, this.pontoAtual}) : super(key: key);
  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _diferenciaisController = TextEditingController();
  final _dataController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.pontoAtual != null) {
      _descricaoController.text = widget.pontoAtual!.descricao;
      _dataController.text = widget.pontoAtual!.dataFormatada;
      _diferenciaisController.text = widget.pontoAtual!.diferenciais;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(labelText: 'Lugar',),
            validator: (String? valor) {
              if (valor == null || valor.isEmpty) {
                return 'Informe a descrição';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _diferenciaisController,
            decoration: InputDecoration(labelText: 'Características',),
            validator: (String? valor) {
              if (valor == null || valor.isEmpty) {
                return 'Informe os diferenciais e características';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dataController,
            decoration: InputDecoration(
              labelText: 'Data',
              prefixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _mostrarCalendario,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _dataController.clear(),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }

  void _mostrarCalendario() {
    final dataFormatada = _dataController.text;
    var data = DateTime.now();
    if (dataFormatada.isNotEmpty) {
      data = _dateFormat.parse(dataFormatada);
    }

    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days: 5 * 365)),
      lastDate: data.add(Duration(days: 5 * 365)),
    ).then((DateTime? dataSelecionada) {
      if (dataSelecionada != null) {
        setState(() {
          _dataController.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidos() => _formKey.currentState?.validate() == true;
  Ponto get novoPonto => Ponto(
    id: widget.pontoAtual?.id ?? 0,
    descricao: _descricaoController.text,
    diferenciais: _diferenciaisController.text,
    data: _dataController.text.isEmpty
        ? null : _dateFormat.parse(_dataController.text),
  );
}

