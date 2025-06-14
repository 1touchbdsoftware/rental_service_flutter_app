// lib/core/localization/language_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void changeLanguage(String code) {
    emit(Locale(code)); // This emits a new state with updated locale
  }
}
