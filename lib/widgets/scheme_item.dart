import 'package:flutter/material.dart';
import 'package:AgriGuide/models/scheme_model.dart';

class SchemeItem extends StatelessWidget {
  final Scheme scheme;

  SchemeItem({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen[50],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scheme.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
          ),
          const SizedBox(height: 8),
          Text('Eligibility: ${scheme.eligibility}', style: TextStyle(color: Colors.green[600])),
          const SizedBox(height: 8),
          Text('Benefits: ${scheme.benefits}', style: TextStyle(color: Colors.green[600])),
          const SizedBox(height: 8),
          Text('Details: ${scheme.details}', maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
