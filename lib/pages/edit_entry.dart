import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocks/journal_edit_bloc_provider.dart';
import '../blocks/journal_entry_bloc.dart';
import '../classes/format_date.dart';
import '../classes/mood_icons.dart';

class EditEntry extends StatefulWidget {
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = MoodIcons();
    _noteController = TextEditingController();
    _noteController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;
  }

  @override
  dispose() {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              _initialDate.hour,
              _initialDate.minute,
              _initialDate.second,
              _initialDate.millisecond,
              _initialDate.microsecond)
          .toString();
    }

    return selectedDate;
  }

  void _addOrUpdateJournal() {
    _journalEditBloc.saveJournalChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Entry',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                  stream: _journalEditBloc.dateEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 22.0,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            _formatDates
                                .dateFormatShortMonthDayYear(snapshot.data),
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        String _pickerDate = await _selectDate(snapshot.data);
                        _journalEditBloc.dateEditChanged.add(_pickerDate);
                      },
                    );
                  }),
              StreamBuilder(
                  stream: _journalEditBloc.moodEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return DropdownButtonHideUnderline(
                        child: DropdownButton<MoodIcons>(
                      value: _moodIcons.getMoodIconsList()[_moodIcons
                          .getMoodIconsList()
                          .indexWhere((icon) => icon.title == snapshot.data)],
                      onChanged: (selected) {
                        if (selected != null) {
                          _journalEditBloc.moodEditChanged.add(selected.title!);
                        }
                      },
                      items: _moodIcons
                          .getMoodIconsList()
                          .map((MoodIcons selected) {
                        return DropdownMenuItem<MoodIcons>(
                          value: selected,
                          child: Row(
                            children: <Widget>[
                              Transform(
                                transform: Matrix4.identity()
                                  ..rotateZ(_moodIcons
                                      .getMoodRotation(selected.title!)),
                                alignment: Alignment.center,
                                child: Icon(
                                    _moodIcons.getMoodIcon(selected.title!),
                                    color: _moodIcons
                                        .getMoodColor(selected.title!)),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text(selected.title!)
                            ],
                          ),
                        );
                      }).toList(),
                    ));
                  }),
              StreamBuilder(
                stream: _journalEditBloc.noteEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _noteController.value =
                      _noteController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                    onChanged: (note) =>
                        _journalEditBloc.noteEditChanged.add(note),
                  );
                },
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8.0),
                TextButton(
                    child: Text('Save'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreen.shade100,
                    ),
                    onPressed: () {
                      _addOrUpdateJournal();
                    })
              ])
            ],
          ),
        ),
      ),
    );
  }
}
