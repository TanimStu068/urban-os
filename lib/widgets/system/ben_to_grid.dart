import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/system_data_model.dart';
import 'package:urban_os/widgets/system/section_header.dart';
import 'package:urban_os/widgets/system/grid_row.dart';
import 'package:urban_os/widgets/system/system_tile.dart';

class BentoGrid extends StatelessWidget {
  final List<MapEntry<Section, SystemEntry>> entries;
  final AnimationController entryCtrl;
  final AnimationController hotCtrl;
  final void Function(SystemEntry) onTap;

  const BentoGrid({
    super.key,
    required this.entries,
    required this.entryCtrl,
    required this.hotCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <GridRow>[];
    String? lastCat;

    for (int i = 0; i < entries.length;) {
      final section = entries[i].key;
      final catLabel = section.label;

      if (catLabel != lastCat) {
        rows.add(GridRow.header(section));
        lastCat = catLabel;
      }

      final secEntries = <SystemEntry>[];
      while (i < entries.length && entries[i].key.label == catLabel) {
        secEntries.add(entries[i].value);
        i++;
      }

      int j = 0;
      while (j < secEntries.length) {
        final e = secEntries[j];
        if (e.size == TileSize.wide) {
          rows.add(GridRow.wide(e, rows.length));
          j++;
        } else if (j + 1 < secEntries.length &&
            secEntries[j + 1].size != TileSize.wide) {
          rows.add(GridRow.pair(e, secEntries[j + 1], rows.length));
          j += 2;
        } else {
          rows.add(GridRow.single(e, rows.length));
          j++;
        }
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: rows.length,
      itemBuilder: (ctx, i) {
        final row = rows[i];
        if (row.isHeader) return SectionHeader(section: row.section!);

        return AnimatedBuilder(
          animation: entryCtrl,
          builder: (_, child) {
            final delay = (i * 0.04).clamp(0.0, 0.7);
            final t = Curves.easeOutCubic.transform(
              ((entryCtrl.value - delay).clamp(0.0, 1.0)),
            );
            return Transform.translate(
              offset: Offset(0, 24 * (1 - t)),
              child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: row.isPair
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SystemTile(
                          entry: row.entryA!,
                          hotCtrl: hotCtrl,
                          onTap: () => onTap(row.entryA!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SystemTile(
                          entry: row.entryB!,
                          hotCtrl: hotCtrl,
                          onTap: () => onTap(row.entryB!),
                        ),
                      ),
                    ],
                  )
                : SystemTile(
                    entry: row.entryA!,
                    hotCtrl: hotCtrl,
                    onTap: () => onTap(row.entryA!),
                    isWide: row.isWide,
                  ),
          ),
        );
      },
    );
  }
}
