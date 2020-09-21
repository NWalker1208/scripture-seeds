import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/utility.dart';
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
  List<int> selected;

  void toggleEditMode({int selectedIndex}) {
    setState(() {
      editMode = !editMode;
      selected = List<int>();

      if (selectedIndex != null)
        selected.add(selectedIndex);
    });
  }

  void deleteSelected() {
    selected.sort();
    selected = selected.reversed.toList();

    for(int i = 0; i < selected.length; i++)
      Provider.of<JournalData>(context, listen: false).deleteEntry(index: selected[i]);

    toggleEditMode();
  }

  @override
  void initState() {
    super.initState();
    filter = widget.defaultFilter;
    editMode = false;
    selected = List<int>();
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
                  DropdownButton<String>(
                    value: filter,
                    dropdownColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.arrow_drop_down),
                    iconEnabledColor: Colors.white,
                    onChanged: (topic) => setState(() => filter = topic),

                    items: [DropdownMenuItem<String>(
                      value: null,
                      child: Text('All', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white)),
                    )] +
                    Provider.of<Library>(context, listen: false).topics.map((topic) => DropdownMenuItem<String>(
                      value: topic,
                      child: Text(topic.capitalize(), style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white)),
                    )).toList()
                  ),
                ],
              ),
            ),
          ),
        ),

        body: Consumer<JournalData>(
          builder: (context, journal, child) {
            return ListView(
              padding: EdgeInsets.only(bottom: 12.0),
              children: <Widget>[
                for (int index = 0; index < journal.entries.length; index++)
                  if (filter == null || journal.entries[index].tags.contains(filter))
                    Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Checkbox(
                            value: selected.contains(index),
                            onChanged: (value) => setState(() {
                              if (value)
                                selected.add(index);
                              else
                                selected.remove(index);
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
                                    toggleEditMode(selectedIndex: index);
                                  else if (!selected.contains(index))
                                    setState(() => selected.add(index));
                                },
                                onTap: () {
                                  if (editMode) {
                                    if (selected.contains(index))
                                      setState(() => selected.remove(index));
                                    else
                                      setState(() => selected.add(index));
                                  }
                                },

                                child: JournalEntryView(journal.entries[index])
                              )
                          )
                        ],
                      ),
                    )
              ]
            );
          },
        ),

        floatingActionButton: !editMode ? null : FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: deleteSelected,
        ),
      ),
    );
  }
}
