import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../extensions/string.dart';
import '../services/journal/entry.dart';
import '../services/journal/provider.dart';
import '../services/tutorial/provider.dart';
import '../widgets/animation/appear_transition.dart';
import '../widgets/animation/list.dart';
import '../widgets/animation/switcher.dart';
import '../widgets/app_bar_themed.dart';
import '../widgets/dialogs/erase_journal_entry.dart';
import '../widgets/journal_entry.dart';
import '../widgets/tutorial/help.dart';

class JournalPage extends StatefulWidget {
  final String defaultFilter;

  JournalPage({this.defaultFilter, Key key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String filter;
  bool editMode;
  Set<JournalEntry> selected;

  void toggleEditMode({JournalEntry selectedEntry}) {
    setState(() {
      editMode = !editMode;
      selected = <JournalEntry>{};

      if (selectedEntry != null) selected.add(selectedEntry);
    });
  }

  void deleteSelected() {
    showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (_) => EraseEntryDialog(selected)).then((deleted) {
      if (deleted ?? false) {
        checkFilter();
        toggleEditMode();
      }
    });
  }

  void checkFilter() {
    if (!Provider.of<JournalProvider>(context, listen: false)
        .allTags
        .contains(filter)) filter = null;
  }

  @override
  void initState() {
    super.initState();

    filter = widget.defaultFilter;
    checkFilter();
    editMode = false;
    selected = <JournalEntry>{};
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TutorialProvider>(context).maybeShow(context, 'journal');
    return WillPopScope(
      onWillPop: () async {
        if (editMode) {
          setState(() => editMode = false);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Journal'),
          actions: <Widget>[
            IconButton(
              icon: IconSwitcher(editMode ? Icons.cancel : Icons.edit),
              onPressed: toggleEditMode,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBarThemed(ListTile(
              title: const Text('Topic'),
              trailing: Consumer<JournalProvider>(
                builder: (_, journal, child) => DropdownButton<String>(
                  value: filter ?? 'all_topics',
                  onChanged: (topic) => setState(() {
                    if (topic == 'all_topics') {
                      filter = null;
                    } else {
                      filter = topic;
                    }
                  }),
                  items: [
                    const DropdownMenuItem<String>(
                      value: 'all_topics',
                      child: Text('All'),
                    ),
                    for (var topic in journal.allTags)
                      DropdownMenuItem<String>(
                        value: topic,
                        child: Text(topic.capitalize()),
                      )
                  ],
                ),
              ),
            )),
          ),
        ),
        body: TutorialHelp(
          'journal',
          title: 'Journal',
          helpText: 'Here you can view all your saved journal entries.\n\n'
              'You can filter entries by topic, and if there any you want to '
              'remove, you can tap the edit icon to select and delete them.',
          child: _JournalView(
            filter: filter,
            editMode: editMode,
            selected: selected,
            onSelect: (entry, value) => setState(() {
              if (value) {
                editMode = true;
                selected.add(entry);
              } else {
                selected.remove(entry);
              }
            }),
          ),
        ),
        floatingActionButton: !editMode
            ? null
            : FloatingActionButton(
                backgroundColor: selected.isEmpty
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).accentColor,
                disabledElevation: 2,
                onPressed: selected.isEmpty ? null : deleteSelected,
                child: const Icon(Icons.delete),
              ),
      ),
    );
  }
}

class _JournalView extends StatelessWidget {
  const _JournalView({
    this.filter,
    this.editMode,
    this.selected,
    this.onSelect,
    Key key,
  }) : super(key: key);

  final String filter;
  final bool editMode;
  final Set<JournalEntry> selected;
  final void Function(JournalEntry, bool) onSelect;

  @override
  Widget build(BuildContext context) => Consumer<JournalProvider>(
        builder: (context, journal, child) {
          final entries = filter == null
              ? journal.entries
              : journal.entries.where((entry) => entry.tags.contains(filter));

          if (entries.isEmpty) {
            return Center(
              child: Text('Journal is empty.'),
            );
          }

          return AnimatedListBuilder<JournalEntry>(
            items: entries.toList().reversed,
            duration: const Duration(milliseconds: 200),
            itemBuilder: (context, entry, animation) => AppearTransition(
              visibility: animation,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Checkbox(
                    key: ValueKey(entry),
                    value: selected.contains(entry),
                    onChanged: (value) => onSelect(entry, value),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: editMode ? 0.9 : 1,
                      end: editMode ? 0.9 : 1,
                    ),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                    builder: (context, scale, child) => Transform.scale(
                      alignment: Alignment.centerRight,
                      scale: scale,
                      child: child,
                    ),
                    child: GestureDetector(
                      onLongPress: () => onSelect(entry, true),
                      onTap: () {
                        if (editMode) {
                          onSelect(entry, !selected.contains(entry));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                        child: JournalEntryView(entry),
                      ),
                    ),
                  )
                ],
              ),
            ),
            viewBuilder: (context, itemCount, builder) => ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4),
              itemCount: itemCount,
              itemBuilder: builder,
            ),
          );
        },
      );
}
