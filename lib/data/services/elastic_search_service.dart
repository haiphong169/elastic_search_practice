import 'package:elastic_search_bar/config/elastic_config.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

const _headers = {
  'Authorization': 'ApiKey $esApiKey',
  'Content-Type': 'application/json',
};

class ElasticSearchService {
  Future<void> index(Map<String, dynamic> messageJson) async {
    final response = await http.post(
      Uri.parse('$esUrl/messages/_doc?refresh=wait_for'),
      headers: _headers,
      body: jsonEncode(messageJson),
    );
    if (response.statusCode != 201) {
      throw Exception(
        'Create failed (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> search(
    String query,
    List<Map<String, dynamic>> filters,
  ) async {
    final response = await http.post(
      Uri.parse('$esUrl/messages/_search'),
      headers: _headers,
      body: jsonEncode({
        "query": {
          "bool": {
            "must": [
              {
                "match": {
                  "content": {"query": query},
                },
              },
            ],
            "filter": filters,
          },
        },
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(
        "Search failed (${response.statusCode}): ${response.body}",
      );
    }
    final body = jsonDecode(response.body);
    final searchHits = body['hits']['hits'] as List;

    return searchHits
        .map((hit) => hit['_source'] as Map<String, dynamic>)
        .toList();
  }
}
