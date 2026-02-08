import 'dart:math';

class LocationUtils {

  // A list of major hubs. Add more as needed!
  static final List<CityZone> _zones = [
    // --- NORTH CENTRAL ---
    CityZone(code: "FCT", name: "Abuja (FCT)", lat: 9.0765, lng: 7.3986),
    CityZone(code: "MAK", name: "Makurdi (Benue)", lat: 7.7322, lng: 8.5218),
    CityZone(code: "LOK", name: "Lokoja (Kogi)", lat: 7.8023, lng: 6.7430),
    CityZone(code: "ILR", name: "Ilorin (Kwara)", lat: 8.4799, lng: 4.5418),
    CityZone(code: "LAF", name: "Lafia (Nasarawa)", lat: 8.4877, lng: 8.5214),
    CityZone(code: "MIN", name: "Minna (Niger)", lat: 9.5836, lng: 6.5463),
    CityZone(code: "JOS", name: "Jos (Plateau)", lat: 9.8965, lng: 8.8583),

    // --- NORTH EAST ---
    CityZone(code: "YOL", name: "Yola (Adamawa)", lat: 9.2035, lng: 12.4954),
    CityZone(code: "BAU", name: "Bauchi (Bauchi)", lat: 10.3103, lng: 9.8439),
    CityZone(code: "MAI", name: "Maiduguri (Borno)", lat: 11.8311, lng: 13.1510),
    CityZone(code: "GOM", name: "Gombe (Gombe)", lat: 10.2897, lng: 11.1711),
    CityZone(code: "JAL", name: "Jalingo (Taraba)", lat: 8.8937, lng: 11.3741),
    CityZone(code: "DAM", name: "Damaturu (Yobe)", lat: 11.7470, lng: 11.9608),

    // --- NORTH WEST ---
    CityZone(code: "DUT", name: "Dutse (Jigawa)", lat: 11.7594, lng: 9.3392),
    CityZone(code: "KAD", name: "Kaduna (Kaduna)", lat: 10.5105, lng: 7.4165),
    CityZone(code: "KAN", name: "Kano (Kano)", lat: 12.0022, lng: 8.5920),
    CityZone(code: "KAT", name: "Katsina (Katsina)", lat: 12.9866, lng: 7.6016),
    CityZone(code: "BIR", name: "Birnin Kebbi (Kebbi)", lat: 12.4539, lng: 4.1975),
    CityZone(code: "SOK", name: "Sokoto (Sokoto)", lat: 13.0059, lng: 5.2476),
    CityZone(code: "GUS", name: "Gusau (Zamfara)", lat: 12.1628, lng: 6.6613),

    // --- SOUTH EAST ---
    CityZone(code: "UMU", name: "Umuahia (Abia)", lat: 5.5249, lng: 7.4943), // Alternatively use ABA for Aba
    CityZone(code: "AWK", name: "Awka (Anambra)", lat: 6.2221, lng: 7.0825), // Alternatively use ONT for Onitsha
    CityZone(code: "EBO", name: "Abakaliki (Ebonyi)", lat: 6.3249, lng: 8.1137),
    CityZone(code: "ENU", name: "Enugu (Enugu)", lat: 6.4584, lng: 7.5464),
    CityZone(code: "OWR", name: "Owerri (Imo)", lat: 5.4832, lng: 7.0355),

    // --- SOUTH SOUTH ---
    CityZone(code: "UYO", name: "Uyo (Akwa Ibom)", lat: 5.0377, lng: 7.9128),
    CityZone(code: "YEN", name: "Yenagoa (Bayelsa)", lat: 4.9247, lng: 6.2642),
    CityZone(code: "CAL", name: "Calabar (Cross River)", lat: 4.9757, lng: 8.3250),
    CityZone(code: "ASA", name: "Asaba (Delta)", lat: 6.2059, lng: 6.6959), // Alternatively WAR for Warri (5.5544, 5.7932)
    CityZone(code: "BEN", name: "Benin (Edo)", lat: 6.3350, lng: 5.6037),
    CityZone(code: "PHC", name: "Port Harcourt (Rivers)", lat: 4.8156, lng: 7.0498),

    // --- SOUTH WEST ---
    CityZone(code: "EK", name: "Ado Ekiti (Ekiti)", lat: 7.6213, lng: 5.2195),
    CityZone(code: "LAG", name: "Ikeja (Lagos)", lat: 6.6018, lng: 3.3515), // Center of Lagos State
    CityZone(code: "ABK", name: "Abeokuta (Ogun)", lat: 7.1475, lng: 3.3619),
    CityZone(code: "AKR", name: "Akure (Ondo)", lat: 7.2571, lng: 5.2058),
    CityZone(code: "OSG", name: "Osogbo (Osun)", lat: 7.7827, lng: 4.5418),
    CityZone(code: "IBA", name: "Ibadan (Oyo)", lat: 7.3775, lng: 3.9470),
  ];

  static String? getCityCode(double? lat, double? lng) {
    if (lat == null || lng == null) return null;

    // Simple Euclidean distance approximation for speed
    // (We don't need exact Haversine precision for a UI badge)

    double closestDist = 1000.0; // Start with a large number
    String? bestCode;

    for (var zone in _zones) {
      // Calculate rough distance (Pythagoras theorem on lat/lng)
      double dLat = zone.lat - lat;
      double dLng = zone.lng - lng;
      double dist = sqrt((dLat * dLat) + (dLng * dLng));

      // 0.5 degrees is roughly 55km
      if (dist < 1 && dist < closestDist) {
        closestDist = dist;
        bestCode = zone.code;
      }
    }

    return bestCode; // Can return null if "In the middle of nowhere"
  }
}

class CityZone {
  final String code;
  final String name;
  final double lat;
  final double lng;

  CityZone({required this.code, required this.name, required this.lat, required this.lng});
}