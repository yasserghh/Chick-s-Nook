import 'package:foodapp/core/network/error_handler.dart';
import 'package:foodapp/core/network/network_info.dart';
import 'package:foodapp/moduls/authentication/data/mappers/mappers.dart';
import 'package:foodapp/core/remote_data_source/remote_data_source.dart';
import 'package:foodapp/moduls/authentication/domain/models/models.dart';
import 'package:foodapp/core/network/requests.dart';
import 'package:foodapp/core/network/faileur.dart';
import 'package:dartz/dartz.dart';
import 'package:foodapp/moduls/authentication/domain/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  NetworkInfo _networkInfo;
  RemoteDataSource _remoteDataSource;
  AuthenticationRepositoryImpl(this._networkInfo, this._remoteDataSource);
  @override
  Future<Either<Faileur, Login>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.login(loginRequest);
        print("----------repository ---------------");
        print("+++${response.message}+++");
        // ignore: unnecessary_null_comparison
        if (response.message == 'ok') {
    
          return right(response.toDomain());
        } else {
          return left(DataSource.DEFAULT.getFaileur());
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).faileur);
      }
    } else {
      return left(DataSource.NO_CONNECTION_INTERNET.getFaileur());
    }
  }

  @override
  Future<Either<Faileur, Map<String,dynamic>>> signup(SignupRequest signupRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.signup(signupRequest);
        // ignore: unnecessary_null_comparison
        if (response != null) {
          return right(response);
        } else {
          return left(DataSource.DEFAULT.getFaileur());
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).faileur);
      }
    } else {
      return left(DataSource.NO_CONNECTION_INTERNET.getFaileur());
    }
  }

  @override
  Future<Either<Faileur, Login>> check_email_phone(
      Check_email_phone_request checkRequist) async {
    if (await _networkInfo.isConnected) {
      try {
         print("------");
        var response = await _remoteDataSource.check_email_phone(checkRequist);
        print("${response.message} ------");
        // ignore: unnecessary_null_comparison
        if (response.message == 'ok') {
          return right(response.toDomain());
        } else if (response.message == 'Forbidden') {
          return left(
              Faileur(1, ' رقم الهاتف محجوز بالفعل'));
        } else {
          return left(DataSource.DEFAULT.getFaileur());
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).faileur);
      }
    } else {
      return left(DataSource.NO_CONNECTION_INTERNET.getFaileur());
    }
  }

  @override
  Future<Either<Faileur, Login>> updateUser(
      UpdateUserRequest updateUserRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.updateUser(updateUserRequest);
        // ignore: unnecessary_null_comparison
        if (response.message == 'ok') {
          return right(response.toDomain());
        } else {
          return left(DataSource.DEFAULT.getFaileur());
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).faileur);
      }
    } else {
      return left(DataSource.NO_CONNECTION_INTERNET.getFaileur());
    }
  }

  @override
  Future<Either<Faileur, String>> checkPhoneForgout(String phone) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _remoteDataSource.checkPhoneForgout(phone);
        if (response.message == 'OK') {
          return right('');
        } else {
          return left(DataSource.DEFAULT.getFaileur());
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).faileur);
      }
    } else {
      return left(DataSource.NO_CONNECTION_INTERNET.getFaileur());
    }
  }

  @override
  Future<Either<Faileur, String>> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        var response =
            await _remoteDataSource.changePassword(changePasswordRequest);
        if (response.message == 'OK') {
          return right('');
        } else {
          return left(DataSource.DEFAULT.getFaileur());
        }
      } catch (e) {
        return left(ErrorHandler.handle(e).faileur);
      }
    } else {
      return left(DataSource.NO_CONNECTION_INTERNET.getFaileur());
    }
  }
}
