import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_service/presentation/resubmit/recomplain_state_cubit.dart';


import '../../data/model/complain/complain_req_params/recomplain_post_req.dart';
import '../../data/model/user/user_info_model.dart';
import '../../domain/entities/complain_entity.dart';

import '../create_complain/bloc/complain_state.dart';


import '../widgets/complain_form/image_selector.dart';
import '../widgets/complain_form/multiline_text_input.dart';
import '../dashboard/bloc/user_info_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ResubmitFormScreen extends StatefulWidget {
  final ComplainEntity complaint;

  const ResubmitFormScreen({super.key, required this.complaint});

  @override
  State<ResubmitFormScreen> createState() => _ResubmitFormScreenState();
}

class _ResubmitFormScreenState extends State<ResubmitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final int _maxImages = 15;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleImageAdded(XFile image) {
    setState(() => _selectedImages.add(image));
  }

  void _handleImageRemoved(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _handleClearImages() {
    setState(() => _selectedImages.clear());
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide your feedback'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    _submitForm(context);
  }

  Future<void> _submitForm(BuildContext context) async {
    // No need to check user info since we're just using the complaint ID and feedback
    try {
      print('Resubmitting complaint ID: ${widget.complaint.complainID}');

      // Create ReComplain params instead of a new complaint
      final reComplainParams = ReComplainParams(
        complainID: widget.complaint.complainID,
        feedback: _feedbackController.text.trim(),
        images: _selectedImages.isNotEmpty
            ? _selectedImages.map((e) => File(e.path)).toList()
            : null,
      );

      // Use the ReComplainCubit to submit the request
      context.read<ReComplainCubit>().submitReComplain(reComplainParams);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo()),
        BlocProvider(create: (context) => ReComplainCubit()), // Changed to ReComplainCubit
      ],
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          title: Text(
            'Resubmit Complaint',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'Segment:',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.complaint.segmentName ?? 'N/A',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Original Comment:',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.complaint.complainName ?? 'N/A',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                MultilineTextField(
                  label: "Your Feedback",
                  controller: _feedbackController,
                  validator: (value) => value?.isEmpty ?? true ? "Feedback is required" : null,
                  helperText: 'Mention what was missing or unclear in your last complaint',
                ),
                const SizedBox(height: 24),
                ImagePickerWidget(
                  selectedImages: _selectedImages,
                  maxImages: _maxImages,
                  onImageAdded: _handleImageAdded,
                  onImageRemoved: _handleImageRemoved,
                  onClearImages: _handleClearImages,
                ),
                const SizedBox(height: 24),
                BlocConsumer<ReComplainCubit, ComplainState>( // Changed to ReComplainCubit
                  listener: (context, state) {
                    if (state is ComplainSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Resubmitted successfully'),
                          backgroundColor: colorScheme.tertiary, // Use tertiary for success
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/complain-list-screen');
                    } else if (state is ComplainError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Resubmission failed: ${state.message}'),
                          backgroundColor: colorScheme.error,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SubmitButton(
                      onPressed: () => _handleSubmit(context),
                      isLoading: state is ComplainLoading,
                      buttonText: "SUBMIT FEEDBACK",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SubmitButton widget unchanged
class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String buttonText;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurfaceVariant,
      ),
      child: isLoading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: colorScheme.onPrimary,
          strokeWidth: 2.0,
        ),
      )
          : Text(
        buttonText,
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}