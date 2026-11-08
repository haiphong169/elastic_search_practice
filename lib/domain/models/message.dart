class Message {
  final String content;
  final String sender;
  final int workspaceId;
  final int channelId;
  final DateTime creationDate;

  const Message({
    required this.content,
    required this.sender,
    required this.workspaceId,
    required this.channelId,
    required this.creationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "sender": sender,
      "workspace_id": workspaceId,
      "channel_id": channelId,
      "creation_date": creationDate.toUtc().toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String,
      sender: json['sender'] as String,
      workspaceId: json['workspace_id'] as int,
      channelId: json['channel_id'] as int,
      creationDate: DateTime.parse(json['creation_date'] as String),
    );
  }
}
