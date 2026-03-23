import 'package:urban_os/datamodel/system_data_model.dart';

class GridRow {
  final bool isHeader;
  final bool isWide;
  final bool isPair;
  final SystemEntry? entryA;
  final SystemEntry? entryB;
  final Section? section;
  final int rowIndex;

  const GridRow({
    required this.isHeader,
    required this.isWide,
    required this.isPair,
    this.entryA,
    this.entryB,
    this.section,
    required this.rowIndex,
  });

  factory GridRow.header(Section sec) => GridRow(
    isHeader: true,
    isWide: false,
    isPair: false,
    section: sec,
    rowIndex: -1,
  );
  factory GridRow.wide(SystemEntry e, int i) => GridRow(
    isHeader: false,
    isWide: true,
    isPair: false,
    entryA: e,
    rowIndex: i,
  );
  factory GridRow.pair(SystemEntry a, SystemEntry b, int i) => GridRow(
    isHeader: false,
    isWide: false,
    isPair: true,
    entryA: a,
    entryB: b,
    rowIndex: i,
  );
  factory GridRow.single(SystemEntry e, int i) => GridRow(
    isHeader: false,
    isWide: false,
    isPair: false,
    entryA: e,
    rowIndex: i,
  );
}
