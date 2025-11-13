import 'package:flutter/material.dart';

class NotesCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final void Function(int id) delete;
  final VoidCallback onTap;
  final List<Color> noteColors;

  const NotesCard({
    super.key,
    required this.note,
    required this.delete,
    required this.onTap,
    required this.noteColors,
  });

  @override
  Widget build(BuildContext context) {
    final int colorId = note['color'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: noteColors[colorId % noteColors.length],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // date
            Text(
              note['date'] ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // title
            Text(
              note['title'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // content
            Expanded(
              child: Text(
                note['content'] ?? '',
                style: const TextStyle(fontSize: 16),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => delete(note['id']),
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Delete note',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
