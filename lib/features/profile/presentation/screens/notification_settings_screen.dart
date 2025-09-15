import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      appBar: const UnifiedProfileAppBar(
        title: 'Notification Settings',
        showActionButton: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            _NotificationToggleTile(
              title: 'Allow Notifications',
              description:
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
              initialValue: true,
              onChanged: (value) {
                
              },
            ),
            SizedBox(height: 18.h),
            _NotificationToggleTile(
              title: 'Email Notifications',
              description:
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
              initialValue: false,
              onChanged: (value) {
                
              },
            ),
            SizedBox(height: 15.h),
            _NotificationToggleTile(
              title: 'Order Notifications',
              description:
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
              initialValue: false,
              onChanged: (value) {
                
              },
            ),
            SizedBox(height: 15.h),
            _NotificationToggleTile(
              title: 'General Notifications',
              description:
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
              initialValue: true,
              onChanged: (value) {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationToggleTile extends StatefulWidget {
  final String title;
  final String description;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleTile({
    required this.title,
    required this.description,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _NotificationToggleTileState createState() => _NotificationToggleTileState();
}

class _NotificationToggleTileState extends State<_NotificationToggleTile> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.eggshellWhite),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Transform.scale(
                  scale: 0.6,
                  child: Switch(
                    value: _isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                      });
                      widget.onChanged(value);
                    },
                    activeThumbColor: AppColors.grocery,
                    inactiveThumbColor: AppColors.featherGrey,
                    inactiveTrackColor: AppColors.homeGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              widget.description,
              style: getTextStyle(font: CustomFonts.inter),
            ),
          ],
        ),
      ),
    );
  }
}
