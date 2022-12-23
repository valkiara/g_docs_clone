import 'dart:convert';
import 'package:g_docs_clone/constants.dart';
import 'package:g_docs_clone/models/error_model.dart';
import 'package:g_docs_clone/models/user_model.dart';
import 'package:g_docs_clone/repository/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(GoogleSignIn(), Client(), LocalStorageRepository()),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      this._googleSignIn, this._client, this._localStorageRepository);

  Future<ErrorModel> singInWIthGoogle() async {
    ErrorModel error = ErrorModel('Some error occured', null);

    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            name: user.displayName!,
            email: user.email,
            profilePic: user.photoUrl!,
            uid: '',
            token: '');

        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(null, newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          default:
            throw Exception('Something went wrong');
        }
      }
    } on Exception catch (e) {
      error = ErrorModel(e.toString(), null);
    }

    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel('Some error occured', null);

    try {
      final token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(Uri.parse('$host/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
            final user =
                UserModel.fromJson(jsonEncode(jsonDecode(res.body)['user']))
                    .copyWith(token: token);
            error = ErrorModel(null, user);
            _localStorageRepository.setToken(user.token);
            break;
          default:
            throw Exception('Something went wrong');
        }
      }
    } on Exception catch (e) {
      error = ErrorModel(e.toString(), null);
    }

    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}
