import 'package:elastic_search_bar/ui/search_bar/search_bar_view_model.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class SearchBarScreen extends StatelessWidget {
  const SearchBarScreen({super.key, required this.viewModel});

  final SearchBarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: const FHeader(title: Text('Search messages')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTextField(
            autofocus: true,
            hint: 'Search...',
            control: .managed(
              onChange: (value) => viewModel.onQueryChanged(value.text),
            ),
            prefixBuilder: (context, style, variants) => const Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Icon(FLucideIcons.search, size: 16),
            ),
            clearable: (value) => value.text.isNotEmpty,
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) => _FilterRow(viewModel: viewModel),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                final results = viewModel.results;
                if (results.isEmpty) {
                  return const Center(child: Text('No results'));
                }
                return FItemGroup.builder(
                  count: results.length,
                  divider: .indented,
                  itemBuilder: (context, i) {
                    final m = results[i];
                    return FItem(
                      title: Text(m.content),
                      subtitle: Text(
                        '${m.sender} · workspace ${m.workspaceId} · channel ${m.channelId}',
                      ),
                      details: Text(_formatDate(m.creationDate)),
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

// Values used by the seed data. A `terms` aggregation could fetch these later.
const _senders = [
  'Alice Johnson',
  'Bob Smith',
  'Carol White',
  'David Brown',
  'Emma Davis',
  'Frank Miller',
  'Grace Wilson',
  'Henry Moore',
  'Isabel Taylor',
  'Jack Anderson',
  'Karen Thomas',
  'Liam Jackson',
  'Mia Harris',
  'Noah Martin',
  'Olivia Garcia',
  'Peter Clark',
  'Quinn Lewis',
  'Rachel Walker',
  'Sam Hall',
  'Tina Young',
];
const _workspaceIds = [1, 2, 3];
const _channelIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.viewModel});

  final SearchBarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final range = viewModel.dateTimeRange;
    return Row(
      spacing: 8,
      children: [
        Expanded(
          flex: 2,
          child: FSelect<String>(
            hint: 'Any sender',
            clearable: true,
            items: {for (final s in _senders) s: s},
            control: .lifted(
              value: viewModel.sender,
              onChange: viewModel.setSender,
            ),
          ),
        ),
        Expanded(
          child: FSelect<int>(
            hint: 'Any workspace',
            clearable: true,
            items: {for (final id in _workspaceIds) 'Workspace $id': id},
            control: .lifted(
              value: viewModel.workspaceId,
              onChange: viewModel.setWorkspace,
            ),
          ),
        ),
        Expanded(
          child: FSelect<int>(
            hint: 'Any channel',
            clearable: true,
            items: {for (final id in _channelIds) 'Channel $id': id},
            control: .lifted(
              value: viewModel.channelId,
              onChange: viewModel.setChannel,
            ),
          ),
        ),
        FPopover(
          popoverBuilder: (context, controller) => Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 280,
              child: FCalendar.grid(
                selectionControl: FDateSelectionControl.liftedRange(
                  value: range == null ? null : (range.start, range.end),
                  onChange: (value) => viewModel.setDateTimeRange(
                    value == null
                        ? null
                        : DateTimeRange(start: value.$1, end: value.$2),
                  ),
                ),
              ),
            ),
          ),
          builder: (context, controller, _) => FButton(
            variant: .outline,
            mainAxisSize: .min,
            onPress: controller.toggle,
            prefix: const Icon(FLucideIcons.calendar),
            child: Text(
              range == null
                  ? 'Any date'
                  : '${_formatDay(range.start)} – ${_formatDay(range.end)}',
            ),
          ),
        ),
        if (range != null)
          FButton.icon(
            variant: .ghost,
            onPress: () => viewModel.setDateTimeRange(null),
            child: const Icon(FLucideIcons.x),
          ),
      ],
    );
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

String _formatDay(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

String _formatDate(DateTime date) {
  final d = date.toLocal();
  return '${_formatDay(d)} ${_two(d.hour)}:${_two(d.minute)}';
}
