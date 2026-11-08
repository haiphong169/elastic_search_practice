import 'dart:async';

import 'package:elastic_search_bar/data/repositories/message_repository.dart';
import 'package:elastic_search_bar/domain/models/message.dart';
import 'package:flutter/material.dart';

class SearchBarViewModel with ChangeNotifier {
  final MessageRepository _repository;

  SearchBarViewModel({required this._repository});

  Timer? _debounce;
  int _requestId = 0;

  List<Message> _results = const [];

  List<Message> get results => _results;

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () => _search(query));
  }

  Future<void> _search(String query) async {
    final id = ++_requestId;
    if (query.trim().isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }
    final found = await _repository.search(query);
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
