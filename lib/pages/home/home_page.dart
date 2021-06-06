import 'package:flutter/material.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/pages/home/widgets/home_view.dart';
import 'package:tasks/pages/new_list/new_list_page.dart';
import 'package:tasks/pages/new_list/rename_list_page.dart';
import 'package:tasks/pages/details/details_page.dart';

class TasksHomePage extends StatefulWidget {
  @override
  _TasksHomePageState createState() => _TasksHomePageState();
}

enum DetailsWidgetStatus { OPEN, CLOSE }

String _newTask = "";
String _taskDetails = "";
String _newTaskStatus = "PENDING";
final List<Task> pendingTaskList = [];
final List<Task> completedTaskList = [];
late AnimationController detailsTapAnimationController;
final _duration = Duration(milliseconds: 300);
DetailsWidgetStatus _detailsWidgetStatus = DetailsWidgetStatus.CLOSE;
List<String> tblNames = [];
String listName = "";
String activeList = "";
String defaultListName = "";
bool details = false;

class _TasksHomePageState extends State<TasksHomePage>
    with TickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    detailsTapAnimationController =
        AnimationController(duration: _duration, vsync: this);
    detailsTapAnimationController.addListener(() {});
    _getTables();
  }

  dispose() {
    super.dispose();
    detailsTapAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        child: const Icon(Icons.add),
        onPressed: () => _newTaskModalBottomSheet(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 8.0,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _modalBottomSheetMenu();
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _modalBottomSheetMore();
              },
            )
          ],
        ),
      ),
      body: HomeView(
        listTitle: 'My Tasks',
        pendingTaskList: [],
        completedTaskList: [],
      ),
    );
  }

  void onTapUp(TapUpDetails tap) {
    if (_detailsWidgetStatus == DetailsWidgetStatus.CLOSE) {
      print("OPEN");
      detailsTapAnimationController.forward(from: 0.0);
      _detailsWidgetStatus = DetailsWidgetStatus.OPEN;
    } else {
      print("CLOSE");
      detailsTapAnimationController.reverse(from: 1.0);
      _detailsWidgetStatus = DetailsWidgetStatus.CLOSE;
    }
    setState(() {});
  }

  Widget dateButton() {
    var scorePosition = detailsTapAnimationController.value * 100;
    var scoreOpacity = detailsTapAnimationController.value;
    return Positioned(
      child: Opacity(
        opacity: scoreOpacity,
        child: Container(
          height: 32.0,
          width: 32.0,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(side: BorderSide.none),
          ),
          child: Center(
            child: Icon(
              Icons.date_range,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      left: scorePosition,
    );
  }

  Widget detailsButton() {
    var scorePosition = detailsTapAnimationController.value * 50;
    var scoreOpacity = detailsTapAnimationController.value;
    return Positioned(
      child: GestureDetector(
        onTapUp: (TapUpDetails tapUp) {
          // print('Tapup');
          // if (details == false) {
          //   setSheetState(() {
          //     details = true;
          //   });
          // } else {
          //   setSheetState(() {
          //     details = false;
          //   });
          // }
        },
        child: Opacity(
          opacity: scoreOpacity,
          child: Container(
            height: 32.0,
            width: 32.0,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(side: BorderSide.none),
            ),
            child: Center(
              child: Icon(
                Icons.format_list_numbered,
                color: (details == false) ? Colors.blue : Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
      left: scorePosition,
    );
  }

  Widget kek() {
    var rotation = detailsTapAnimationController.value == 0.0
        ? detailsTapAnimationController.value
        : detailsTapAnimationController.value + 25;
    var mColor = detailsTapAnimationController.value == 0.0
        ? Colors.blue
        : Colors.blueGrey;
    return GestureDetector(
      onTapUp: onTapUp,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          height: 32.0,
          width: 32.0,
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.transparent,
          ),
          child: Center(
            child: Icon(
              Icons.add_circle,
              color: mColor,
              size: 26.0,
            ),
          ),
        ),
      ),
    );
  }

  // TODO: Original one is this
  void _newTaskModalBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext contextt) {
          return Container(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 15.0,
                          right: 20.0,
                          bottom: 15.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              onChanged: (newTask) {
                                _newTask = newTask;
                              },
                              onSubmitted: (newTask) {
                                onNewTaskSave();
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Task',
                              ),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                            ),
                            (details == true)
                                ? TextField(
                                    onChanged: (taskDetails) {
                                      _taskDetails = taskDetails;
                                    },
                                    onSubmitted: (taskDetails) {
                                      onNewTaskSave();
                                    },
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Add details',
                                      hintStyle: TextStyle(
                                        fontSize: 8.0,
                                      ),
                                    ),
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                  )
                                : Container(),
                            Container(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Stack(
                                  //alignment: AlignmentDirectional.center,
                                  //overflow: Overflow.visible,
                                  children: <Widget>[
                                    detailsButton(),
                                    dateButton(),
                                    kek(),
                                  ],
                                ),
                                FlatButton(
                                  onPressed: () {
                                    onNewTaskSave();
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  color: Colors.white,
                                  splashColor: Colors.blue,
                                  textColor: Theme.of(context).accentColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            //height: 530.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /*UserAccountsDrawerHeader(
                  currentAccountPicture: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/user/satya_profile.png"),
                      ),
                    ),
                  ),
                  margin: EdgeInsets.all(0.0),
                  accountEmail: Text(
                    "satyabrat.me@gmail.com",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  accountName: Text(
                    "Satyabrat Sahoo",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Divider(
                  height: 4.0,
                  indent: 2.0,
                ),*/
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: tblNames.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          listName = tblNames[index];
                          activeList = listName;
                          _getTasks();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: (activeList == tblNames[index])
                                  ? Color(0x4D90CAF9)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                              ),
                            ),
                            child: ListTile(
                              selected: true,
                              title: Text(
                                tblNames[index],
                                style: TextStyle(
                                  color: (activeList == tblNames[index])
                                      ? Colors.blueAccent
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            left: 8.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                        ),
                      );
                    }),
                Divider(
                  height: 4.0,
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    var newListPage = await Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return NewListPage();
                    }));
                    if (newListPage == null) {
                      _getTables();
                    }
                  },
                  leading: Icon(
                    Icons.add,
                  ),
                  title: Text(
                    "Create list",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Divider(
                  height: 4.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.feedback,
                  ),
                  title: Text(
                    "Send feedback",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Divider(
                  height: 4.0,
                ),
                ListTile(
                  title: Text(
                    "Open-source licenses",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Divider(
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 25.0,
                        child: Icon(
                          Icons.arrow_drop_down_circle,
                          size: 5.0,
                        ),
                      ),
                      //Icon(
                      //Icons.,
                      //),
                      Text(
                        "Terms of service",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMore() {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          padding: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  width: 4.0,
                ),
                title: const Text(
                  'My Order',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Icon(Icons.check),
              ),
              ListTile(
                leading: Container(
                  width: 4.0,
                ),
                title: const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: Icon(Icons.check),
              ),
              Divider(
                height: 10.0,
              ),
              ListTile(
                title: const Text(
                  'Rename List',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  var renameListPage = await Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RenameListPage(activeList);
                  }));
                  if (renameListPage == null) {
                    _getTables();
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Delete List',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color:
                        (tblNames.length > 1 && activeList != defaultListName)
                            ? Colors.black
                            : Colors.grey,
                  ),
                ),
                enabled: true,
                onTap: () async {
                  if (tblNames.length > 1 && activeList != defaultListName) {
                    Navigator.pop(context);
                    // await DatabaseHelper.get().deleteTable(activeList);
                    activeList = defaultListName;
                    listName = activeList;
                    _getTables();
                  }
                },
              ),
              ListTile(
                title: const Text(
                  'Delete all completed tasks',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () async {
                  // await DatabaseHelper.get().deleteCompletedTask(activeList);
                  _getTasks();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onNewTaskSave() {
    // if (_newTask != null) {
    //   var task = Task(_newTask, _newTaskStatus, _taskDetails);
    //   var db = DatabaseHelper();
    //   db.saveTask(task, activeList);
    //   Navigator.pop(context);
    //   print("Task saved!");
    //   print("$_newTask");
    //   _getTasks();
    // } else {
    //   print("Empty field!");
    // }
  }

  void updateTaskStatus(String task) {
    // var db = DatabaseHelper();
    // db.updateTask(task, activeList);
    print('Update Task');
  }

  void _getTasks() {
    print("Running _getTasks()");
    if (listName != null && listName != "") {
      // var dbClient = DatabaseHelper();
      // dbClient.getTasksByStatus(listName, "PENDING").then((tasks) {
      //   if (tasks == null) return;
      //   setState(() {
      //     pendingTaskList.clear();
      //     pendingTaskList.addAll(tasks);
      //     //print(tasks.toString());
      //   });
      // });

      // dbClient.getTasksByStatus(listName, "COMPLETED").then((tasks) {
      //   if (tasks == null) return;
      //   setState(() {
      //     completedTaskList.clear();
      //     completedTaskList.addAll(tasks);
      //     //print(tasks.toString());
      //   });
      // });
    } else {
      print("var listName is null");
    }
  }

  void _getTables() {
    // DatabaseHelper.get().getTables().then((tableNames) {
    //   if (tableNames != null) {
    //     tblNames.clear();
    //     for (String item in tableNames) {
    //       setState(() {
    //         print(item);
    //         tblNames.add(item);
    //       });
    //     }
    //     activeList = tblNames[0];
    //     listName = tblNames[0];
    //     defaultListName = tblNames[0];
    //     _getTasks();
    //   } else
    //     print("getTables returned null");
    // });
  }

  Widget completedList() {
    if (completedTaskList.isNotEmpty) {
      return SliverToBoxAdapter(
        child: ExpansionTile(
          title: Text(
            'Completed (${completedTaskList.length})',
          ),
          backgroundColor: Colors.white,
          children: <Widget>[
            Container(
              height: 68.0 * completedTaskList.length,
              child: ListView.builder(
                itemCount: completedTaskList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: ListTile(
                          onTap: () async {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) {
                              return DetailsPage(listName, 0);
                            });
                            var detailsPage =
                                await Navigator.of(context).push(route);
                            if (detailsPage == null) {
                              _getTasks();
                            }
                          },
                          leading: Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                          title: Text(
                            completedTaskList[index].name,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1.0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SliverFillRemaining();
    }
  }
}
