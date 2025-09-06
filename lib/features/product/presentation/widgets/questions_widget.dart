import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';
import '../../data/models/question_model.dart';

class QuestionsWidget extends StatelessWidget {
  final List<QuestionModel> questions;
  final VoidCallback onAskQuestion;
  final Function(QuestionModel) onReply;

  const QuestionsWidget({
    super.key,
    required this.questions,
    required this.onAskQuestion,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'Question & Answer',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.h),

        // Input box to ask a question
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Ask your question here...",
            hintStyle: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 14.sp,
              color: AppColors.featherGrey,
            ),
            filled: true,
            fillColor: AppColors.homeGrey,
            contentPadding: EdgeInsets.all(12.w),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 48.h,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onAskQuestion,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Ask Question',
              style: getTextStyle(
                font: CustomFonts.manrope,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Questions list
        if (questions.isNotEmpty) ...[
          ...questions.map((question) => _buildQuestionCard(question)),
        ] else ...[
          Center(
            child: Text(
              'Ask anything about this product.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundImage: AssetImage(question.userImage),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        question.userName,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        question.timeAgo,
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 12.sp,
                          color: AppColors.featherGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            Text(
              question.question,
              style: getTextStyle(font: CustomFonts.inter),
            ),

            SizedBox(height: 8.h),

            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => onReply(question),
                child: Text(
                  'Reply',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
