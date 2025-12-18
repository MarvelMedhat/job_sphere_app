import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/model/job.dart';
import '../../core/patterns/singleton/job_repository.dart';
import '../../core/patterns/builder/job_builder.dart';
import '../../core/patterns/builder/job_director.dart';

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

    final builder = JobBuilder();
    final director = JobDirector(builder);

    final job = director.constructFullJob(
      id: widget.job?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      location: locationController.text,
      salary: salaryController.text,
      requirements: requirementsController.text,
      status: widget.job?.status ?? "open",
    );

    if (widget.job == null) {
      JobRepository.instance.addJob(job);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully")),
      );
    } else {
      JobRepository.instance.updateJob(job);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job updated successfully")),
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
                    const SizedBox(height: 20),

                    Text(
                      isEdit ? "Edit Job" : "Post Job",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildTextField(titleController, "Job Title"),
                    const SizedBox(height: 12),

                    _buildTextField(locationController, "Location"),
                    const SizedBox(height: 12),

                    _buildTextField(
                      descriptionController,
                      "Description",
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      salaryController,
                      "Salary",
                      isNumeric: true,
                      isRequired: false,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      requirementsController,
                      "Requirements",
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
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
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
    int maxLines = 1,
    bool isNumeric = false,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
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
        return null;
      },
    );
  }
}
