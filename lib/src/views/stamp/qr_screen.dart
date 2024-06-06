import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../utils/secure_storage.dart';

class QrScreen extends StatefulWidget {
  final String courseName;

  const QrScreen({
    super.key,
    required this.courseName,
  });

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Timer? timer;
  bool _canScan = false;
  bool _dontScan = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void qrCheck(String qrCode) async {
    final dio = Dio();
    final ip = dotenv.get("SERVER_URL");
    String? token = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      Response response = await dio.post('$ip/api/course/qr',
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }),
          data: {
            "qrCode": qrCode,
          });

      print("----성공---");
      print(response);
    } on DioException catch (e) {
      print("----에러---");
      print(e.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.courseName} 인증"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        final qrCode = result!.code;
        if (qrCode == widget.courseName && !_canScan) {
          _canScan = true;
          _dontScan = true;
          qrCheck(qrCode!);
          Navigator.of(context).pop(context);
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("방문이 확인되었습니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Text("확인"),
                ),
              ],
            ),
          );
        }
        if (_dontScan == false) {
          _dontScan = true;
          Navigator.of(context).pop(context);
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("qr코드를 다시 확인해주세요"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Text("확인"),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
