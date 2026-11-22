import 'dart:convert';

import 'package:http/http.dart' as http;

class MealImageService {
  MealImageService._();
  static final MealImageService instance = MealImageService._();

  final Map<String, Future<String?>> _cache = {};

  Future<String?> thumbnailFor(String wikiTitle) {
    return _cache.putIfAbsent(wikiTitle, () => _fetch(wikiTitle));
  }

  Future<String?> _fetch(String title) async {
    var lang = 'en';
    var page = title;
    if (title.startsWith('tr:')) {
      lang = 'tr';
      page = title.substring(3);
    }
    final uri = Uri.parse(
      'https://$lang.wikipedia.org/api/rest_v1/page/summary/'
      '${Uri.encodeComponent(page)}',
    );
    try {
      final res = await http
          .get(
            uri,
            headers: {'User-Agent': 'SUrvivor-CS310/1.0 (student project)'},
          )
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final thumb = json['thumbnail'] as Map<String, dynamic>?;
      final src = thumb?['source'] as String?;
      if (src == null) return null;
      return src;
    } catch (_) {
      return null;
    }
  }
}
