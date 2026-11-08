import 'package:elastic_search_bar/domain/models/message.dart';
import 'package:elastic_search_bar/domain/models/message_filter.dart';

abstract class MessageRepository {
  Future<List<Message>> search(
    String query, {
    MessageFilter filter = const MessageFilter(),
  });

  Future<void> addMessage(Message message);
}
