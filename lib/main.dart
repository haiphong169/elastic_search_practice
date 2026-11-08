import 'package:elastic_search_bar/data/repositories/message_repository_impl.dart';
import 'package:elastic_search_bar/data/services/elastic_search_service.dart';
import 'package:elastic_search_bar/ui/search_bar/search_bar_screen.dart';
import 'package:elastic_search_bar/ui/search_bar/search_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

void main() {
  final repository = MessageRepositoryImpl(service: ElasticSearchService());
  runApp(MainApp(searchViewModel: SearchBarViewModel(repository: repository)));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.searchViewModel});

  final SearchBarViewModel searchViewModel;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.neutral.light.desktop;
    return MaterialApp(
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (context, child) => FTheme(data: theme, child: child!),
      home: SearchBarScreen(viewModel: searchViewModel),
    );
  }
}
