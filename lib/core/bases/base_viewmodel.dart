import 'dart:async';

import 'package:foodapp/core/common/state_rendrer/state_rendrer_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    {}

abstract class BaseViewModelInputs extends BaseViewInput{
  StreamController flowStateController = BehaviorSubject<FlowState>();
  start();
  dispose();

  @override
  Sink get flowStateInput => flowStateController.sink;

  @override
  Stream<FlowState> get flowStateOutput =>
      flowStateController.stream.map((flow) => flow);
}

abstract class BaseViewModelOutputs {}

abstract class BaseViewInput {
  Sink get flowStateInput;
}

abstract class BaseViewOutput {
  Stream<FlowState> get flowStateOutput;
}
