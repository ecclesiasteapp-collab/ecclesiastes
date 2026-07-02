import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePadDialog extends StatefulWidget {
  final String title;
  const SignaturePadDialog({super.key, this.title = 'Signature Officielle'});

  @override
  State<SignaturePadDialog> createState() => _SignaturePadDialogState();
}

class _SignaturePadDialogState extends State<SignaturePadDialog> {
  late SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: const Color(0xFF003366),
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
    return AlertDialog(
      title: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Veuillez signer à l\'intérieur du cadre ci-dessous pour valider ce document.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Signature(
              controller: _controller,
              height: 200,
              backgroundColor: Colors.grey[50]!,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ANNULER'),
        ),
        IconButton(
          onPressed: () => _controller.clear(),
          icon: const Icon(Icons.refresh, color: Colors.orange),
          tooltip: 'Effacer',
        ),
        ElevatedButton(
          onPressed: _exportSignature,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003366),
            foregroundColor: Colors.white,
          ),
          child: const Text('VALIDER'),
        ),
      ],
    );
  }

  Future<void> _exportSignature() async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez signer avant de valider.')),
      );
      return;
    }

    final Uint8List? data = await _controller.toPngBytes();
    if (data != null) {
      final String base64Signature = base64Encode(data);
      if (mounted) {
        Navigator.pop(context, base64Signature);
      }
    }
  }
}

