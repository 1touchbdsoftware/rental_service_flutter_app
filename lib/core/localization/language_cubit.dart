import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const String _languageKey = 'selected_language';

  LanguageCubit() : super(const Locale('en')) {
    _loadLanguage();
  }

  // Load saved language preference from SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey) ?? 'en'; // Default to 'en'
    emit(Locale(savedLanguageCode));
  }

  // Change language and persist the selection
  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code); // Save selected language code
    emit(Locale(code)); // Emit new language to update the app UI
  }
}
