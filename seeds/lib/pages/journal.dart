import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/widgets/journal_entry.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
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
            icon: Icon(Icons.edit),
            onPressed: () => toggleEditMode(),
          )
        ],
      ),

      body: Consumer<JournalData>(
        builder: (context, journal, child) {
          return ListView.builder(
            itemCount: journal.entries.length,
            itemBuilder: (context, index) {
              if (index > selected.length - 1)
                selected.add(false);

              return Padding(
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
              );
            }
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
