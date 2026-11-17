import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';

import '../data/travel_data.dart';
import '../utils/app_theme.dart';
import '../utils/continents.dart';

/// Screen 1 ve Screen 3'teki harita kartı: başlık ("WORLD", "EUROPE MAP"),
/// countries_world_map ile çizilen 2D harita ve + / − zoom butonları.
/// Been ülkeler yeşil, Wish ülkeler mavi, diğerleri gri.
///
/// [focusArea] haritanın hangi kısmının gösterileceğini belirler
/// (bkz. Continents.mapAreas). Dünya için Continents.worldArea.
/// Kıta değişince yeni bir harita oluşsun diye kullanırken
/// key: ValueKey(kıtaAdı) verilmeli.
class TravelMap extends StatefulWidget {
  final TravelData travelData;
  final String label;
  final Rect focusArea;
  final double height;
  final bool showPinchHint;

  const TravelMap({
    super.key,
    required this.travelData,
    required this.label,
    this.focusArea = Continents.worldArea,
    this.height = 240,
    this.showPinchHint = false,
  });

  @override
  State<TravelMap> createState() => _TravelMapState();
}

class _TravelMapState extends State<TravelMap> {
  // Paketin dünya haritasının kendi ölçüleri (SMapWorld: w 2000, h 857).
  static const double _mapWidth = 2000;
  static const double _mapHeight = 857;
  static const double _minZoom = 1;
  static const double _maxZoom = 6;

  // Kullanıcının pinch / + / − ile yaptığı zoom bu controller'da tutulur.
  final TransformationController _zoomController = TransformationController();
  Size _viewSize = Size.zero;

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  /// Kayıtlı ülkelerden harita renklerini üretir. Paket ülke kodlarını küçük
  /// harfle bekliyor ('de', 'fr'...). Her build'de yeni Map oluşturulduğu
  /// için harita renk değişikliklerinde yeniden çiziliyor.
  Map<String, Color?> _countryColors() {
    final Map<String, Color?> colors = {};
    for (final saved in widget.travelData.savedCountries) {
      colors[saved.country.code.toLowerCase()] =
          saved.isBeen ? AppColors.been : AppColors.wish;
    }
    return colors;
  }

  /// + ve − butonları: görünen alanın ortasına doğru yakınlaştırır/uzaklaştırır.
  void _zoom(double factor) {
    final Matrix4 current = _zoomController.value;
    final double scale = current.entry(0, 0);
    final double newScale = (scale * factor).clamp(_minZoom, _maxZoom).toDouble();
    final double f = newScale / scale;

    final double w = _viewSize.width;
    final double h = _viewSize.height;
    final double centerX = w / 2;
    final double centerY = h / 2;

    // Ortadaki nokta yerinde kalacak şekilde kaydırma; harita dışına taşmasın.
    final double tx = (centerX - f * (centerX - current.entry(0, 3)))
        .clamp(w - newScale * w, 0.0)
        .toDouble();
    final double ty = (centerY - f * (centerY - current.entry(1, 3)))
        .clamp(h - newScale * h, 0.0)
        .toDouble();

    _zoomController.value = _scaleAndMove(newScale, tx, ty);
  }

  /// Sadece büyütme + kaydırma içeren bir dönüşüm matrisi.
  Matrix4 _scaleAndMove(double scale, double dx, double dy) {
    return Matrix4(
      scale, 0, 0, 0, //
      0, scale, 0, 0, //
      0, 0, 1, 0, //
      dx, dy, 0, 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: widget.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.mapBackground,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          _viewSize = constraints.biggest;
                          return InteractiveViewer(
                            transformationController: _zoomController,
                            minScale: _minZoom,
                            maxScale: _maxZoom,
                            child: _buildFocusedMap(constraints.biggest),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Column(
                    children: [
                      _ZoomButton(icon: Icons.add, onTap: () => _zoom(1.5)),
                      const SizedBox(height: 6),
                      _ZoomButton(icon: Icons.remove, onTap: () => _zoom(1 / 1.5)),
                    ],
                  ),
                ),
                if (widget.showPinchHint)
                  const Positioned(
                    left: 8,
                    bottom: 6,
                    child: Text(
                      'Pinch to zoom',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Haritayı kutunun içine sığdırır, sonra focusArea'yı kutuyu dolduracak
  /// şekilde büyütüp ortalar (dünya için büyütme 1 olur).
  Widget _buildFocusedMap(Size box) {
    // Harita kutuya "contain" ile sığınca kapladığı alan:
    final double fitScale = (box.width / _mapWidth) < (box.height / _mapHeight)
        ? box.width / _mapWidth
        : box.height / _mapHeight;
    final double drawnWidth = _mapWidth * fitScale;
    final double drawnHeight = _mapHeight * fitScale;
    final double offsetX = (box.width - drawnWidth) / 2;
    final double offsetY = (box.height - drawnHeight) / 2;

    // Odaklanılacak alanın kutu içindeki boyutu ve merkezi:
    final Rect area = widget.focusArea;
    final double areaWidth = area.width * drawnWidth;
    final double areaHeight = area.height * drawnHeight;
    final double focusScale = (box.width / areaWidth) < (box.height / areaHeight)
        ? box.width / areaWidth
        : box.height / areaHeight;
    final double centerX = offsetX + area.center.dx * drawnWidth;
    final double centerY = offsetY + area.center.dy * drawnHeight;
    final double dx = box.width / 2 - focusScale * centerX;
    final double dy = box.height / 2 - focusScale * centerY;

    // Sınır çizgisi harita birimiyle çiziliyor; ekranda ~0.8 px görünsün.
    final double borderWidth = 0.8 / (fitScale * focusScale);

    return SizedBox(
      width: box.width,
      height: box.height,
      child: Transform(
        transform: _scaleAndMove(focusScale, dx, dy),
        child: SimpleMap(
          instructions: SMapWorld.instructions,
          defaultColor: AppColors.mapUnselected,
          colors: _countryColors(),
          countryBorder: CountryBorder(
            color: AppColors.mapBorder,
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}
