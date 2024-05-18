import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:supa/customScaffold.dart';
import 'package:supa/paymentScreen.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:supa/main.dart';
import 'package:supa/paymentScreen.dart';

class Qrcodescanner extends StatefulWidget {
  final List<String> files;
  final List<Map<String, dynamic>> options;

  Qrcodescanner({Key? key, required this.files, required this.options}) : super(key: key);

  @override
  State<Qrcodescanner> createState() => _QrcodescannerState();
}

class _QrcodescannerState extends State<Qrcodescanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Future<void> createEntry() async {
    // Ensure there is a QR code result before proceeding
    if (result?.code == null) {
      print('No QR code scanned');
      return;
    }

    // Assuming 'result.code' contains a unique identifier for the entry, such as a user ID or a specific document ID
    String qrcodeinfo = result!.code!;

    // Assuming you have a way to identify the current user, for example, a user ID
    String userId = supabase.auth.currentUser!.id; // Placeholder for actual user identification logic

      List<String> filePaths = widget.files.map((file) => '$userId/$file').toList();
      List<Map<String,dynamic>> options = widget.options;
      await supabase
          .from('file_storage')
          .insert({
            'status': ['PENDING'],
            'options': options,
            'printer_id': qrcodeinfo,
            'file_path': filePaths,
          });

  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text('Flash: ${snapshot.data}',
                                  style: TextStyle(fontSize: 20));
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            if (result != null) {
                              List<String> options = widget.options.map((option) => option.toString()).toList();
                              createEntry();
                              dispose();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PaymentGateway()),
                              );
                              debugPrint(options.toString());

                            }
                          },
                          child: Text('Pay & Print', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('Click',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('click again',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 310.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.greenAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // var data = createJson(result!, widget.files);
      // sendJsonToFirebase(data);
      controller.pauseCamera();
      controller.resumeCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
