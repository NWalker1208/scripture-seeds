import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../services/data/journal.dart';
import '../services/utility.dart';
import '../widgets/dialogs/erase_journal_entry.dart';
import '../widgets/journal_entry.dart';

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
      if (deleted) {
        checkFilter();
        toggleEditMode();
      }
    });
  }

  void checkFilter() {
    if (!Provider.of<JournalData>(context, listen: false)
        .topics
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
  Widget build(BuildContext context) => WillPopScope(
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
                icon: Icon(editMode ? Icons.cancel : Icons.edit),
                onPressed: toggleEditMode,
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ListTileTheme(
                textColor: Colors.white,
                child: ListTile(
                  title: const Text('Topic'),
                  trailing: Consumer<JournalData>(
                    builder: (context, journal, child) =>
                        DropdownButton<String>(
                      value: filter,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.white),
                      dropdownColor: Theme.of(context).primaryColor,
                      iconEnabledColor: Colors.white,
                      onChanged: (topic) => setState(() => filter = topic),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All'),
                        ),
                        ...journal.topics.map(
                          (topic) => DropdownMenuItem<String>(
                            value: topic,
                            child: Text(topic.capitalize()),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Consumer<JournalData>(
            builder: (context, journal, child) {
              var entries = journal.entries.reversed.toList();

              if (filter != null) {
                entries.removeWhere((entry) => !entry.tags.contains(filter));
              }

              if (entries.isEmpty) {
                return Center(
                  child: Text('Journal is empty.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 12.0),
                itemCount: entries.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Checkbox(
                        value: selected.contains(entries[index]),
                        onChanged: (value) => setState(() {
                          if (value) {
                            selected.add(entries[index]);
                          } else {
                            selected.remove(entries[index]);
                          }
                        }),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1, end: editMode ? 0.9 : 1),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        builder: (context, scale, child) => Transform.scale(
                          alignment: Alignment.centerRight,
                          scale: scale,
                          child: child,
                        ),
                        child: GestureDetector(
                          onLongPress: () {
                            if (!editMode) {
                              toggleEditMode(selectedEntry: entries[index]);
                            } else if (!selected.contains(entries[index])) {
                              setState(() => selected.add(entries[index]));
                            }
                          },
                          onTap: () {
                            if (editMode) {
                              if (selected.contains(entries[index])) {
                                setState(() => selected.remove(entries[index]));
                              } else {
                                setState(() => selected.add(entries[index]));
                              }
                            }
                          },
                          child: JournalEntryView(entries[index]),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: !editMode
              ? null
              : FloatingActionButton(
                  child: const Icon(Icons.delete),
                  backgroundColor: selected.isEmpty
                      ? Colors.grey[500]
                      : Theme.of(context).accentColor,
                  onPressed: selected.isEmpty ? null : deleteSelected,
                ),
        ),
      );
}
