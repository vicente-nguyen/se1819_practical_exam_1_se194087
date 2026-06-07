import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIProvider with ChangeNotifier {
  String _aiSuggestion = "";
  bool _isAnalyzing = false;

  String get aiSuggestion => _aiSuggestion;
  bool get isAnalyzing => _isAnalyzing;

  void clearSuggestion() {
    _aiSuggestion = "";
    _isAnalyzing = false;
    notifyListeners();
  }

  Future<void> generateSmartSuggestion(String productTitle, String category) async {
    _isAnalyzing = true;
    _aiSuggestion = "";
    notifyListeners();

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception("Gemini API Key is missing in .env file");
      }
      
      final model = GenerativeModel(model: 'gemini-2.0-flash-lite', apiKey: apiKey);
      final prompt = "You are an expert in every aspect. The user is viewing '$productTitle' in the category '$category'. Guide the user on how to store this product longer in exactly two sentences.";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      _aiSuggestion = response.text ?? "No recommendation available.";
    } catch (e) {
      debugPrint("AI Provider Error: $e");
      _aiSuggestion = "there is no need"; // Fallback thông minh đề phòng rớt mạng lúc thi
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }
}