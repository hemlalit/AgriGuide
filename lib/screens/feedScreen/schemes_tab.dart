import 'package:AgriGuide/providers/scheme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchemesTab extends StatefulWidget {
  const SchemesTab({super.key});

  @override
  State<SchemesTab> createState() => _SchemesTabState();
}

class _SchemesTabState extends State<SchemesTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<SchemeProvider>(context, listen: false).fetchSchemes();
  }

  @override
  Widget build(BuildContext context) {
    final schemeProvider = Provider.of<SchemeProvider>(context);
    final schemesList = schemeProvider.schemes;

    return schemeProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : schemesList.isEmpty
            ? const Center(
                child: Text(
                  "No schemes available.",
                  // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: schemesList.length,
                        itemBuilder: (context, index) {
                          final schemes = schemesList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // News Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      schemes.imageUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                  ),
                                  // News Content
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          schemes.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          schemes.description,
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              schemes.date,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to detailed news
                                              },
                                              child: const Text(
                                                "Read More",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
}
