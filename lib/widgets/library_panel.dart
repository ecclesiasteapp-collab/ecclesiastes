import 'package:flutter/material.dart';

class LibraryAccessPanel extends StatelessWidget {
  final List<String> refs;
  final VoidCallback onTap;

  const LibraryAccessPanel({super.key, required this.refs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
        side: BorderSide(color: Colors.indigo.shade100)
      ),
      child: ListTile(
        leading: const Icon(Icons.library_books, color: Colors.indigo),
        title: const Text('Ressources Documentaires', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('Directive v3 : ${refs.join(", ")}', 
          style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: onTap,
      ),
    );
  }
}
