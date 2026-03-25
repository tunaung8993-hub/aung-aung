class VpnServer {
  final String id;
  final String country;
  final String city;
  final String flag;
  final String protocol;
  final String configLink;
  int ping; // ms, -1 = untested, 9999 = unreachable
  bool isFavorite;

  VpnServer({
    required this.id,
    required this.country,
    required this.city,
    required this.flag,
    required this.protocol,
    required this.configLink,
    this.ping = -1,
    this.isFavorite = false,
  });

  String get displayName => '$flag $city, $country';

  String get pingLabel {
    if (ping == -1) return '-- ms';
    if (ping >= 9999) return 'Timeout';
    return '$ping ms';
  }

  String get pingQuality {
    if (ping == -1) return 'unknown';
    if (ping < 100) return 'excellent';
    if (ping < 200) return 'good';
    if (ping < 400) return 'fair';
    return 'poor';
  }

  VpnServer copyWith({int? ping, bool? isFavorite}) {
    return VpnServer(
      id: id,
      country: country,
      city: city,
      flag: flag,
      protocol: protocol,
      configLink: configLink,
      ping: ping ?? this.ping,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
