import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const SearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Search for 'biryani'",
                style: getTextStyle(
                  font: CustomFonts.inter,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Image.asset(ImagePath.voiceIcon, height: 24, width: 24),
            ],
          ),
        ),
      ),
    );
  }
}
