import 'dart:convert';

import 'package:g_docs_clone/constants.dart';
import 'package:g_docs_clone/models/document_model.dart';
import 'package:g_docs_clone/models/error_model.dart';
import 'package:http/http.dart';

class DocumentRepository {
  final Client _client;

  DocumentRepository(this._client);

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel('Some error occured', null);

    try {
      var res = await _client.post(Uri.parse('$host/doc/create'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }));
      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
            null,
            DocumentModel.fromJson(res.body),
          );
          break;
        default:
          error = ErrorModel(res.body, null);
      }
    } catch (e) {
      error = ErrorModel(e.toString(), null);
    }

    return error;
  }

  void updateTitle(
      {required String token,
      required String id,
      required String title}) async {
    await _client.post(
      Uri.parse('$host/doc/title'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'title': title,
        'id': id,
      }),
    );
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel('Some error occured', null);

    try {
      var res = await _client.get(Uri.parse('$host/doc/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> docs = [];
          for (var doc in jsonDecode(res.body)) {
            docs.add(DocumentModel.fromJson(jsonEncode(doc)));
          }
          error = ErrorModel(null, docs);
          break;
        default:
          error = ErrorModel(res.body, null);
      }
    } catch (e) {
      error = ErrorModel(e.toString(), null);
    }

    return error;
  }

  Future<ErrorModel> getDocumentById(String token, String id) async {
    ErrorModel error = ErrorModel('Some error occured', null);

    try {
      var res = await _client.get(Uri.parse('$host/doc/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      switch (res.statusCode) {
        case 200:
          error = ErrorModel(null, DocumentModel.fromJson(res.body));
          break;
        default:
          throw 'This document does not exist';
      }
    } catch (e) {
      error = ErrorModel(e.toString(), null);
    }

    return error;
  }
}
