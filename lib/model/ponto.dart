import 'package:intl/intl.dart';

class Ponto {
  static const CAMPO_ID = '_id';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';
  static const CAMPO_DATA = 'data';

  int id;
  String descricao;
  String diferenciais;
  DateTime? data;

  Ponto({required this.id, required this.descricao, required this.diferenciais, this.data});

  String get dataFormatada {
    if (data == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(data!);
  }

}