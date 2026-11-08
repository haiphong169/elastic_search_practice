import 'package:elastic_search_bar/domain/models/message.dart';

abstract class MessageRepository {
  Future<List<Message>> search(String query);

  Future<void> addMessage(Message message);
}
