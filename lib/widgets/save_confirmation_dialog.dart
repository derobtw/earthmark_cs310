import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// "Country saved" onay penceresi (wireframe durum B), Screen 2'de geçerli
/// bir kayıttan sonra açılır. "Add note" butonu sadece Been ülkelerde var.
class SaveConfirmationDialog extends StatelessWidget {
  final String message;
  final bool showAddNote;
  final void Function() onDone;
  final void Function() onAddNote;

  const SaveConfirmationDialog({
    super.key,
    required this.message,
    required this.showAddNote,
    required this.onDone,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: const CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.been,
        child: Icon(Icons.check, color: Colors.white),
      ),
      title: const Text(
        'Country saved',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textDark),
          ),
          if (showAddNote) const SizedBox(height: 6),
          if (showAddNote)
            const Text(
              'Add a short note to remember this trip?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
        ],
      ),
      actions: [
        Row(
          children: [
            if (showAddNote)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // pencereyi kapat
                    onAddNote();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add note'),
                ),
              ),
            if (showAddNote) const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // pencereyi kapat
                  onDone();
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
