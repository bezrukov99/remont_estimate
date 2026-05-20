import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/services/export_file_opener.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/features/estimate/data/export/estimate_export_service.dart';
import 'package:remont_estimate/features/estimate/data/export/export_document_labels.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class ExportSheet extends StatefulWidget {
  const ExportSheet({required this.hostContext, super.key});

  /// Screen context that stays mounted after this sheet closes.
  final BuildContext hostContext;

  static Future<void> show(BuildContext context) {
    return showRemontSheet<void>(
      context,
      child: BlocProvider.value(
        value: context.read<EstimateCubit>(),
        child: ExportSheet(hostContext: context),
      ),
    );
  }

  @override
  State<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<ExportSheet> {
  final _exportService = EstimateExportService();
  ExportFormat? _loadingFormat;

  Future<void> _export(ExportFormat format) async {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<EstimateCubit>().state;

    if (!_exportService.canExport(state)) {
      _showMessage(context, l10n.addRoomBeforeExport);
      return;
    }

    setState(() => _loadingFormat = format);

    try {
      final labels = ExportDocumentLabels(l10n);
      final file = await _exportService.export(state, format, labels);
      final hostContext = widget.hostContext;
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      if (!hostContext.mounted) {
        return;
      }
      await _showExportActions(hostContext, file, format);
    } catch (e) {
      if (mounted) {
        _showMessage(context, l10n.exportFailed(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _loadingFormat = null);
      }
    }
  }

  Future<void> _showExportActions(
    BuildContext hostContext,
    File file,
    ExportFormat format,
  ) async {
    if (!hostContext.mounted) {
      return;
    }

    final l10n = AppLocalizations.of(hostContext)!;
    final label = format == ExportFormat.pdf ? l10n.pdfReady : l10n.excelReady;
    await showRemontSheet<void>(
      hostContext,
      child: Builder(
        builder: (sheetContext) {
          return AppSheetBody(
            title: label,
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    await ExportFileOpener.share(
                      file,
                      format,
                      subject:
                          '${l10n.appTitle} — ${format.name.toUpperCase()}',
                    );
                  },
                  icon: const Icon(Icons.share_outlined),
                  label: Text(l10n.share),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    final error = await ExportFileOpener.openWithFallback(
                      file,
                      format,
                      openFailedMessage: l10n.openFileFailed,
                    );
                    if (error != null && hostContext.mounted) {
                      _showMessage(hostContext, error);
                    }
                  },
                  icon: const Icon(Icons.folder_open_outlined),
                  label: Text(l10n.openFile),
                ),
              ],
            ),
            children: [
              Text(
                file.path.split('/').last,
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color: context.palette.textTertiary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMessage(BuildContext hostContext, String text) {
    if (!hostContext.mounted) {
      return;
    }
    ScaffoldMessenger.of(hostContext).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EstimateCubit, EstimateState>(
      builder: (context, state) {
        final canExport = _exportService.canExport(state);
        final isLoading = _loadingFormat != null;

        return AppSheetBody(
          title: l10n.exportEstimate,
          children: [
            Text(
              canExport
                  ? l10n.materialsAcrossRooms(
                      state.materials.length,
                      state.rooms.length,
                    )
                  : l10n.addRoomsToExport,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ExportOptionTile(
                icon: Icons.picture_as_pdf_outlined,
                title: l10n.exportPdf,
                subtitle: l10n.exportPdfSubtitle,
                color: const Color(0xFFE17055),
                isLoading: _loadingFormat == ExportFormat.pdf,
                enabled: canExport && !isLoading,
                onTap: () => _export(ExportFormat.pdf),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ExportOptionTile(
                icon: Icons.table_chart_outlined,
                title: l10n.exportExcel,
                subtitle: l10n.exportExcelSubtitle,
                color: const Color(0xFF27AE60),
                isLoading: _loadingFormat == ExportFormat.excel,
                enabled: canExport && !isLoading,
                onTap: () => _export(ExportFormat.excel),
              ),
            if (isLoading) ...[
              const SizedBox(height: AppSpacing.md),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        );
      },
    );
  }
}

class _ExportOptionTile extends StatelessWidget {
  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.enabled,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? context.palette.surfaceMuted : context.palette.surfaceMuted.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(14),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color,
                        ),
                      )
                    : Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: enabled ? context.palette.textTertiary : context.palette.progressTrack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
