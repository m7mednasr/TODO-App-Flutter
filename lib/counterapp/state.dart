abstract class CounterState {}


class CounterInitialState extends CounterState {}

class CounterPlusState extends CounterState {
  final int counter;

  CounterPlusState(this.counter);
}


class CounterMuinsState extends CounterState {
  final int counter;

  CounterMuinsState(this.counter);
}

