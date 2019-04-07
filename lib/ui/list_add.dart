///
/// `add_task_page.dart`
/// Class for adding task page GUI
///

import 'package:flutter/material.dart';
import '../model/to_do.dart';

class AddTaskPage extends StatefulWidget {
  final Function _updateList;

  AddTaskPage(this._updateList);

  @override
  State<StatefulWidget> createState() {
    return _AddTaskPageState();
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  final ToDoProvider _provider = ToDoProvider();
  final TextEditingController _subjectController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this._provider.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
        centerTitle: true,
      ),
      body: Form(
        key: this._formKey,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Subject',
              ),
              controller: this._subjectController,
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Please fill subject';
                }
              },
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                if (this._formKey.currentState.validate()) {
                  this
                      ._provider
                      .insert(ToDo(title: this._subjectController.text.trim()));
                  Navigator.pop(context);
                  widget._updateList();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
