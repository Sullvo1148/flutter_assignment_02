///
/// `homepage.dart`
/// Class for homepage GUI
///

import 'package:flutter/material.dart';
import '../model/to_do.dart';
import '../ui/list_add.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  final ToDoProvider _provider = ToDoProvider();
  List<ToDo> _taskList = List<ToDo>();
  List<ToDo> _completedList = List<ToDo>();
  int _currentIndex = 0;

  void _updateList() {
    this._provider.getAllTask().then((list) {
      setState(() {
        this._taskList = list;
      });
    });
    this._provider.getAllCompleted().then((list) {
      setState(() {
        this._completedList = list;
      });
    });
  }

  @override
  initState() {
    super.initState();
    this._provider.open().then((_) {
      this._updateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<AppBar> appBars = <AppBar>[
      AppBar(
        title: Text('Todo'),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskPage(_updateList),
                  ));
            },
          ),
        ],
      ),
      AppBar(
        title: Text('Todo'),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                this._provider.deleteAllCompleted();
                this._updateList();
              });
            },
          ),
        ],
      ),
    ];

    final List<Widget> pages = <Widget>[
      Center(
        child: (this._taskList.length == 0)
            ? Text('No data found')
            : ListView(
                children: this
                    ._taskList
                    .map(
                      (e) => CheckboxListTile(
                            title: Text(e.title),
                            value: e.done,
                            onChanged: (bool value) {
                              setState(() {
                                e.done = value;
                                this._provider.update(e);
                                this._updateList();
                              });
                            },
                          ),
                    )
                    .toList(),
              ),
      ),
      Center(
        child: (this._completedList.length == 0)
            ? Text('No data found')
            : ListView(
                children: this
                    ._completedList
                    .map(
                      (e) => CheckboxListTile(
                            title: Text(e.title),
                            value: e.done,
                            onChanged: (bool value) {
                              setState(() {
                                e.done = value;
                                this._provider.update(e);
                                this._updateList();
                              });
                            },
                          ),
                    )
                    .toList(),
              ),
      ),
    ];

    return Scaffold(
      appBar: appBars[this._currentIndex],
      body: pages[this._currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: this._currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Task'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: Text('Completed'),
            ),
          ],
          onTap: (int i) {
            setState(() {
              this._currentIndex = i;
            });
          },
        ),
      ),
    );
  }
}
