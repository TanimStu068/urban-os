import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

enum ReportType { summary, alerts, events, performance, compliance, incident }

enum ReportFormat { pdf, csv, json, html }

enum ReportPeriod { last24h, last7d, last30d, last90d, custom }

enum ReportStatus { idle, generating, ready }

extension ReportTypeX on ReportType {
  String get label => const [
    'SUMMARY',
    'ALERTS',
    'EVENTS',
    'PERFORMANCE',
    'COMPLIANCE',
    'INCIDENT',
  ][index];
  IconData get icon => [
    Icons.summarize_rounded,
    Icons.warning_amber_rounded,
    Icons.bolt_rounded,
    Icons.speed_rounded,
    Icons.verified_user_rounded,
    Icons.report_rounded,
  ][index];
  Color get color => [C.cyan, C.red, C.amber, C.green, C.violet, C.red][index];
  String get description => const [
    'Full system overview with key metrics',
    'All alerts with severity & resolution status',
    'System events filtered by level',
    'Throughput, latency & uptime analytics',
    'Rule compliance & audit trail',
    'Incident timeline and root cause data',
  ][index];
}

extension ReportFormatX on ReportFormat {
  String get label => const ['PDF', 'CSV', 'JSON', 'HTML'][index];
  IconData get icon => [
    Icons.picture_as_pdf_rounded,
    Icons.grid_on_rounded,
    Icons.data_object_rounded,
    Icons.html_rounded,
  ][index];
}

extension ReportPeriodX on ReportPeriod {
  String get label =>
      const ['LAST 24H', 'LAST 7D', 'LAST 30D', 'LAST 90D', 'CUSTOM'][index];
}

class ReportConfig {
  final Set<ReportType> types;
  final ReportFormat format;
  final ReportPeriod period;
  final bool includeCharts;
  final bool includeRawData;
  final bool compressOutput;
  final bool includeMetadata;
  final String? customTitle;

  const ReportConfig({
    required this.types,
    this.format = ReportFormat.pdf,
    this.period = ReportPeriod.last24h,
    this.includeCharts = true,
    this.includeRawData = false,
    this.compressOutput = false,
    this.includeMetadata = true,
    this.customTitle,
  });

  ReportConfig copyWith({
    Set<ReportType>? types,
    ReportFormat? format,
    ReportPeriod? period,
    bool? includeCharts,
    bool? includeRawData,
    bool? compressOutput,
    bool? includeMetadata,
    String? customTitle,
  }) => ReportConfig(
    types: types ?? this.types,
    format: format ?? this.format,
    period: period ?? this.period,
    includeCharts: includeCharts ?? this.includeCharts,
    includeRawData: includeRawData ?? this.includeRawData,
    compressOutput: compressOutput ?? this.compressOutput,
    includeMetadata: includeMetadata ?? this.includeMetadata,
    customTitle: customTitle ?? this.customTitle,
  );
}

class GeneratedReport {
  final String id;
  final String title;
  final ReportConfig config;
  final DateTime generatedAt;
  final int recordCount;
  final int sizeKb;

  const GeneratedReport({
    required this.id,
    required this.title,
    required this.config,
    required this.generatedAt,
    required this.recordCount,
    required this.sizeKb,
  });
}
