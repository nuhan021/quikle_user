import 'package:get/get.dart';

class LanguageController extends GetxService {
  final languages = const [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
  ];

  final selectedLanguage = 'English'.obs;

  void setLanguage(String value) => selectedLanguage.value = value;
  String get current => selectedLanguage.value;
}
