import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePadWidget extends StatefulWidget {
  final Function(Uint8List?) onSave;
  const SignaturePadWidget({super.key, required this.onSave});

  @override
  State<SignaturePadWidget> createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  late SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: Signature(controller: _controller, backgroundColor: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => _controller.clear(), child: const Text("Effacer")),
            ElevatedButton(
              onPressed: () async {
                final bytes = await _controller.toPngBytes();
                widget.onSave(bytes);
              },
              child: const Text("Valider la signature"),
            ),
          ],
        ),
      ],
    );
  }
}
