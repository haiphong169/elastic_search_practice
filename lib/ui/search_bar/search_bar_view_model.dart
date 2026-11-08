import 'dart:async';

import 'package:elastic_search_bar/data/repositories/message_repository.dart';
import 'package:elastic_search_bar/domain/models/message.dart';
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

  List<Map<String, dynamic>> _buildFilters() => [
    if (_sender != null)
      {
        "term": {"sender": _sender},
      },
    if (_channelId != null)
      {
        "term": {"channel_id": _channelId},
      },
    if (_workspaceId != null)
      {
        "term": {"workspace_id": _workspaceId},
      },
    if (_dateTimeRange != null)
      {
        "range": {
          "creation_date": {
            "gte": _dateTimeRange!.start.toUtc().toIso8601String(),
            // Picker dates are midnight; use the start of the next day so the
            // whole end day is included.
            "lt": _dateTimeRange!.end
                .add(const Duration(days: 1))
                .toUtc()
                .toIso8601String(),
          },
        },
      },
  ];

  Future<void> _search() async {
    final id = ++_requestId;
    if (_query.trim().isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }
    final found = await _repository.search(_query, _buildFilters());
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
