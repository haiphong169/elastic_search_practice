import 'package:elastic_search_bar/data/repositories/message_repository_impl.dart';
import 'package:elastic_search_bar/data/services/elastic_search_service.dart';
import 'package:elastic_search_bar/ui/search_bar/search_bar_screen.dart';
import 'package:elastic_search_bar/ui/search_bar/search_bar_view_model.dart';
import 'package:flutter/material.dart';

void main() {
  final repository = MessageRepositoryImpl(service: ElasticSearchService());
  runApp(MainApp(searchViewModel: SearchBarViewModel(repository: repository)));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.searchViewModel});

  final SearchBarViewModel searchViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SearchBarScreen(viewModel: searchViewModel));
  }
}
