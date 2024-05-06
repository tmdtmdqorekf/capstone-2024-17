import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = "http://3.36.108.21:8080";
const storage = FlutterSecureStorage();

const userToken =
    "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImV4cCI6MTcxMzU5OTA5NiwiaWQiOjF9.HSC3z5gus1gM0DavxjZdhVBZSlUCGhgEbjIYS2-bKng";

// 주변 카페에 있는 모든 유저 목록 받아오기 - http post 요청
Future<Map<String, List<UserModel>>> getAllUsers(
    List<String> cafeList, List<String> sampleCafeList) async {
  try {
    final url = Uri.parse("$baseUrl/cafe/get-users");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
      body: jsonEncode({"cafeList": cafeList}),
    );

    Map<String, List<UserModel>> allUsers = {};
    Map<String, dynamic> jsonResult =
        jsonDecode(utf8.decode(response.bodyBytes));

    jsonResult.forEach((cafe, userList) {
      List<Map<String, dynamic>> userMapList =
          userList.cast<Map<String, dynamic>>();
      allUsers[cafe] =
          userMapList.map((user) => UserModel.fromJson(user)).toList();
    });

    return allUsers;
  } catch (error) {
    print("HTTP POST error: $error");
    throw Error();
  }
}

//매칭 요청
Future<Map<String, dynamic>> matchRequest(
    int senderId, int receiverId, int requestTypeId) async {
  final url = Uri.parse('$baseUrl/match/request');
  String? userToken = await storage.read(key: 'authToken');
  if (userToken == null) {
    userToken =
        "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImV4cCI6MTcxNDczMzU0OCwiaWQiOjF9.er3qIiS_7vMfRScPDTc-sTSOScstX00eTa77qF8u7xw";
  }
  print("userToken$userToken");

  if (userToken != null) {
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
        body: jsonEncode({
          'senderId': senderId,
          'receiverId': receiverId,
          'requestTypeId': requestTypeId
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        print("200");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send match request: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  } else {
    throw Exception('User token is null');
  }
}

//매칭 info 요청
Future<Map<String, dynamic>> matchInfoRequest(
    String matchId, int senderId, int receiverId) async {
  final url = Uri.parse(
      '$baseUrl/match/request/info?matchId=$matchId&senderId=$senderId&receiverId=$receiverId');

  String? userToken = await storage.read(key: 'authToken');
  if (userToken == null) {
    userToken =
        "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImV4cCI6MTcxNDczMzU0OCwiaWQiOjF9.er3qIiS_7vMfRScPDTc-sTSOScstX00eTa77qF8u7xw";
  }
  print("userToken$userToken");
  try {
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
    );
    print("처리중");
    if (response.statusCode == 200) {
      print("O1");
      return json.decode(response.body);
    } else {
      print("O2");
      throw Exception('Failed to get match info: ${response.statusCode}');
    }
  } catch (e) {
    throw e;
  }
}

//match cancel 요청
Future<Map<String, dynamic>> matchCancelRequest(String matchId) async {
  final url = Uri.parse('$baseUrl/match/cancel');
  print("api 들어왔고 matchId는 여기=>$matchId");
  if (matchId == '') {
    matchId = '7044e6c6-b521-4764-bc40-9127dc14d74d';
  }

  try {
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $userToken",
      },
      body: jsonEncode({
        'matchId': matchId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get match info: ${response.statusCode}');
    }
  } catch (e) {
    throw e;
  }
}

// 회원가입
Future<Map<String, dynamic>> signup(String? loginId, String? password,
    String nickname, String email, String phone) async {
  final url = Uri.parse('$baseUrl/auth/signUp');
  final data = jsonEncode({
    'loginId': loginId,
    'password': password,
    'nickname': nickname,
    'email': email,
    'phone': phone,
  });
  try {
    http.Response res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    Map<String, dynamic> jsonData = jsonDecode(res.body);
    print(jsonData);
    return jsonData;
  } catch (error) {
    print('error: $error');
    throw Error();
  }
}

// 로그인
Future<Map<String, dynamic>> login(
  String loginId,
  String password,
) async {
  final url = Uri.parse('$baseUrl/auth/signIn');
  final data = jsonEncode({
    'loginId': loginId,
    'password': password,
  });
  try {
    http.Response res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    Map<String, dynamic> jsonData = jsonDecode(res.body);
    return jsonData;
  } catch (error) {
    print('error: $error');
    throw Error();
  }
}

// 카카오톡 로그인
Future<Map<String, dynamic>> kakaoLogin(String token) async {
  final url = Uri.parse('$baseUrl/auth/kakao/signIn');
  final data = jsonEncode({
    'accessToken': token,
  });
  try {
    http.Response res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    Map<String, dynamic> jsonData = jsonDecode(res.body);
    return jsonData;
  } catch (error) {
    print('error: $error');
    throw Error();
  }
}
