import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

/// "Admin: update data" form (wireframe 10) with Menu item / Timetable entry
/// tabs and a "Saved" panel that appears over the same form.
///
/// The Timetable entry fields are not specified in the Step 2.1 report; the
/// fields below are a proposal to confirm in design review.
class AdminUpdateScreen extends StatefulWidget {
  const AdminUpdateScreen({super.key});

  @override
  State<AdminUpdateScreen> createState() => _AdminUpdateScreenState();
}

class _AdminUpdateScreenState extends State<AdminUpdateScreen> {
  int _tab = 0;
  int _formGeneration = 0; // bumped to clear the forms ("Add another")
  String? _savedMessage;

  void _onSaved(String message) => setState(() => _savedMessage = message);

  void _addAnother() => setState(() {
    _savedMessage = null;
    _formGeneration++;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin: update data')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _Tabs(
                        selected: _tab,
                        onSelect: (i) => setState(() => _tab = i),
                      ),
                      const SizedBox(height: 16),
                      IndexedStack(
                        index: _tab,
                        children: [
                          _MenuItemForm(
                            key: ValueKey('menu$_formGeneration'),
                            onSaved: _onSaved,
                          ),
                          _TimetableForm(
                            key: ValueKey('time$_formGeneration'),
                            onSaved: _onSaved,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_savedMessage != null)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: _SavedPanel(
                        message: _savedMessage!,
                        onAddAnother: _addAnother,
                        onDone: () => Navigator.of(context).pop(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const labels = ['Menu item', 'Timetable entry'];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.highlight,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelect(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: i == selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: i == selected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SavedPanel extends StatelessWidget {
  const _SavedPanel({
    required this.message,
    required this.onAddAnother,
    required this.onDone,
  });

  final String message;
  final VoidCallback onAddAnother;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTheme.accent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Saved',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(message, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Add another',
                    onPressed: onAddAnother,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    label: 'Done',
                    color: AppTheme.primaryColor,
                    onPressed: onDone,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _decoration(String hint, {Widget? suffix}) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
  suffixIcon: suffix,
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppTheme.divider),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppTheme.divider),
  ),
  errorStyle: const TextStyle(color: Color(0xFFC62828), fontSize: 12),
);

String? _required(String? v) =>
    (v == null || v.trim().isEmpty) ? 'Required' : null;

String _fmtPrice(double p) =>
    p == p.roundToDouble() ? p.toStringAsFixed(0) : p.toStringAsFixed(2);

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

Widget _gap() => const SizedBox(height: 12);

class _MenuItemForm extends StatefulWidget {
  const _MenuItemForm({super.key, required this.onSaved});
  final ValueChanged<String> onSaved;

  @override
  State<_MenuItemForm> createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<_MenuItemForm> {
  static const _locations = ['Yemekhane', 'Küçükev', 'Piazza'];
  static const _categories = ['Soup', 'Main', 'Side', 'Dessert', 'Drink'];

  final _formKey = GlobalKey<FormState>();
  final _dateCtrl = TextEditingController();
  final _dish = TextEditingController();
  final _price = TextEditingController();
  String? _location;
  String? _category;
  DateTime? _date;

  @override
  void dispose() {
    _dateCtrl.dispose();
    _dish.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d != null) {
      _date = d;
      _dateCtrl.text = '${d.day} ${_months[d.month - 1]} ${d.year}';
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    widget.onSaved(
      '${_dish.text.trim()} (${_fmtPrice(price)} TL) was added to '
      '$_location for ${_date!.day} ${_months[_date!.month - 1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _location,
            isExpanded: true,
            decoration: _decoration('Location (Yemekhane / Küçükev / Piazza)'),
            items: [
              for (final l in _locations)
                DropdownMenuItem(value: l, child: Text(l)),
            ],
            onChanged: (v) => _location = v,
            validator: (v) => v == null ? 'Required' : null,
          ),
          _gap(),
          TextFormField(
            controller: _dateCtrl,
            readOnly: true,
            onTap: _pickDate,
            decoration: _decoration('Date (date picker)'),
            validator: _required,
          ),
          _gap(),
          TextFormField(
            controller: _dish,
            decoration: _decoration('Dish name'),
            validator: _required,
          ),
          _gap(),
          TextFormField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _decoration('Price (TL)'),
            validator: (v) {
              final p = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
              if (p == null || p < 0) return 'Must be a non-negative number';
              return null;
            },
          ),
          _gap(),
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            decoration: _decoration('Category'),
            items: [
              for (final c in _categories)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) => _category = v,
            validator: (v) => v == null ? 'Required' : null,
          ),
          _gap(),
          ActionButton(
            label: 'Save',
            color: AppTheme.primaryColor,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _TimetableForm extends StatefulWidget {
  const _TimetableForm({super.key, required this.onSaved});
  final ValueChanged<String> onSaved;

  @override
  State<_TimetableForm> createState() => _TimetableFormState();
}

class _TimetableFormState extends State<_TimetableForm> {
  static const _lines = ['Shuttle', 'KM18'];
  static const _origins = ['Sabancı', 'Kadıköy'];
  static const _dayTypes = ['Weekday', 'Weekend'];

  final _formKey = GlobalKey<FormState>();
  final _timeCtrl = TextEditingController();
  final _destination = TextEditingController();
  String? _line;
  String? _origin;
  String? _dayType;

  @override
  void dispose() {
    _timeCtrl.dispose();
    _destination.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      _timeCtrl.text =
          '${t.hour.toString().padLeft(2, '0')}:'
          '${t.minute.toString().padLeft(2, '0')}';
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSaved(
      '$_line $_origin → ${_destination.text.trim()} at '
      '${_timeCtrl.text} ($_dayType) was added.',
    );
  }

  Widget _dropdown(String hint, List<String> items, ValueChanged<String?> on) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _decoration(hint),
      items: [
        for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
      ],
      onChanged: on,
      validator: (v) => v == null ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _dropdown('Line (Shuttle / KM18)', _lines, (v) => _line = v),
          _gap(),
          _dropdown('Origin (Sabancı / Kadıköy)', _origins, (v) => _origin = v),
          _gap(),
          TextFormField(
            controller: _destination,
            decoration: _decoration('Destination'),
            validator: _required,
          ),
          _gap(),
          _dropdown(
            'Day type (Weekday / Weekend)',
            _dayTypes,
            (v) => _dayType = v,
          ),
          _gap(),
          TextFormField(
            controller: _timeCtrl,
            readOnly: true,
            onTap: _pickTime,
            decoration: _decoration('Departure time (time picker)'),
            validator: _required,
          ),
          _gap(),
          ActionButton(
            label: 'Save',
            color: AppTheme.primaryColor,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
