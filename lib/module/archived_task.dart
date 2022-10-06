import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/appcubit/cubit.dart';
import 'package:todo_app/appcubit/state.dart';
import 'package:todo_app/companent/componant.dart';

class Archivedtask extends StatelessWidget {
  const Archivedtask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return widgetbuilding(tasks: tasks);
      },
    );
  }
}
