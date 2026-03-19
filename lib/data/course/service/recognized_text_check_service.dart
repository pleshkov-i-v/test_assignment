import 'package:test_case/domain/model/language_entity.dart';
import 'package:test_case/domain/service/i_recognized_text_check_service.dart';

class RecognizedTextCheckService implements IRecognizedTextCheckService {
  static final Map<LanguageEntity, RegExp> _languageRegex = {
    LanguageEntity.spanish: RegExp(r'[a-zA-Záéíóúüñ]'),
    LanguageEntity.english: RegExp(r'[a-zA-Z]'),
    LanguageEntity.russian: RegExp(r'[а-яА-Я]'),
  };

  @override
  bool isExpectedPhrase(
    LanguageEntity language,
    String expectedText,
    String recognizedText,
  ) {
    final String normalizedExpected = _normalizeLettersOnly(
      language,
      expectedText,
    );
    final String normalizedRecognized = _normalizeLettersOnly(
      language,
      recognizedText,
    );
    return normalizedRecognized.isNotEmpty &&
        normalizedExpected == normalizedRecognized;
  }

  String _normalizeLettersOnly(LanguageEntity language, String value) {
    // Keep only letters and lowercase them
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      final String ch = value[i];
      if (_languageRegex[language]?.hasMatch(ch) ?? false) {
        buffer.write(ch.toLowerCase());
      }
    }
    return buffer.toString();
  }
}
