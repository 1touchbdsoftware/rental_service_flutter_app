// lib/utils/phone_utils.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for phone-related functionality
class PhoneUtils {
  /// Builds a row with a label and phone number that can be tapped to make a call
  ///
  /// Parameters:
  /// - [label]: Text label shown before the phone number
  /// - [phoneNumber]: The phone number to display and call
  /// - [context]: BuildContext for showing SnackBar on errors
  static Widget buildPhoneRow(String label, String phoneNumber, BuildContext context) {
    // Function to make a phone call
    Future<void> _makePhoneCall(String number) async {
      // Format the number properly by removing any spaces or special characters
      final cleanNumber = number.replaceAll(RegExp(r'\s+'), '');

      // Use 'tel:' scheme without any additional parameters
      final Uri launchUri = Uri.parse('tel:$cleanNumber');

      try {
        // Launch URL with mode that doesn't wait for the call to finish
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Show a snackbar if the call can't be initiated
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not initiate call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    final displayValue = phoneNumber.isEmpty ? 'N/A' : phoneNumber;
    final bool canCall = displayValue != 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 30),
          if (canCall)
            Expanded(
              child: InkWell(
                onTap: () => _makePhoneCall(phoneNumber),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayValue,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 30),
                    const Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  /// Makes a phone call to the given number
  ///
  /// Shows an error SnackBar if the call fails
  static Future<void> makePhoneCall(String phoneNumber, BuildContext context) async {
    // Format the number properly by removing any spaces or special characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');

    // Use 'tel:' scheme without any additional parameters
    final Uri launchUri = Uri.parse('tel:$cleanNumber');

    try {
      // Launch URL with mode that doesn't wait for the call to finish
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Show a snackbar if the call can't be initiated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not initiate call: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Builds a row with a label and email address that can be tapped to send an email
  ///
  /// Parameters:
  /// - [label]: Text label shown before the email address
  /// - [emailAddress]: The email address to display and use
  /// - [context]: BuildContext for showing SnackBar on errors
  static Widget buildEmailRow(String label, String emailAddress, BuildContext context) {
    // Function to send an email
    Future<void> _sendEmail(String email) async {
      // Format the email properly by removing any spaces
      final cleanEmail = email.trim();

      // Use 'mailto:' scheme
      final Uri launchUri = Uri.parse('mailto:$cleanEmail');

      try {
        // Launch email client
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // Show a snackbar if the email client can't be initiated
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email client: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    final displayValue = emailAddress.isEmpty ? 'N/A' : emailAddress;
    final bool canEmail = displayValue != 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 30),
          if (canEmail)
            Expanded(
              child: InkWell(
                onTap: () => _sendEmail(emailAddress),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        displayValue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.email,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );

  }



  /// Opens the email client with the given email address
  ///
  /// Shows an error SnackBar if the email client can't be opened
  static Future<void> sendEmail(String emailAddress, BuildContext context) async {
    // Format the email properly by removing any spaces
    final cleanEmail = emailAddress.trim();

    // Use 'mailto:' scheme
    final Uri launchUri = Uri.parse('mailto:$cleanEmail');

    try {
      // Launch email client
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Show a snackbar if the email client can't be initiated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open email client: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}