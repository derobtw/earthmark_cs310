import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/travel_data.dart';
import '../models/saved_country.dart';
import '../utils/app_theme.dart';
import '../utils/country_status.dart';
import '../utils/date_text.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_logo_header.dart';
import '../widgets/note_editor_sheet.dart';
import '../widgets/remove_country_dialog.dart';

/// SCREEN 4 · Country Details
/// Kayıtlı bir ülkenin detayı: fotoğraf, durum (Been/Wish) değiştirme,
/// kısa not (sadece Been) ve listeden çıkarma.
class CountryDetailsScreen extends StatefulWidget {
  final TravelData travelData;
  final SavedCountry savedCountry;
  final void Function(int tabIndex) onTabSelected;

  /// true ise ekran açılır açılmaz not editörü de açılır
  /// (Screen 2'deki "Add note" ve Screen 5'teki not ikonu için).
  final bool openNoteEditor;

  const CountryDetailsScreen({
    super.key,
    required this.travelData,
    required this.savedCountry,
    required this.onTabSelected,
    this.openNoteEditor = false,
  });

  @override
  State<CountryDetailsScreen> createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.openNoteEditor && widget.savedCountry.isBeen) {
      // Sheet ancak ekran çizildikten sonra açılabilir.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openNoteEditor();
      });
    }
  }

  SavedCountry get _saved => widget.savedCountry;

  /// Ülke fotoğrafı yerine bayrağın büyük görseli (internetten yüklenir).
  String get _photoUrl =>
      'https://flagcdn.com/w640/${_saved.country.code.toLowerCase()}.png';

  /// Open-link butonu: ülkenin Wikipedia sayfası, uygulama dışında açılır.
  Uri get _infoUri => Uri.parse(
        'https://en.wikipedia.org/wiki/'
        '${Uri.encodeComponent(_saved.country.name.replaceAll(' ', '_'))}',
      );

  Future<void> _openInfoLink() async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    bool opened = false;
    try {
      opened = await launchUrl(_infoUri, mode: LaunchMode.externalApplication);
    } catch (error) {
      opened = false;
    }
    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open the link.')),
      );
    }
  }

  void _changeStatus(String status) {
    if (_saved.status == status) return;
    setState(() {
      widget.travelData.saveCountry(_saved.country, status);
    });
  }

  void _openNoteEditor() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => NoteEditorSheet(
        countryName: _saved.country.name,
        status: _saved.status,
        initialNote: _saved.note,
        onSave: (note) {
          setState(() {
            widget.travelData.updateNote(_saved.country.code, note);
          });
        },
      ),
    );
  }

  void _confirmRemove() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => RemoveCountryDialog(
        countryName: _saved.country.name,
        onRemove: () {
          widget.travelData.removeCountry(_saved.country.code);
          Navigator.pop(context); // detay ekranını kapat → My Countries
        },
      ),
    );
  }

  /// Alt menüden bir sekmeye basılınca detay ekranını kapatıp o sekmeye geç.
  void _onBottomNavTap(int index) {
    Navigator.pop(context);
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1 · Geri oku (AppBar otomatik koyar) ve logo
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const AppLogoHeader(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2-3 · Görsel ve open-link butonu
            _buildPhoto(),
            const SizedBox(height: 16),

            // 4 · Bayrak, isim, kıta
            _buildHeader(),
            const SizedBox(height: 16),

            // 5 · Durum butonları
            Row(
              children: [
                Expanded(
                  child: _StatusButton(
                    label: CountryStatus.been,
                    icon: Icons.check_circle,
                    color: AppColors.been,
                    lightColor: AppColors.beenLight,
                    selected: _saved.status == CountryStatus.been,
                    onTap: () => _changeStatus(CountryStatus.been),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatusButton(
                    label: CountryStatus.wish,
                    icon: Icons.bookmark_border,
                    color: AppColors.wish,
                    lightColor: AppColors.wishLight,
                    selected: _saved.status == CountryStatus.wish,
                    onTap: () => _changeStatus(CountryStatus.wish),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // 6 · Notlar (sadece Been ülkelerde)
            if (_saved.isBeen) _buildNotes(),
            if (_saved.isBeen) const Divider(height: 32),

            // 7 · Listeden çıkarma
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _confirmRemove,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  backgroundColor: AppColors.errorLight,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, size: 20),
                    SizedBox(width: 6),
                    Text('Remove from My Countries'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: AppBottomNav.myCountriesTab,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildPhoto() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                _photoUrl,
                fit: BoxFit.cover,
                // İnternet yoksa ya da görsel yüklenemezse gri kutu göster.
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.mapUnselected,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textMuted,
                    size: 40,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: GestureDetector(
                onTap: _openInfoLink,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.open_in_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Text(
            _saved.country.flag,
            style: const TextStyle(fontSize: 32),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _saved.country.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      _saved.country.continent,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotes() {
    final bool hasNote = _saved.note.isNotEmpty;
    final DateTime? updatedAt = _saved.noteUpdatedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sticky_note_2_outlined, color: AppColors.textDark),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'My Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            TextButton(
              onPressed: _openNoteEditor,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 16),
                  SizedBox(width: 4),
                  Text('Edit'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            hasNote ? _saved.note : 'No note yet. Tap Edit to add one.',
            style: TextStyle(
              color: hasNote ? AppColors.textDark : AppColors.textMuted,
            ),
          ),
        ),
        if (updatedAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Last updated: ${DateText.format(updatedAt)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Been / Wish durum butonu.
class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final bool selected;
  final void Function() onTap;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: selected ? lightColor : const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? color : AppColors.textMuted, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? color : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
