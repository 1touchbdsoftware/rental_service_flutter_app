import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_colors.dart';
import '../data/model/get_segment_params.dart';
import '../data/model/segment_model.dart';
import 'get_segment_state.dart';
import 'get_segment_state_cubit.dart';


class CreateComplainScreen extends StatelessWidget {
  const CreateComplainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetSegmentCubit(),
      child: const _CreateComplainScreenContent(),
    );
  }
}

class _CreateComplainScreenContent extends StatefulWidget {
  const _CreateComplainScreenContent();

  @override
  State<_CreateComplainScreenContent> createState() =>
      _CreateComplainScreenState();
}


class _CreateComplainScreenState extends State<_CreateComplainScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];
  final int _maxImages = 5;

  SegmentModel? _selectedSegment;

  @override
  void initState() {
    super.initState();
    _loadSegments();
  }

  Future<void> _loadSegments() async {
    final params = await _prepareSegmentParams();
    context.read<GetSegmentCubit>().fetchSegments(params: params);
  }

  Future<GetSegmentParams> _prepareSegmentParams() async {
    final prefs = await SharedPreferences.getInstance();
    return GetSegmentParams(
      agencyID: prefs.getString('agencyID') ?? '',
      landlordID: prefs.getString('landlordID') ?? '',
      propertyID: prefs.getString('propertyID') ?? '',
      segmentID: '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 images allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final pickedImages = await _imagePicker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 1000,
    );

    if (pickedImages.isNotEmpty) {
      setState(() {
        // Add only up to the maximum allowed
        final remainingSlots = _maxImages - _selectedImages.length;
        final imagesToAdd = pickedImages.length > remainingSlots
            ? pickedImages.sublist(0, remainingSlots)
            : pickedImages;

        _selectedImages.addAll(imagesToAdd);

        if (pickedImages.length > remainingSlots) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Only added ${imagesToAdd
                  .length} images. Maximum limit reached.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _clearImages() {
    setState(() {
      _selectedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Create Complaint'),
      ),
      body: BlocConsumer<GetSegmentCubit, GetSegmentState>(
        listener: (context, state) {
          if (state is GetSegmentFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is GetSegmentLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Segment Dropdown
                  _buildSegmentDropdown(state),
                  const SizedBox(height: 24),

                  // Comment Field
                  _buildCommentField(),
                  const SizedBox(height: 24),

                  // Image Picker
                  _buildImagePicker(),
                  const SizedBox(height: 32),

                  // Submit Button
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSegmentDropdown(GetSegmentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
      "Complaint Category",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    const SizedBox(height: 8),
    if (state is GetSegmentSuccessState)
    Stack(
    alignment: Alignment.center,
    children: [
    DropdownButtonFormField<SegmentModel>(
    value: _selectedSegment,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down),
    isExpanded: true,
    decoration: InputDecoration(
    prefixIcon: const Icon(Icons.category, color: Colors.black87), // Darker icon
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black54), // Darker border
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black54),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black),
    ),
    hintText: "Select a category",
    hintStyle: const TextStyle(color: Colors.black54), // Darker hint text
    ),
    items: state.response.data.map((segment) {
    return DropdownMenuItem(
    value: segment,
    child: Text(segment.text ?? "Unnamed Segment"),
    );
    }).toList(),
    onChanged: (value) => setState(() => _selectedSegment = value),
    validator: (value) => value == null ? "Please select a category" : null,
    ),
    if (state.response.data.isEmpty)
    Positioned.fill(
    child: Container(
    color: Colors.white.withValues(alpha: 70),
    child: const Center(
    child: Text(
    "No categories available",
    style: TextStyle(fontStyle: FontStyle.italic),
    ),
    ),
    ),
    ),
    ],
    )
    else if (state is! GetSegmentLoadingState)
    const Text(
    "Failed to load categories. Please try again.",
    style: TextStyle(color: Colors.red),
    )
    ,
    ]
    ,
    );
  }

  Widget _buildCommentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _commentController,
          maxLines: 5,
          decoration: InputDecoration(
    prefixIcon: const Padding(
    padding: EdgeInsets.only(bottom: 80),
    child: Icon(Icons.description, color: Colors.black87),
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black54),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black54),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black),
    ),
    hintText: "Please describe your complaint in detail...",
    hintStyle: const TextStyle(color: Colors.black54),
    contentPadding: const EdgeInsets.all(16),
    ),

    validator: (value) =>
          value?.isEmpty ?? true
              ? "Description is required"
              : null,
        ),
        const SizedBox(height: 8),
        const Text(
          'Be specific about the issue for faster resolution',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attach Images",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Image Grid
              if (_selectedImages.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImages[index].path),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                      Icons.error, color: Colors.red),
                                ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 12),

              // Add Image Button
              if (_selectedImages.length < _maxImages)
                InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 32),
                        SizedBox(height: 4),
                        Text('Add Photos'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedImages.length}/$_maxImages images',
              style: TextStyle(
                fontSize: 12,
                color: _selectedImages.length >= _maxImages
                    ? Colors.red
                    : Colors.black,
              ),
            ),
            if (_selectedImages.isNotEmpty)
              TextButton(
                onPressed: _clearImages,
                child: const Text('Clear all'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _submitComplaint();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.send),
          SizedBox(width: 8),
          Text("SUBMIT COMPLAINT"),
        ],
      ),
    );
  }

  void _submitComplaint() {
    // Display a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      // Close the loading dialog
      Navigator.of(context).pop();

      // Implement your complaint submission logic here
      debugPrint("Selected Segment: ${_selectedSegment?.id}");
      debugPrint("Comment: ${_commentController.text}");
      debugPrint("Images Count: ${_selectedImages.length}");

      // Here you would typically:
      // 1. Process the selected images
      // 2. Upload them to your server or convert to base64
      // 3. Send the data to your API

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}