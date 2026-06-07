import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
      // ĐI THI: Thay bằng API Key Gemini thực tế của bạn hoặc lấy từ Env
      final model = GenerativeModel(model: 'gemini-2.5-flash-lite', apiKey: 'AIzaSyC5leLSHbsVpuQ9Sx4oQLLCHoDzYjTSOeQ');
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