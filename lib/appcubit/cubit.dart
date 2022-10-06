// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/appcubit/state.dart';
import 'package:todo_app/module/archived_task.dart';
import 'package:todo_app/module/done_task.dart';
import 'package:todo_app/module/task.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [const Task(), const Donetask(), const Archivedtask()];
  List<String> titles = ['New Task', 'Done Task', 'Archived Task'];

  void currentchage(int index) {
    currentIndex = index;
    emit(BottomChangeState());
  }

  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createdatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT  )')
            .then((value) {
          print("table created ");
        }).catchError((error) {
          print("error ${error.toString()}");
        });
      },
      onOpen: (database) {
        getdatafromdatabase(database);
        print("database opend");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBase());
    });
  }

  inserttodatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    await database!.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
            .then((value) {
          print("Data inserted Successfully");
          emit(AppInsretDataBase());

          getdatafromdatabase(database);
        }).catchError((error) { 
          print("Error ${error.toString()}");
        }));
  }

  void getdatafromdatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoading());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'Done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetDataBase());
    });
  }

  void updatedata({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks set status = ? WHERE id = ? ',
        [status, id]).then((value) {
      getdatafromdatabase(database);
      emit(AppUpdateDataBase());
    });
  }

  void deletedata({required int id}) async {
    database!
        .rawDelete('DELETE FROM tasks WHERE id = ? ', [id]).then((value) {
      getdatafromdatabase(database);
      emit(AppDeleteDataBase());
    });
  }

  bool isbottomshet = false;

  IconData iconfab = Icons.edit;

  void functionchage({
    required bool shown,
    required IconData icon,
  }) {
    isbottomshet = shown;
    iconfab = icon;
    emit(Appfunctionchage());
  }
}
