import 'package:flutter/material.dart';
import 'package:frontend/widgets/alert_dialog_yesno_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Matching(),
    );
  }
}

class Matching extends StatefulWidget {
  const Matching({Key? key}) : super(key: key);

  @override
  _MatchingWidgetState createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<Matching> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 131, 88, 1.0), // 배경색 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0),
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
                    padding: EdgeInsets.only(top: 58, right: 0), // 패딩 설정
                    child: Container(
                      width: 310, // 원의 너비
                      height: 310, // 원의 높이
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // 원 모양 설정
                        color: Color.fromRGBO(255, 201, 186, 1.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150, // 텍스트 상위 여백 설정
                    child: Text(
                      'goodnavers X cupang',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),Positioned(
                    top: 200,
                    left: 80,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png', // 이미지의 경로
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png', // 이미지의 경로
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

            //이부분은 유저 상세보기 하는 그 코드 쓰면 될 듯
            Padding(
              padding: const EdgeInsets.only(top: 80), // 버튼 주위의 패딩 설정
              child: SizedBox(
                width: 350, // 버튼의 너비 설정
                height: 80, // 버튼의 높이 설정
                child: ElevatedButton(
                  onPressed: () {
                    showAlertDialogYesNo(context,"커피챗 종료","커피챗을 종료하고 나가시겠습니까?");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // 버튼의 내부 패딩 설정
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // 버튼의 모양 설정
                    backgroundColor: Color.fromRGBO(75, 30, 8, 1.0), // 버튼의 배경색 설정
                  ),
                  child: Text(
                    '커피챗 종료',
                    style: TextStyle(fontSize: 25, color: Colors.white), // 버튼 텍스트의 스타일 설정
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
