import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cu_plus_webapp/core/network/api_client.dart';
import 'package:cu_plus_webapp/features/forms/api/forms_api.dart';

class StudentFormFillView extends StatefulWidget {
  const StudentFormFillView({super.key, required this.formId});

  final String formId;

  @override
  State<StudentFormFillView> createState() => _StudentFormFillViewState();
}

class _StudentFormFillViewState extends State<StudentFormFillView> {
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  Map<String, dynamic>? _form;
  List<dynamic> _fields = [];

  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, Set<String>> _checkboxValues = {};
  final Map<String, DateTime?> _dateValues = {};
  final Map<String, TextEditingController> _yearControllers = {};
  final Map<String, String?> _signatureValues = {};

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    for (final controller in _yearControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadForm() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = FormsApi(context.read<ApiClient>());
      final form = await api.getStudentFormById(widget.formId);
      final fields = (form['fields'] as List?) ?? [];

      _form = form;
      _fields = fields;

      for (final rawField in _fields) {
        final field = Map<String, dynamic>.from(rawField);
        final fieldId = field['id'].toString();
        final type = field['type'].toString();

        if (type == 'text' || type == 'textarea' || type == 'signature') {
          _textControllers[fieldId] = TextEditingController();
        }

        if (type == 'checkbox') {
          _checkboxValues[fieldId] = <String>{};
        }

        if (type == 'date') {
          _dateValues[fieldId] = null;
        }

        if (type == 'year') {
          _yearControllers[fieldId] = TextEditingController();
        }

        if (type == 'signature') {
          _signatureValues[fieldId] = null;
        }
      }

      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _pickDate(String fieldId) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateValues[fieldId] ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateValues[fieldId] = picked;
      });
    }
  }

  String _yearPlaceholder(Map<String, dynamic> field) {
    final config = field['configJson'];
    if (config is Map && config['yearPlaceholder'] != null) {
      return config['yearPlaceholder'].toString();
    }
    return 'YYYY';
  }

  List<String> _checkboxOptions(Map<String, dynamic> field) {
    final config = field['configJson'];
    if (config is Map && config['options'] is List) {
      return (config['options'] as List)
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }

    return ['Option 1'];
  }

  String _datePlaceholder(Map<String, dynamic> field) {
    final config = field['configJson'];
    if (config is Map && config['datePlaceholder'] != null) {
      return config['datePlaceholder'].toString();
    }
    return 'MM/DD/YYYY';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.day}/${date.year}';
  }

  bool _validateRequiredFields() {
    for (final rawField in _fields) {
      final field = Map<String, dynamic>.from(rawField);
      final fieldId = field['id'].toString();
      final type = field['type'].toString();
      final required = field['required'] == true;
      if (!required) continue;

      switch (type) {
        case 'text':
        case 'textarea':
          final value = _textControllers[fieldId]?.text.trim() ?? '';
          if (value.isEmpty) return false;
          break;
        case 'checkbox':
          final values = _checkboxValues[fieldId] ?? {};
          if (values.isEmpty) return false;
          break;
        case 'date':
          if (_dateValues[fieldId] == null) return false;
          break;
        case 'year':
          final value = _yearControllers[fieldId]?.text.trim() ?? '';
          if (value.isEmpty) return false;
          break;
        case 'signature':
          final value = _textControllers[fieldId]?.text.trim() ?? '';
          if (value.isEmpty) return false;
          break;
      }
    }

    return true;
  }

  List<Map<String, dynamic>> _buildAnswersPayload() {
    final List<Map<String, dynamic>> answers = [];

    for (final rawField in _fields) {
      final field = Map<String, dynamic>.from(rawField);
      final fieldId = field['id'].toString();
      final type = field['type'].toString();

      switch (type) {
        case 'text':
        case 'textarea':
          answers.add({
            'formFieldId': fieldId,
            'valueText': _textControllers[fieldId]?.text.trim(),
          });
          break;

        case 'checkbox':
          answers.add({
            'formFieldId': fieldId,
            'valueText': (_checkboxValues[fieldId] ?? {}).join(','),
          });
          break;

        case 'date':
          answers.add({
            'formFieldId': fieldId,
            'valueDate': _dateValues[fieldId]?.toIso8601String(),
          });
          break;

        case 'year':
          answers.add({
            'formFieldId': fieldId,
            'valueText': _yearControllers[fieldId]?.text.trim(),
          });
          break;

        case 'signature':
          answers.add({
            'formFieldId': fieldId,
            'valueSignatureUrl': _textControllers[fieldId]?.text.trim(),
          });
          break;
      }
    }

    return answers;
  }

  Future<void> _submitForm() async {
    if (!_validateRequiredFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final api = FormsApi(context.read<ApiClient>());
      await api.submitStudentForm(
        formId: widget.formId,
        answers: _buildAnswersPayload(),
        submitNow: true,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    String? hintText,
    Color fillColor = const Color(0xFFF3F3F3),
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    final fieldId = field['id'].toString();
    final type = field['type'].toString();
    final label = (field['label'] ?? '').toString();
    final required = field['required'] == true;
    final placeholder = (field['placeholder'] ?? '').toString();

    final labelText = required ? '$label *' : label;

    switch (type) {
      case 'text':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              if (labelText.trim().isNotEmpty)
                Text(
                  labelText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              SizedBox(
                width: 220,
                child: TextFormField(
                  controller: _textControllers[fieldId],
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: _inputDecoration(
                    hintText: placeholder.isEmpty
                        ? 'Enter short text'
                        : placeholder,
                    fillColor: Colors.white,
                  ).copyWith(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 'textarea':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              TextFormField(
                controller: _textControllers[fieldId],
                minLines: 5,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: _inputDecoration(
                  hintText: placeholder.isEmpty
                      ? 'Enter description'
                      : placeholder,
                  fillColor: Colors.white,
                ).copyWith(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        );

      case 'checkbox':
        final options = _checkboxOptions(field);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 18,
            runSpacing: 8,
            children: [
              if (labelText.trim().isNotEmpty)
                Text(
                  labelText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ...options.map((option) {
                final selected = _checkboxValues[fieldId]?.contains(option) ?? false;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: selected,
                      onChanged: (value) {
                        setState(() {
                          final set = _checkboxValues[fieldId] ?? <String>{};
                          if (value == true) {
                            set.add(option);
                          } else {
                            set.remove(option);
                          }
                          _checkboxValues[fieldId] = set;
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    Text(option, style: const TextStyle(fontSize: 14)),
                  ],
                );
              }),
            ],
          ),
        );

      case 'date':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              if (labelText.trim().isNotEmpty)
                Text(
                  labelText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              InkWell(
                onTap: () => _pickDate(fieldId),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _dateValues[fieldId] == null
                            ? _datePlaceholder(field)
                            : _formatDate(_dateValues[fieldId]),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case 'year':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 8,
            children: [
              if (labelText.trim().isNotEmpty)
                Text(
                  labelText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _yearControllers[fieldId],
                  decoration:
                      _inputDecoration(
                        hintText: _yearPlaceholder(field),
                        fillColor: Colors.white,
                      ).copyWith(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                ),
              ),
            ],
          ),
        );

      case 'signature':
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.draw_outlined,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Container(
                        height: 1,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 0,
                      child: Text(
                        'Sign here',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _textControllers[fieldId],
                decoration: _inputDecoration(
                  hintText: placeholder.isEmpty
                      ? 'Paste signature image URL for now'
                      : placeholder,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Temporary version: use a URL until drawing/upload is added.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _loadForm,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final title = (_form?['title'] ?? 'Form').toString();
    final instructions = (_form?['instructions'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Fill Form')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListView(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (instructions.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  instructions,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ..._fields.map((rawField) {
                final field = Map<String, dynamic>.from(rawField);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildField(field),
                );
              }),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_submitting ? 'Submitting...' : 'Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
