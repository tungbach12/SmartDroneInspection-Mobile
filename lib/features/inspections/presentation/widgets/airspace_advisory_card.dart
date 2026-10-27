import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class MobileAirspaceZone {
  const MobileAirspaceZone({
    required this.code,
    required this.name,
    required this.region,
    required this.zoneType,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.maxAltitudeMetersAgl,
    required this.authority,
    required this.legalBasis,
    this.distanceMeters,
  });

  final String code;
  final String name;
  final String region;
  final String zoneType;
  final double latitude;
  final double longitude;
  final int radiusMeters;
  final int maxAltitudeMetersAgl;
  final String authority;
  final String legalBasis;
  final int? distanceMeters;

  MobileAirspaceZone withDistance(int distance) => MobileAirspaceZone(
    code: code,
    name: name,
    region: region,
    zoneType: zoneType,
    latitude: latitude,
    longitude: longitude,
    radiusMeters: radiusMeters,
    maxAltitudeMetersAgl: maxAltitudeMetersAgl,
    authority: authority,
    legalBasis: legalBasis,
    distanceMeters: distance,
  );
}

class MobileAirspaceEvaluation {
  const MobileAirspaceEvaluation({
    required this.latitude,
    required this.longitude,
    required this.classification,
    required this.messageCode,
    required this.advisoryMessage,
    required this.portalUrl,
    required this.matchingZones,
  });

  final double latitude;
  final double longitude;
  final String classification;
  final String messageCode;
  final String advisoryMessage;
  final String portalUrl;
  final List<MobileAirspaceZone> matchingZones;
}

const List<MobileAirspaceZone> kVietnamAirspaceZones = [
  MobileAirspaceZone(
    code: 'VN-NFZ-SGN-TSN-CORE',
    name: 'Cảng HKQT Tân Sơn Nhất — Vùng Cấm Bay Tuyệt Đối',
    region: 'TP. Hồ Chí Minh',
    zoneType: 'NO_FLY_ZONE',
    latitude: 10.8188,
    longitude: 106.6519,
    radiusMeters: 3500,
    maxAltitudeMetersAgl: 0,
    authority: 'Cục Tác chiến - Bộ Tổng Tham mưu (Bộ Quốc phòng)',
    legalBasis: 'Quyết định 18/2020/QĐ-TTg & Nghị định 288/2025/NĐ-CP',
  ),
  MobileAirspaceZone(
    code: 'VN-RES-SGN-TSN-CTR',
    name: 'Vùng Kiểm Soát Tiếp Cận Tân Sơn Nhất (CTR)',
    region: 'TP. Hồ Chí Minh',
    zoneType: 'RESTRICTED_ZONE',
    latitude: 10.8188,
    longitude: 106.6519,
    radiusMeters: 8000,
    maxAltitudeMetersAgl: 50,
    authority: 'Cục Tác chiến & Sư đoàn Không quân 370',
    legalBasis: 'Quyết định 18/2020/QĐ-TTg & Luật Phòng không nhân dân 2024',
  ),
  MobileAirspaceZone(
    code: 'VN-NFZ-SGN-GOV-CORE',
    name: 'Khu Trung Tâm Hành Chính - Dinh Độc Lập & Quân Khu 7',
    region: 'TP. Hồ Chí Minh',
    zoneType: 'NO_FLY_ZONE',
    latitude: 10.7769,
    longitude: 106.6953,
    radiusMeters: 1100,
    maxAltitudeMetersAgl: 0,
    authority: 'Bộ Tư lệnh TP. Hồ Chí Minh',
    legalBasis: 'Quyết định 18/2020/QĐ-TTg & Nghị định 288/2025/NĐ-CP',
  ),
  MobileAirspaceZone(
    code: 'VN-RES-SGN-SAIGON-RIVER',
    name: 'Hành Lang An Toàn Hàng Không & Cầu Trọng Điểm Sông Sài Gòn',
    region: 'TP. Hồ Chí Minh',
    zoneType: 'RESTRICTED_ZONE',
    latitude: 10.7789,
    longitude: 106.7082,
    radiusMeters: 2200,
    maxAltitudeMetersAgl: 120,
    authority: 'Bộ Tư lệnh TP. Hồ Chí Minh',
    legalBasis: 'Nghị định 288/2025/NĐ-CP',
  ),
  MobileAirspaceZone(
    code: 'VN-RES-SGN-CATLAI-500KV',
    name: 'Hành Lang Bảo Vệ Lưới Điện Cao Thế 500kV & Cảng Cát Lái',
    region: 'TP. Hồ Chí Minh',
    zoneType: 'RESTRICTED_ZONE',
    latitude: 10.7615,
    longitude: 106.7754,
    radiusMeters: 1800,
    maxAltitudeMetersAgl: 100,
    authority: 'Bộ Tư lệnh TP.HCM & Đơn vị Quản lý Lưới điện',
    legalBasis: 'Nghị định 288/2025/NĐ-CP',
  ),
  MobileAirspaceZone(
    code: 'VN-NFZ-HAN-BADINH',
    name: 'Khu Vực Cấm Bay Đặc Biệt Ba Đình - Trung Tâm Chính Trị Quốc Gia',
    region: 'Hà Nội',
    zoneType: 'NO_FLY_ZONE',
    latitude: 21.0369,
    longitude: 105.8342,
    radiusMeters: 2500,
    maxAltitudeMetersAgl: 0,
    authority: 'Cục Tác chiến - Bộ Tổng Tham mưu (Bộ Quốc phòng)',
    legalBasis: 'Quyết định 18/2020/QĐ-TTg & Luật Phòng không nhân dân 2024',
  ),
];

