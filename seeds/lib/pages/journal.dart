import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/data/journal.dart';
import 'package:seeds/services/utility.dart';
import 'package:seeds/widgets/dialogs/erase_journal_entry.dart';
import 'package:seeds/widgets/journal_entry.dart';

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
      selected = Set<JournalEntry>();

      if (selectedEntry != null)
        selected.add(selectedEntry);
    });
  }

  void deleteSelected() {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => EraseEntryDialog(selected)
    ).then((deleted) {
      if (deleted) {
        checkFilter();
        toggleEditMode();
      }
    });
  }

  void checkFilter() {
    if (!Provider.of<JournalData>(context, listen: false).topics.contains(filter))
      filter = null;
  }

  @override
  void initState() {
    super.initState();

    filter = widget.defaultFilter;
    checkFilter();
    editMode = false;
    selected = Set<JournalEntry>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (editMode) {
          setState(() => editMode = false);
          return false;
        } else
          return true;
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('Journal'),
          actions: <Widget>[
            IconButton(
              icon: Icon(editMode ? Icons.cancel : Icons.edit),
              onPressed: () => toggleEditMode(),
            )
          ],

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Topic', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white)),
                  SizedBox(width: 16.0),
                  Consumer<JournalData>(
                    builder: (context, journal, child) => DropdownButton<String>(
                      value: filter,
                      dropdownColor: Theme.of(context).primaryColor,
                      iconEnabledColor: Colors.white,
                      onChanged: (topic) => setState(() => filter = topic),

                      items: [DropdownMenuItem<String>(
                        value: null,
                        child: Text('All', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white)),
                      )] + journal.topics.map(
                        (topic) => DropdownMenuItem<String>(
                          value: topic,
                          child: Text(topic.capitalize(), style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white)),
                        )
                      ).toList()
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        body: Consumer<JournalData>(
          builder: (context, journal, child) {
            List<JournalEntry> entries = journal.entries.reversed.toList();

            if (filter != null)
              entries.removeWhere((entry) => !entry.tags.contains(filter));

            if (entries.length == 0)
              return Center(child: Text('Journal is empty.'),);

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 12.0),
              itemCount: entries.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Checkbox(
                      value: selected.contains(entries[index]),
                      onChanged: (value) => setState(() {
                        if (value)
                          selected.add(entries[index]);
                        else
                          selected.remove(entries[index]);
                      }),
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 1, end: editMode ? 0.9 : 1),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                      builder: (context, scale, child) =>
                          Transform.scale(
                              alignment: Alignment.centerRight,
                              scale: scale,
                              child: child
                          ),

                      child: GestureDetector(
                        onLongPress: () {
                          if (!editMode)
                            toggleEditMode(selectedEntry: entries[index]);
                          else if (!selected.contains(entries[index]))
                            setState(() => selected.add(entries[index]));
                        },
                        onTap: () {
                          if (editMode) {
                            if (selected.contains(entries[index]))
                              setState(() => selected.remove(entries[index]));
                            else
                              setState(() => selected.add(entries[index]));
                          }
                        },

                        child: JournalEntryView(entries[index])
                      )
                    )
                  ],
                ),
              )
            );
          },
        ),

        floatingActionButton: !editMode ? null : FloatingActionButton(
          child: Icon(Icons.delete),
          backgroundColor: selected.length == 0 ? Colors.grey[500] : Theme.of(context).accentColor,
          onPressed: selected.length == 0 ? null : deleteSelected,
        ),
      ),
    );
  }
}
