class MessageFilter {
  const MessageFilter({
    this.sender,
    this.workspaceId,
    this.channelId,
    this.from,
    this.before,
  });

  final String? sender;
  final int? workspaceId;
  final int? channelId;

  /// inclusive
  final DateTime? from;

  /// exclusive
  final DateTime? before;
}
