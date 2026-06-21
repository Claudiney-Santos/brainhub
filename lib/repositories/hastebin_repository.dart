import 'package:brainhub/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HastebinRepository {
  final _client = Supabase.instance.client;
  static const _function = 'hastebin-paste';

  Future<Result<String, String>> createPaste(String content) async {
    try {
      final response = await _client.functions.invoke(
        _function,
        body: {'content': content},
      );

      final data = response.data as Map<String, dynamic>;
      final url = data['url'] as String;
      return Result.ok(url);
    } catch (e) {
      return Result.err(e.toString());
    }
  }

  Future<Result<String, String>> fetchPaste(String keyOrUrl) async {
    try {
      final key = _extractKey(keyOrUrl);
      final response = await _client.functions.invoke(
        _function,
        queryParameters: {'key': key},
      );

      final data = response.data as Map<String, dynamic>;
      final content = data['content'] as String;
      return Result.ok(content);
    } catch (e) {
      return Result.err(e.toString());
    }
  }

  String _extractKey(String keyOrUrl) {
    final trimmed = keyOrUrl.trim();
    if (trimmed.contains('://')) {
      final uri = Uri.tryParse(trimmed);
      if (uri != null) {
        final segments = uri.pathSegments.where((s) => s.isNotEmpty);
        if (segments.isNotEmpty) {
          return segments.last;
        }
      }
    }
    return trimmed;
  }
}
