import 'package:test_case/domain/model/language_entity.dart';

abstract interface class IRecognizedTextCheckService {
  bool isExpectedPhrase(
    LanguageEntity language,
    String expectedText,
    String recognizedText,
  );
}
