import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/counterapp/state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitialState());

  static CounterCubit get(context) => BlocProvider.of(context);

  int counter = 1;

  void minus() {
    counter--;
    emit(CounterMuinsState(counter));
  }

  void plus() {
    counter++;
    emit(CounterPlusState(counter));
  }
}
