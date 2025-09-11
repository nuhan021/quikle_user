import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class SearchBar extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onVoiceTap;

  const SearchBar({super.key, required this.onTap, this.onVoiceTap});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late Timer _placeholderTimer;
  String _currentKeyword = "biryani";

  final List<String> _placeholderItems = [
    'biryani',
    'pizza',
    'burger',
    'ice cream',
    'pasta',
    'sushi',
    'tacos',
    'noodles',
    'sandwich',
    'salad',
    'coffee',
    'juice',
    'medicine',
    'vitamins',
    'groceries',
    'milk',
    'bread',
    'fruits',
    'vegetables',
    'snacks',
  ];

  @override
  void initState() {
    super.initState();
    _startPlaceholderRotation();
  }

  @override
  void dispose() {
    _placeholderTimer.cancel();
    super.dispose();
  }

  void _startPlaceholderRotation() {
    _placeholderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          final randomIndex = Random().nextInt(_placeholderItems.length);
          _currentKeyword = _placeholderItems[randomIndex];
        });
      }
    });
  }

  String _getCurrentKeyword() {
    return _currentKeyword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Search for '",
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: Text(
                      _getCurrentKeyword(),
                      key: ValueKey(_getCurrentKeyword()),
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    "'",
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onVoiceTap ?? widget.onTap,
                child: Image.asset(ImagePath.voiceIcon, height: 24, width: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