double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371000.0;
  final dLat = (lat2 - lat1) * math.pi / 180.0;
  final dLon = (lon2 - lon1) * math.pi / 180.0;
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * math.pi / 180.0) *
          math.cos(lat2 * math.pi / 180.0) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadius * c;
}

MobileAirspaceEvaluation evaluateMobileAirspace(
  double latitude,
  double longitude,
) {
  final zonesWithDistance =
      kVietnamAirspaceZones
          .map(
            (z) => z.withDistance(
              _haversineMeters(
                latitude,
                longitude,
                z.latitude,
                z.longitude,
              ).round(),
            ),
          )
          .toList()
        ..sort((a, b) {
          final rankA = a.zoneType == 'NO_FLY_ZONE' ? 0 : 1;
          final rankB = b.zoneType == 'NO_FLY_ZONE' ? 0 : 1;
          if (rankA != rankB) return rankA.compareTo(rankB);
          return (a.distanceMeters ?? 0).compareTo(b.distanceMeters ?? 0);
        });

  final matching = zonesWithDistance
      .where((z) => (z.distanceMeters ?? 999999) <= z.radiusMeters)
      .toList();

  final inNoFly = matching.any((z) => z.zoneType == 'NO_FLY_ZONE');
  final inRestricted = !inNoFly && matching.isNotEmpty;

  final classification = inNoFly
      ? 'NO_FLY_ZONE'
      : inRestricted
      ? 'RESTRICTED_ZONE'
      : 'CLEAR_ZONE';
  final hasWarning = inNoFly || inRestricted;

  return MobileAirspaceEvaluation(
    latitude: latitude,
    longitude: longitude,
    classification: classification,
    messageCode: hasWarning ? 'MSG28' : 'AIRSPACE_CLEAR',
    advisoryMessage: hasWarning
        ? 'A possible restriction is indicated. Verify current applicable authority permission; this lookup is not a flight permit.'
        : 'Coordinates are outside published static no-fly and restricted zones. Verify current NOTAM and authority permission before flight; this lookup is not a flight permit.',
    portalUrl: 'https://cambay.mod.gov.vn',
    matchingZones: matching,
  );
}

(double, double) resolveMobileCoordinates({
  String? locationText,
  double? latitude,
  double? longitude,
}) {
  if (latitude != null && longitude != null) {
    return (latitude, longitude);
  }
  if (locationText != null && locationText.trim().startsWith('{')) {
    try {
      final decoded = jsonDecode(locationText) as Map<String, dynamic>;
      final lat = (decoded['latitude'] as num?)?.toDouble();
      final lon = (decoded['longitude'] as num?)?.toDouble();
      if (lat != null && lon != null) {
        return (lat, lon);
      }
    } on Object {
      // ignore malformed JSON
    }
  }
  return (10.7789, 106.7082);
}

class AirspaceAdvisoryCard extends StatelessWidget {
  const AirspaceAdvisoryCard({
    this.assetName,
    this.locationText,
    this.latitude,
    this.longitude,
    super.key,
  });

  final String? assetName;
  final String? locationText;
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    final (lat, lon) = resolveMobileCoordinates(
      locationText: locationText,
      latitude: latitude,
      longitude: longitude,
    );
    final eval = evaluateMobileAirspace(lat, lon);

    final (
      badgeColor,
      badgeBg,
      titleText,
      icon,
    ) = switch (eval.classification) {
      'NO_FLY_ZONE' => (
        Colors.red.shade800,
        Colors.red.shade50,
        'VÙNG CẤM BAY (NO-FLY ZONE)',
        Icons.gpp_bad_outlined,
      ),
      'RESTRICTED_ZONE' => (
        Colors.amber.shade900,
        Colors.amber.shade50,
        'VÙNG HẠN CHẾ BAY (RESTRICTED)',
        Icons.warning_amber_rounded,
      ),
      _ => (
        Colors.green.shade800,
        Colors.green.shade50,
        'NGOÀI VÙNG CẤM TĨNH (CLEAR ZONE)',
        Icons.verified_user_outlined,
      ),
    };

    return Card(
      color: badgeBg,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: badgeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bản đồ Không phận & Vùng cấm bay',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    eval.messageCode,
                    style: TextStyle(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$titleText · ${assetName ?? 'Vị trí khảo sát'} (${lat.toStringAsFixed(4)}°N, ${lon.toStringAsFixed(4)}°E)',
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '[${eval.messageCode}] ${eval.advisoryMessage}',
              style: TextStyle(color: badgeColor, fontSize: 13),
            ),
            if (eval.matchingZones.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...eval.matchingZones.map(
                (zone) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• ${zone.name} (${zone.legalBasis} · Trần <= ${zone.maxAltitudeMetersAgl}m AGL)',
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              'Cổng tra cứu Bộ Quốc phòng: ${eval.portalUrl}',
              style: TextStyle(
                color: badgeColor,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
