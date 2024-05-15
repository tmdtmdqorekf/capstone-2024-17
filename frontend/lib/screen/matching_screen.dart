import 'package:flutter/material.dart';
import 'package:frontend/screen/coffeechat_rating_screen.dart';
import 'package:frontend/service/api_service.dart';
import 'package:frontend/widgets/alert_dialog_yesno_widget.dart';

class Matching extends StatefulWidget {
  final String matchId;
  final String sendercompany;
  final String sendername;
  final int senderId;

  const Matching({
    Key? key,
    required this.sendername,
    required this.matchId,
    required this.sendercompany,
    required this.senderId,
  }) : super(key: key);

  @override
  _MatchingWidgetState createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<Matching> {
  //무직이나 취준일 때 default 이미지 필요할 듯
  var imgpath1 = 'bean(1).png';
  var imgpath2 = 'cafe.jpeg';

  String username = '';
  String usercompany = '';
  int userId = 0;

  void userinfo() async {
    print("userinfo in!");
    try {
      Map<String, dynamic> res = await getUserDetail();
      print(res);
      if (res['success']) {
        setState(() {
          userId = res['data']['userId'];
          username = res['data']['nickname'];
          usercompany = res['data']['company']['name'];
        });
      } else {
        print(
            '로그인된 유저 정보를 가져올 수 없습니다: ${res["message"]}(${res["statusCode"]})');
      }
    } catch (e) {
      throw Error();
    }
    usercompany = usercompany ?? '커리어 한잔';
  }

  @override
  void initState() {
    super.initState();
    userinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 131, 88, 1.0), // 배경색 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 0.0, bottom: 0),
              child: Text(
                '커피챗 진행중 • • • ', // 텍스트
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0), // 이미지와 텍스트 간격 조절
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/magnifier.png',
                    width: 400,
                    height: 400,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 58, right: 0), // 패딩 설정
                    child: Container(
                      width: 310, // 원의 너비
                      height: 310, // 원의 높이
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, // 원 모양 설정
                        color: Color.fromRGBO(255, 201, 186, 1.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150, // 텍스트 상위 여백 설정
                    child: Text(
                      '$username X ${widget.sendername}',
                      // 회사 이름이 길어졌을 때 논의 필요
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: 80,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/${usercompany}-logo.png', // 이미지의 경로
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    right: 80,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/${widget.sendercompany}-logo.png', // 이미지의 경로
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80), // 버튼 주위의 패딩 설정
              child: SizedBox(
                width: 350, // 버튼의 너비 설정
                height: 80, // 버튼의 높이 설정
                child: ElevatedButton(
                  onPressed: () {
                    showCoffeeChatExitDialog(
                        context,
                        "커피챗 종료",
                        "커피챗을 종료하고 나가시겠습니까?",
                        userId,
                        widget.senderId,
                        widget.sendername);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20), // 버튼의 내부 패딩 설정
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)), // 버튼의 모양 설정
                    backgroundColor:
                        const Color.fromRGBO(75, 30, 8, 1.0), // 버튼의 배경색 설정
                  ),
                  child: const Text(
                    '커피챗 종료',
                    style: TextStyle(
                        fontSize: 25, color: Colors.white), // 버튼 텍스트의 스타일 설정
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCoffeeChatExitDialog(BuildContext context, String title,
    String message, int userId, int senderId, String sendername) async {
  // 다이얼로그를 표시하고 사용자의 선택을 기다립니다.
  bool result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      // AlertDialog 생성
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          // "예"를 선택하면 Navigator를 통해 true를 반환합니다.
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('종료'),
          ),
          // "아니오"를 선택하면 Navigator를 통해 false를 반환합니다.
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('취소'),
          ),
        ],
      );
    },
  );

  // 사용자의 선택에 따라 다른 동작을 실행합니다.
  if (result != null) {
    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoffeeChatRating(
            userId: userId,
            senderId: senderId,
            sendername: sendername,
          ),
        ),
      );
    }
  }
}
