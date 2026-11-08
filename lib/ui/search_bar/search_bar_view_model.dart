import 'dart:async';

import 'package:elastic_search_bar/data/repositories/message_repository.dart';
import 'package:elastic_search_bar/domain/models/message.dart';
import 'package:elastic_search_bar/domain/models/message_filter.dart';
import 'package:flutter/material.dart';

class SearchBarViewModel with ChangeNotifier {
  final MessageRepository _repository;

  SearchBarViewModel({required this._repository});

  String _query = "";
  String? _sender;
  int? _channelId;
  int? _workspaceId;
  DateTimeRange? _dateTimeRange;

  Timer? _debounce;
  int _requestId = 0;

  List<Message> _results = const [];

  List<Message> get results => _results;
  String? get sender => _sender;
  int? get channelId => _channelId;
  int? get workspaceId => _workspaceId;
  DateTimeRange? get dateTimeRange => _dateTimeRange;

  void onQueryChanged(String query) {
    _query = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), _search);
  }

  void setSender(String? sender) {
    _sender = sender;
    _search();
  }

  void setChannel(int? channelId) {
    _channelId = channelId;
    _search();
  }

  void setWorkspace(int? workspaceId) {
    _workspaceId = workspaceId;
    _search();
  }

  void setDateTimeRange(DateTimeRange? dateTimeRange) {
    _dateTimeRange = dateTimeRange;
    _search();
  }

  Future<void> _search() async {
    final id = ++_requestId;
    if (_query.trim().isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }
    final filter = MessageFilter(
      sender: _sender,
      workspaceId: _workspaceId,
      channelId: _channelId,
      from: _dateTimeRange?.start,
      before: _dateTimeRange?.end.add(const Duration(days: 1)),
    );
    final found = await _repository.search(_query, filter: filter);
    if (id != _requestId) return;
    _results = found;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
