import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'exceptions.dart';

/// Operates as a helper class for making network calls.
///
/// Focuses on implementing GET and POST requests. Responses are first handled
/// by [returnResponse()] and checked for errors before returning their bodies.
class NetworkService {
  // static const String _version = 'v1';
  // static const String _baseUrl =
  //     'https://passapp-illusionaire-e3bd84430bf2.herokuapp.com/api/$_version';
  // static String authentication = '';
  // static String _tenantId = '';
  // static final Map<String, String> _headers = {
  //   'Accept-Charset': 'utf-8',
  //   'Content-Type': 'application/json',
  // };

  static Future getImageApiResponse(String url) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(Uri.encodeFull(url)));
      request.followRedirects = false;
      var response = await request.close();
      client.close();
      return response.headers.value(HttpHeaders.locationHeader);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  /// Returns the response body in JSON format from a GET request.
  static Future getApiResponse(String url) async {
    try {
      final response = await http.get(Uri.parse(Uri.encodeFull(url)));
      final responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  /// Returns the response body in JSON format from a POST request.
  static Future postApiResponse(
    String url,
    dynamic data,
    dynamic headers,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));
      final responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }
}

/// Checks the response status code and throws an [AppException] if an error is found.
dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
      return jsonDecode(response.body);
    case 400:
    case 401:
    case 402:
    case 404:
      throw BadRequestException(jsonDecode(response.body)['detail']);
    case 500:
      throw BadRequestException(response.body.toString());
    default:
      throw FetchDataException(
          "Error while communicating with server with status code ${response.statusCode}");
  }
}
