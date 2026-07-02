import 'package:flutter/material.dart';

class DynamicFormBuilder extends StatefulWidget {
  final Map<String, dynamic> schema; 
  final Function(String key, dynamic value) onFieldChanged;
  final Map<String, dynamic> initialData;

  const DynamicFormBuilder({
    super.key,
    required this.schema,
    required this.onFieldChanged,
    this.initialData = const {},
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  final Map<String, dynamic> _values = {};

  @override
  void initState() {
    super.initState();
    _values.addAll(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.schema['fields'] as List<dynamic>? ?? [];
    final sections = widget.schema['sections'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fields.map((field) => _buildField(field as Map<String, dynamic>)),
        ...sections.map((section) => _buildSectionList(section as Map<String, dynamic>)),
      ],
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    final key = field['key'] as String;
    final type = field['type'] as String;
    final label = field['label'] as String;

    switch (type) {
      case 'radio':
        return _buildRadioGroup(key, label, List<String>.from(field['options']));
      case 'date':
        return _buildDatePicker(key, label);
      case 'time':
        return _buildTimePicker(key, label);
      case 'number':
        return _buildCounter(key, label);
      case 'minister_select':
      case 'member_select':
        return _buildDropdown(key, label);
      default:
        return _buildTextField(key, label);
    }
  }

  Widget _buildRadioGroup(String key, String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
          const SizedBox(height: 8),
          RadioGroup<String>(
            groupValue: _values[key],
            onChanged: (val) {
              setState(() => _values[key] = val);
              widget.onFieldChanged(key, val);
            },
            child: Wrap(
              spacing: 16,
              children: options
                  .map((opt) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(value: opt),
                          Text(opt),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String key, String label) {
    int val = _values[key] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
                if (val > 0) { val--; setState(() => _values[key] = val); widget.onFieldChanged(key, val); }
              }),
              Text('$val', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {
                val++; setState(() => _values[key] = val); widget.onFieldChanged(key, val);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: (val) { _values[key] = val; widget.onFieldChanged(key, val); },
      ),
    );
  }

  Widget _buildDropdown(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: const [
          DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
          DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
        ],
        onChanged: (val) { _values[key] = val; widget.onFieldChanged(key, val); },
      ),
    );
  }

  Widget _buildDatePicker(String key, String label) {
    return ListTile(
      title: Text('$label: ${_values[key] ?? 'Sélectionner'}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
        
        if (!mounted) return;

        if (date != null) { 
          final formatted = '${date.day}/${date.month}/${date.year}';
          setState(() => _values[key] = formatted); 
          widget.onFieldChanged(key, formatted); 
        }
      },
    );
  }

  Widget _buildTimePicker(String key, String label) {
    return ListTile(
      title: Text('$label: ${_values[key] ?? '--:--'}'),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        
        if (!mounted) return;

        if (time != null) { 
          final formatted = time.format(context);
          setState(() => _values[key] = formatted); 
          widget.onFieldChanged(key, formatted); 
        }
      },
    );
  }

  Widget _buildSectionList(Map<String, dynamic> section) {
    final count = section['count'] as int? ?? 1;
    final title = section['title'] as String;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const Divider(),
            ...List.generate(count, (index) => TextField(
              decoration: InputDecoration(labelText: '${index + 1}.', border: InputBorder.none),
              onChanged: (val) => widget.onFieldChanged('${title}_$index', val),
            )),
          ],
        ),
      ),
    );
  }
}

