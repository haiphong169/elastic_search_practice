import 'package:elastic_search_bar/data/repositories/message_repository.dart';
import 'package:elastic_search_bar/data/services/elastic_search_service.dart';
import 'package:elastic_search_bar/domain/models/message.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ElasticSearchService service;

  const MessageRepositoryImpl({required this.service});

  @override
  Future<void> addMessage(Message message) {
    return service.index(message.toJson());
  }

  @override
  Future<List<Message>> search(
    String query, [
    List<Map<String, dynamic>> filters = const [],
  ]) async {
    final docs = await service.search(query, filters);
    return docs.map(Message.fromJson).toList();
  }
}
