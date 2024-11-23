import 'package:dartz/dartz.dart';
import 'package:foodapp/core/network/faileur.dart';

abstract class BaseUseCase<Inputs, Outputs> {
  Future<Either<Faileur, Outputs>> excute(Inputs inputs);
}
