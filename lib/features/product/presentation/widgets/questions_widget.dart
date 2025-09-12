import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../data/models/question_model.dart';
import '../../controllers/product_controller.dart';

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
    final controller = Get.find<ProductController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          'Question & Answer',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.h),

        
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.homeGrey,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Have a question about this product?',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: controller.questionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Ask your question here...",
                  hintStyle: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    color: AppColors.featherGrey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(12.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
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
                    'Post Question',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        
        Obx(
          () => controller.questions.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Questions & Answers (${controller.questions.length})',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ...controller.questions.map(
                      (question) => _buildQuestionCard(question),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: Text(
                      'No questions yet. Be the first to ask!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
        ),
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
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                color: AppColors.ebonyBlack,
              ),
            ),

            
            if (question.answer.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.homeGrey,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Answer:',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      question.answer,
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 14.sp,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 8.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (question.answer.isEmpty)
                  Text(
                    'Waiting for answer...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Text(
                    'Answered',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 12.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (question.answer.isEmpty)
                  GestureDetector(
                    onTap: () => onReply(question),
                    child: Text(
                      'Reply',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        color: AppColors.ebonyBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
