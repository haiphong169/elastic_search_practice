import 'package:elastic_search_bar/ui/search_bar/search_bar_view_model.dart';
import 'package:flutter/material.dart';

class SearchBarScreen extends StatelessWidget {
  const SearchBarScreen({super.key, required this.viewModel});

  final SearchBarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search messages')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: viewModel.onQueryChanged,
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                final results = viewModel.results;
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, i) {
                    final m = results[i];
                    return ListTile(
                      title: Text(m.content),
                      subtitle: Text(
                        '${m.sender} · ${m.creationDate.toLocal()}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
