import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/data/model/job.dart';
import '../../core/patterns/singleton/job_repository.dart';

class PostJobScreen extends StatefulWidget {
  final Job? job; // null = create, not null = edit

  const PostJobScreen({super.key, this.job});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final salaryController = TextEditingController();
  final requirementsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.job != null) {
      titleController.text = widget.job!.title;
      locationController.text = widget.job!.location;
      descriptionController.text = widget.job!.description;
      salaryController.text = widget.job!.salary;
      requirementsController.text = widget.job!.requirements;
    }
  }

  void submitJob() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.job == null) {
      JobRepository.instance.addJob(
        Job(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleController.text,
          description: descriptionController.text,
          location: locationController.text,
          salary: salaryController.text,
          requirements: requirementsController.text,
          status: 'open',
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully!")),
      );
    } else {
      final updatedJob = Job(
        id: widget.job!.id,
        title: titleController.text,
        description: descriptionController.text,
        location: locationController.text,
        salary: salaryController.text,
        requirements: requirementsController.text,
        status: widget.job!.status,
      );

      JobRepository.instance.updateJob(updatedJob);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job updated successfully!")),
      );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    salaryController.dispose();
    requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.job != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "Edit Job" : "Post Job",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 24),

                    // ✅ REQUIRED
                    _buildTextField(titleController, "Job Title"),
                    const SizedBox(height: 12),

                    // ⚪ OPTIONAL
                    _buildTextField(
                      descriptionController,
                      "Description",
                      maxLines: 3,
                      isRequired: false,
                    ),
                    const SizedBox(height: 12),

                    // ✅ REQUIRED
                    _buildTextField(locationController, "Location"),
                    const SizedBox(height: 12),

                    // ⚪ OPTIONAL (NUMBERS ONLY)
                    _buildTextField(
                      salaryController,
                      "Salary",
                      isNumeric: true,
                      isRequired: false,
                    ),
                    const SizedBox(height: 12),

                    // ✅ REQUIRED
                    _buildTextField(
                      requirementsController,
                      "Requirements",
                      hint: "e.g. Flutter, 2+ years experience",
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: submitJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEdit ? "Update Job" : "Post Job",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    int maxLines = 1,
    bool isNumeric = false,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType:
          isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: isRequired ? "$label *" : label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "Enter $label";
        }

        if (isNumeric && value != null && value.isNotEmpty) {
          if (!RegExp(r'^\d+$').hasMatch(value)) {
            return "$label must be numbers only";
          }
        }

        return null;
      },
    );
  }
}
