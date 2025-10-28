import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rental_service/domain/usecases/is_loggedin_usecase.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/repository/auth.dart';
import '../../../service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  void appStarted() async {
    try {
      emit(AuthInitialState()); // Reset to initial state

      var isLoggedIn = await sl<IsLoggedinUsecase>().call();

      if (isLoggedIn) {
        // If user is logged in, validate the token
        await _validateTokenAndEmitState();
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthErrorState(message: "App startup error: $e"));
      emit(UnAuthenticated()); // Fallback to unauthenticated on error
    }
  }

  Future<void> _validateTokenAndEmitState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userName = prefs.getString('userName');

      if (token == null || userName == null) {
        print('Token or userName not found in SharedPreferences');
        emit(UnAuthenticated());
        return;
      }

      // Validate token with the API
      final result = await sl<AuthRepository>().validateToken(userName, token);

      result.fold(
            (failure) {
          print('Token validation API failed: $failure');
          // Token validation API call failed - try to refresh token
          _attemptTokenRefresh();
        },
            (validationData) {
          final isExpired = validationData['isExpired'] ?? true;
          final message = validationData['message'] ?? '';
          final isValid = validationData['isValid'] ?? false;

          print('Token validation result - isExpired: $isExpired, isValid: $isValid, message: $message');

          if (isExpired || !isValid) {
            // Token is expired or invalid, try to refresh
            _attemptTokenRefresh();
          } else {
            // Token is valid
            emit(Authenticated());
          }
        },
      );
    } catch (e) {
      print('Token validation error: $e');
      emit(AuthErrorState(message: "Token validation error: $e"));
      emit(UnAuthenticated());
    }
  }

  Future<void> _attemptTokenRefresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final refreshToken = prefs.getString('refreshToken');

      if (token == null || refreshToken == null) {
        print('Token or refreshToken not found for refresh');
        emit(UnAuthenticated());
        return;
      }

      print('Attempting token refresh...');
      final result = await sl<AuthRepository>().refreshToken(token, refreshToken);

      result.fold(
            (failure) {
          print('Token refresh failed: $failure');
          // Refresh failed - user needs to login again
          emit(AuthErrorState(message: "Session expired. Please login again."));
          emit(UnAuthenticated());
        },
            (tokenData) {
          final newAccessToken = tokenData['accessToken'];
          final newRefreshToken = tokenData['refreshToken'];
          final success = tokenData['success'] ?? false;

          if (success && newAccessToken != null && newRefreshToken != null) {
            print('Token refresh successful');
            // Save new tokens and emit authenticated state
            _saveNewTokens(tokenData);
            emit(Authenticated());
          } else {
            print('Token refresh returned invalid data');
            emit(AuthErrorState(message: "Failed to refresh session"));
            emit(UnAuthenticated());
          }
        },
      );
    } catch (e) {
      print('Token refresh error: $e');
      emit(AuthErrorState(message: "Session refresh error. Please login again."));
      emit(UnAuthenticated());
    }
  }

  Future<void> _saveNewTokens(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newAccessToken = data['accessToken'];
      final newRefreshToken = data['refreshToken'];

      if (newAccessToken != null && newAccessToken is String) {
        await prefs.setString('token', newAccessToken);
        print('New access token saved');
      }
      if (newRefreshToken != null && newRefreshToken is String) {
        await prefs.setString('refreshToken', newRefreshToken);
        print('New refresh token saved');
      }
    } catch (e) {
      print('Error saving new tokens: $e');
      // Don't emit error state here as this is a side effect
    }
  }

  Future<void> logOut({required LogoutUseCase usecase}) async {
    try {
      emit(AuthInitialState()); // Show loading state during logout

      final result = await usecase.call();
      result.fold(
            (failure) {
          emit(AuthErrorState(message: "Logout failed: $failure"));
          // Even if logout API fails, clear local tokens
          _clearTokens();
          emit(UnAuthenticated());
        },
            (success) {
          // Clear tokens on logout
          _clearTokens();
          emit(UnAuthenticated());
        },
      );
    } catch (e) {
      emit(AuthErrorState(message: "Logout error: $e"));
      // Ensure tokens are cleared even on error
      await _clearTokens();
      emit(UnAuthenticated());
    }
  }

  Future<void> _clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('refreshToken');
      await prefs.remove('userName');
      // You might want to clear other user-related data too
      print('All tokens cleared');
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  // Optional: Method to manually trigger token validation
  Future<void> validateCurrentToken() async {
    try {
      emit(AuthInitialState()); // Show loading state
      await _validateTokenAndEmitState();
    } catch (e) {
      emit(AuthErrorState(message: "Token validation error: $e"));
    }
  }

  // Optional: Method to manually trigger token refresh
  Future<void> refreshCurrentToken() async {
    try {
      emit(AuthInitialState()); // Show loading state
      await _attemptTokenRefresh();
    } catch (e) {
      emit(AuthErrorState(message: "Token refresh error: $e"));
    }
  }

  // Helper method to check if user is authenticated without emitting state
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}