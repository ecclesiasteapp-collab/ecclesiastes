import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/signature_pad_widget.dart';

class SignatureScreen extends StatelessWidget {
  final Function(Uint8List?) onSignatureSaved;

  const SignatureScreen({super.key, required this.onSignatureSaved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature Numérique'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Veuillez signer dans le cadre ci-dessous pour valider l\'acte.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SignaturePadWidget(
                onSave: (Uint8List? signature) {
                  onSignatureSaved(signature);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'L\'imposition de la signature numérique a la même valeur que la signature manuscrite pour les rapports internes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

