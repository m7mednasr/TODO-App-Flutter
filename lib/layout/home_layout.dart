// ignore_for_file: avoid_print, must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/appcubit/cubit.dart';
import 'package:todo_app/appcubit/state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var tittlecontroler = TextEditingController();
  var timecontroler = TextEditingController();
  var datecontroler = TextEditingController();

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createdatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsretDataBase) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              builder: (context) => cubit.screens[cubit.currentIndex],
              condition: state is! AppLoading,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbottomshet) {
                  if (formkey.currentState!.validate()) {
                    cubit.inserttodatabase(
                        title: tittlecontroler.text,
                        time: timecontroler.text,
                        date: datecontroler.text);
                  }
                } else {
                  scaffoldkey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  onTap: () {},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(),
                                    ),
                                    labelText: 'Task Tittle',
                                    prefix: const Icon(Icons.title),
                                  ),
                                  controller: tittlecontroler,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must be not empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timecontroler.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(),
                                    ),
                                    labelText: 'Task Time',
                                    prefix:
                                        const Icon(Icons.watch_later_outlined),
                                  ),
                                  controller: timecontroler,
                                  keyboardType: TextInputType.datetime,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time must be not empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-10-08'),
                                    ).then((value) {
                                      datecontroler.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value));
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: const BorderSide(),
                                    ),
                                    labelText: 'Task Date',
                                    prefix: const Icon(
                                        Icons.calendar_today_outlined),
                                  ),
                                  controller: datecontroler,
                                  keyboardType: TextInputType.datetime,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'date must be not empty';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.functionchage(shown: false, icon: Icons.edit);
                  });
                  cubit.functionchage(shown: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.iconfab),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.currentchage(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Task"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived")
              ],
            ),
          );
        },
      ),
    );
  }
}
