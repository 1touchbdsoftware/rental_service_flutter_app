import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A reusable dropdown field for selecting items from a list
class GenericDropdown<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<T> items;
  final String Function(T) getLabel;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final IconData prefixIcon;
  final String hintText;
  final bool isLoading;
  final String emptyListMessage;

  const GenericDropdown({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.getLabel,
    this.onChanged,
    this.validator,
    this.prefixIcon = Icons.category,
    this.hintText = "Select an option",
    this.isLoading = false,
    this.emptyListMessage = "No options available",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            DropdownButtonFormField<T>(
              value: selectedValue,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  prefixIcon,
                  color: Colors.black87,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.black54,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(getLabel(item)),
                );
              }).toList(),
              onChanged: onChanged,
              validator: validator,
            ),
            if (items.isEmpty && !isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  child: Center(
                    child: Text(
                      emptyListMessage,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
