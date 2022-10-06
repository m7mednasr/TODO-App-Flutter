import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/appcubit/cubit.dart';

Widget taskItem(Map module, context) => Dismissible(
      key: Key(module['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text('${module['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${module['title']}',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${module['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updatedata(status: 'new', id: module['id']);
              },
              icon: const Icon(
                Icons.task_outlined,
                color: Color.fromARGB(255, 22, 14, 15),
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updatedata(status: 'Done', id: module['id']);
              },
              icon: const Icon(
                Icons.check_box_outlined,
                color: Color.fromARGB(255, 52, 107, 80),
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updatedata(status: 'Archived', id: module['id']);
              },
              icon: const Icon(
                Icons.archive_outlined,
                color: Color.fromARGB(255, 22, 14, 15),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deletedata(id: module['id']);
      },
    );


Widget widgetbuilding ({required List<Map> tasks}) => ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) => taskItem(tasks[index], context),
              separatorBuilder: (context, index) => Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    height: 1.0,
                  ),
              itemCount: tasks.length),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  size: 70.0,
                  color: Color.fromARGB(255, 118, 179, 207),
                ),
                Text(
                  'No Tasks yet , please add some tasks!!',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),  
        );