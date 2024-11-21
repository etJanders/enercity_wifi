import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

///Description
///Handle HTTP Requests for API Communication
///
///Author: Julian Anders
///created: 29-11-2022
///changed: 29-1-2022
///
///History:
///
///Notes:
///Todo hier muss auch ein logging rein
abstract class HttpRequestHelper {
  //Function to create database entries
  static const int _durationTimeout = 10;
  static Future<http.Response> postDatabaseEntries(
      {required Uri apiFunction,
      required Map<String, String> httpHeader,
      required Map<String, dynamic> data}) {
    print(
        'HttpRequestHelper -> postDatabaseEntries() apiFunction: $apiFunction json: ${jsonEncode(data)}');
    return http.post(apiFunction, headers: httpHeader, body: jsonEncode(data));
  }

  ///Function to determine api entries
  static Future<http.Response> getDatabaseEntries(
      {required Uri apiFunction, required Map<String, String> httpHeader}) {
    print(
        'HttpRequestHelper -> getDatabaseEntries() apiFunction: $apiFunction');
    return http.get(apiFunction, headers: httpHeader);
  }

  ///Function to update database entries
  static Future<http.Response>? putDatabaseEntries(
      {required Uri apiFunction,
      required Map<String, String> httpHeader,
      required Map<String, dynamic> data}) {
    try {
      return http
          .put(apiFunction, headers: httpHeader, body: jsonEncode(data))
          .timeout(const Duration(seconds: _durationTimeout));
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  ///Function to update database entries
  static Future<http.Response>? putDatabaseEntriesDynamic(
      {required Uri apiFunction,
      required Map<String, String> httpHeader,
      required Map<String, dynamic> data}) {
    try {
      return http
          .put(apiFunction, headers: httpHeader, body: jsonEncode(data))
          .timeout(const Duration(seconds: _durationTimeout));
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  ///Function to delete database entries
  static Future<http.Response> deletedatabaseEntries(
      {required Uri apiFunction,
      required Map<String, String> httpHeader,
      required Map<String, dynamic> data}) {
    return http.delete(apiFunction,
        headers: httpHeader, body: jsonEncode(data));
  }

  //Is used for deleting user account
  static Future<http.Response>? deletedatabaseWithoutEntries(
      {required Uri apiFunction, required Map<String, String> httpHeader}) {
    try {
      return http
          .delete(apiFunction, headers: httpHeader)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  ///Send a Request Ping to API to check avaialability of api
  static Future<http.Response>? pingApi({required Uri pingUrl}) {    print(
      'HttpRequestHelper -> ping() apiFunction: $pingUrl');
    try {
      return http.get(pingUrl).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }
}
