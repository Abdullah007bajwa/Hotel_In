// ─── Crafted by Abdullah Student’s QuickStay Squad® ────────────────────────

import 'package:flutter/material.dart';

class DateChips extends StatelessWidget {
  final List<String> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DateChips({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final sel = i == selectedIndex;
          return ChoiceChip(
            label: Text(dates[i]),
            selected: sel,
            onSelected: (_) => onSelected(i),
            selectedColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.grey[200],
          );
        },
      ),
    );
  }
}
