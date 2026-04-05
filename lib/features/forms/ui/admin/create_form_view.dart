import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cu_plus_webapp/core/network/api_client.dart';
import 'package:cu_plus_webapp/features/forms/api/forms_api.dart';

class CreateFormView extends StatefulWidget {
  const CreateFormView({super.key});

  @override
  State<CreateFormView> createState() => _CreateFormViewState();
}

class _CreateFormViewState extends State<CreateFormView> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController(
    text: "1st Year - Mid-Semester Grade Check - Fall",
  );
  final _descriptionCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController(
    text:
        "Please submit a Mid-Semester Grade Check form along with a copy of your class schedule. If you were unable to obtain signatures on your form verifying your grades please also submit an email from your instructor/professor verifying your grade.",
  );

  String? _year = "1";
  DateTime? _dueDate = DateTime(2025, 10, 20, 23, 49);

  bool _loading = false;
  String? _error;

  final List<Map<String, dynamic>> _fields = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  void _addFieldOfType(String type) {
    setState(() {
      _fields.add({
        "label": _defaultLabelForType(type),
        "type": type,
        "required": false,
        "placeholder": _defaultPlaceholderForType(type),
        "helpText": "",
        "sortOrder": _fields.length,
        "configJson": null,
      });
    });
  }

  String _defaultLabelForType(String type) {
    switch (type) {
      case "text":
        return "Text Field";
      case "checkbox":
        return "Check Box";
      case "date":
        return "Date";
      case "year":
        return "Year";
      case "signature":
        return "Signature";
      case "textarea":
        return "Text Area";
      default:
        return "Field";
    }
  }

  String _defaultPlaceholderForType(String type) {
    switch (type) {
      case "text":
        return "Enter text";
      case "textarea":
        return "Enter details";
      case "date":
        return "Select date";
      case "year":
        return "Select year";
      case "signature":
        return "Signature";
      default:
        return "";
    }
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
      for (int i = 0; i < _fields.length; i++) {
        _fields[i]["sortOrder"] = i;
      }
    });
  }

  void _updateField(int index, Map<String, dynamic> updatedField) {
    setState(() {
      _fields[index] = updatedField;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final hasEmptyFieldLabel = _fields.any(
      (field) => (field["label"] ?? "").toString().trim().isEmpty,
    );

    if (hasEmptyFieldLabel) {
      setState(() {
        _error = "Every field must have a label";
      });
      return;
    }

    if (_fields.isEmpty) {
      setState(() {
        _error = "Add at least one field";
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = FormsApi(context.read<ApiClient>());

      await api.createForm(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        year: _year,
        dueDate: _dueDate?.toIso8601String(),
        instructions: _instructionsCtrl.text.trim().isEmpty
            ? null
            : _instructionsCtrl.text.trim(),
        fields: _fields,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form created successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  String _formattedDueDate() {
    if (_dueDate == null) return "No due date";
    final d = _dueDate!;
    return "${d.month}/${d.day}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Customizing",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleCtrl,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? "Title is required"
                                : null,
                      ),

                      const SizedBox(height: 4),
                      Text(
                        "Due: ${_formattedDueDate()}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 14),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 20),

                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _topMetaSection(),
                                    const SizedBox(height: 20),
                                    _builderCanvas(),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 28),

                            _addInputPanel(),
                          ],
                        ),
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: _loading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _loading ? null : _saveForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(_loading ? "Saving..." : "Save"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topMetaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Name",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleCtrl,
          decoration: _inputDecoration(),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? "Title is required" : null,
        ),
        const SizedBox(height: 16),

        const Text(
          "Due Date",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 140,
              child: TextFormField(
                readOnly: true,
                onTap: _pickDueDate,
                decoration: _inputDecoration(
                  hintText: _dueDate == null
                      ? "mm/dd/yyyy"
                      : _formattedDueDate(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 110,
              child: TextFormField(
                readOnly: true,
                decoration: _inputDecoration(hintText: "00 : 00"),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                "AM : PM : No set date",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          "Assignment Details",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _instructionsCtrl,
          maxLines: 6,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _builderCanvas() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _fields.isEmpty
          ? Center(
              child: Text(
                "Empty",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : Column(
              children: List.generate(_fields.length, (index) {
                final field = _fields[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BuilderFieldTile(
                    field: field,
                    onChanged: (updated) => _updateField(index, updated),
                    onRemove: () => _removeField(index),
                  ),
                );
              }),
            ),
    );
  }

  Widget _addInputPanel() {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add input",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Icon(Icons.add_circle_outline, size: 20),
              ],
            ),
          ),
          _InputTypeButton(
            icon: Icons.text_snippet_outlined,
            label: "Text Field",
            onTap: () => _addFieldOfType("text"),
          ),
          _InputTypeButton(
            icon: Icons.check_box_outlined,
            label: "Check Box",
            onTap: () => _addFieldOfType("checkbox"),
          ),
          _InputTypeButton(
            icon: Icons.calendar_today_outlined,
            label: "Date",
            onTap: () => _addFieldOfType("date"),
          ),
          _InputTypeButton(
            icon: Icons.event_note_outlined,
            label: "Year",
            onTap: () => _addFieldOfType("year"),
          ),
          _InputTypeButton(
            icon: Icons.draw_outlined,
            label: "Signature",
            onTap: () => _addFieldOfType("signature"),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
    );
  }
}

class _BuilderFieldTile extends StatelessWidget {
  const _BuilderFieldTile({
    required this.field,
    required this.onChanged,
    required this.onRemove,
  });

  final Map<String, dynamic> field;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final type = field["type"]?.toString() ?? "text";
    final label = field["label"]?.toString() ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2A89D8), width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            child: Center(
              child: Text(
                ":",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: TextFormField(
              initialValue: label,
              onChanged: (value) {
                onChanged({...field, "label": value});
              },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade300,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                hintText: _hintForType(type),
              ),
            ),
          ),

          const SizedBox(width: 8),

          PopupMenuButton<String>(
            tooltip: "Field Type",
            onSelected: (value) {
              onChanged({
                ...field,
                "type": value,
                "placeholder": _defaultPlaceholderForPopup(value),
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: "text", child: Text("Text Field")),
              PopupMenuItem(value: "checkbox", child: Text("Check Box")),
              PopupMenuItem(value: "date", child: Text("Date")),
              PopupMenuItem(value: "year", child: Text("Year")),
              PopupMenuItem(value: "signature", child: Text("Signature")),
            ],
            child: Icon(Icons.tune, size: 18, color: Colors.grey.shade700),
          ),

          const SizedBox(width: 4),

          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, color: Colors.red),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }

  static String _hintForType(String type) {
    switch (type) {
      case "checkbox":
        return "Check Box";
      case "date":
        return "Date";
      case "year":
        return "Year";
      case "signature":
        return "Signature";
      default:
        return "Text Field";
    }
  }

  static String _defaultPlaceholderForPopup(String type) {
    switch (type) {
      case "text":
        return "Enter text";
      case "checkbox":
        return "";
      case "date":
        return "Select date";
      case "year":
        return "Select year";
      case "signature":
        return "Signature";
      default:
        return "";
    }
  }
}

class _InputTypeButton extends StatelessWidget {
  const _InputTypeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}