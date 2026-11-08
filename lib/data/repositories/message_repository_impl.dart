import 'package:elastic_search_bar/data/repositories/message_repository.dart';
import 'package:elastic_search_bar/data/services/elastic_search_service.dart';
import 'package:elastic_search_bar/domain/models/message.dart';
import 'package:elastic_search_bar/domain/models/message_filter.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ElasticSearchService service;

  const MessageRepositoryImpl({required this.service});

  @override
  Future<void> addMessage(Message message) {
    return service.index(message.toJson());
  }

  @override
  Future<List<Message>> search(
    String query, {
    MessageFilter filter = const MessageFilter(),
  }) async {
    final docs = await service.search(query, _toClauses(filter));
    return docs.map(Message.fromJson).toList();
  }

  List<Map<String, dynamic>> _toClauses(MessageFilter f) => [
    if (f.sender != null)
      {
        "term": {"sender": f.sender},
      },
    if (f.workspaceId != null)
      {
        "term": {"workspace_id": f.workspaceId},
      },
    if (f.channelId != null)
      {
        "term": {"channel_id": f.channelId},
      },
    if (f.from != null || f.before != null)
      {
        "range": {
          "creation_date": {
            if (f.from != null) "gte": f.from!.toUtc().toIso8601String(),
            if (f.before != null) "lt": f.before!.toUtc().toIso8601String(),
          },
        },
      },
  ];
}
