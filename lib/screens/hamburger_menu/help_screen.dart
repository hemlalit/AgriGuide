import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': LocaleData.q1.getString(context),
        'answer': LocaleData.a1.getString(context)
      },
      {
        'question': LocaleData.q2.getString(context),
        'answer': LocaleData.a2.getString(context)
      },
      // Add more FAQs here
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.help.getString(context)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: LocaleData.search.getString(context),
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[800]!),
                  ),
                ),
                onChanged: (value) {
                  // Implement search functionality here
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: AppColors.primaryColor, width: 1),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: AnimatedExpansionTile(
                        leading: const Icon(Icons.question_answer, color: Colors.green),
                        title: Text(
                          faqs[index]['question']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[50], // Subtle background color
                            ),
                            child: Text(
                              faqs[index]['answer']!,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.black87,
                              ),
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
      ),
    );
  }
}

class AnimatedExpansionTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> children;
  final Color? backgroundColor;

  const AnimatedExpansionTile({
    required this.leading,
    required this.title,
    required this.children,
    this.backgroundColor,
    super.key,
  });

  @override
  _AnimatedExpansionTileState createState() => _AnimatedExpansionTileState();
}

class _AnimatedExpansionTileState extends State<AnimatedExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconTurns = _controller.drive(Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).chain(CurveTween(curve: Curves.easeInOut)));
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: widget.leading,
          title: widget.title,
          trailing: RotationTransition(
            turns: _iconTurns,
            child: Icon(
              Icons.expand_more,
              color: Colors.green[800],
            ),
          ),
          onTap: _handleTap,
        ),
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: Container(
              color: widget.backgroundColor,
              child: Column(children: widget.children),
            ),
          ),
        ),
      ],
    );
  }
}
