import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/utility.dart';
import 'package:seeds/widgets/journal_entry.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String filter;
  bool editMode;
  List<bool> selected;

  void toggleEditMode({int selectedIndex = -1}) {
    setState(() {
      editMode = !editMode;
      selected = List<bool>();
    });
  }

  void deleteSelected() {
    for(int i = 0; i < selected.length; i++) {
      if (selected[i]) {
        Provider.of<JournalData>(context, listen: false).deleteEntry(index: i);
        selected.removeAt(i);
        i--;
      }
    }

    toggleEditMode();
  }

  @override
  void initState() {
    super.initState();
    filter = "All";
    editMode = false;
    selected = List<bool>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Journal'),
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
                Text('Topics'),
                SizedBox(width: 12.0,),
                DropdownButton<String>(
                  value: filter,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (topic) => setState(() => filter = topic),

                  items: [DropdownMenuItem<String>(
                    value: 'All',
                    child: Text('All'),
                  )] +
                  Provider.of<Library>(context, listen: false).topics.map((topic) => DropdownMenuItem<String>(
                    value: topic.capitalize(),
                    child: Text(topic.capitalize()),
                  )).toList()
                ),
              ],
            ),
          ),
        ),
      ),

      body: Consumer<JournalData>(
        builder: (context, journal, child) {
          for (int i = selected.length; i < journal.entries.length; i++)
            selected.add(false);

          return ListView(
            padding: EdgeInsets.only(bottom: 12.0),
            children: <Widget>[
              for (int index = 0; index < journal.entries.length; index++)
                if (filter == 'All' || journal.entries[index].tags.contains(filter.toLowerCase()))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Checkbox(
                          value: selected[index],
                          onChanged: (value) => setState(() => selected[index] = value),
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

                            child: JournalEntryView(journal.entries[index])
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
    );
  }
}
