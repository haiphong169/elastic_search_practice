import 'package:elastic_search_bar/domain/models/message.dart';

abstract class MessageRepository {
  Future<List<Message>> search(
    String query,
    List<Map<String, dynamic>> filters,
  );

  Future<void> addMessage(Message message);
}
