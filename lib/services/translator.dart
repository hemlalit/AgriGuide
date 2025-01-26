import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(String? text, String fromLanguage, String? toLanguage) async {
    final translation = await _translator.translate(
      text!,
      from: fromLanguage,
      to: toLanguage!,
    );
    return translation.text;
  }
}
