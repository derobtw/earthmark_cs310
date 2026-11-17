import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// "Edit note" alt penceresi (wireframe durum D). Screen 4'teki Edit butonu
/// açar. En fazla 200 karakter; sayaç ("24 / 200") TextField'ın maxLength
/// özelliğiyle otomatik görünür.
///
/// Kullanım:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     builder: (context) => NoteEditorSheet(...),
///   );
class NoteEditorSheet extends StatefulWidget {
  static const int maxNoteLength = 200;

  final String countryName;
  final String status;
  final String initialNote;
  final void Function(String note) onSave;

  const NoteEditorSheet({
    super.key,
    required this.countryName,
    required this.status,
    required this.initialNote,
    required this.onSave,
  });

  @override
  State<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<NoteEditorSheet> {
  late final TextEditingController _noteController =
      TextEditingController(text: widget.initialNote);

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_noteController.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Klavye açılınca pencere klavyenin üstünde kalsın.
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 4,
        bottom: keyboardHeight + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit note',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${widget.countryName} · ${widget.status}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            autofocus: true,
            maxLines: 4,
            maxLength: NoteEditorSheet.maxNoteLength,
            decoration: InputDecoration(
              hintText: 'Write a short note about this trip...',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // değişiklik kaydedilmez
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save note'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
