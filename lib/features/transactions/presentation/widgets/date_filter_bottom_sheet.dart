import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilterBottomSheet extends StatefulWidget {
  final DateTimeRange? initialRange;
  final Function(DateTimeRange) onApply;

  const DateFilterBottomSheet({
    super.key,
    this.initialRange,
    required this.onApply,
  });

  @override
  State<DateFilterBottomSheet> createState() => _DateFilterBottomSheetState();
}

class _DateFilterBottomSheetState extends State<DateFilterBottomSheet> {
  late DateTimeRange _selectedRange;
  String _selectedPreset = 'Bulan Ini';

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange ?? _getThisMonthRange();
    _determinePreset();
  }

  void _determinePreset() {
    if (_isSameRange(_selectedRange, _getThisMonthRange())) {
      _selectedPreset = 'Bulan Ini';
    } else if (_isSameRange(_selectedRange, _getLast7DaysRange())) {
      _selectedPreset = '7 Hari Terakhir';
    } else if (_isSameRange(_selectedRange, _getLast30DaysRange())) {
      _selectedPreset = '30 Hari Terakhir';
    } else if (_isSameRange(_selectedRange, _getLastMonthRange())) {
      _selectedPreset = 'Bulan Lalu';
    } else {
      _selectedPreset = 'Custom';
    }
  }

  bool _isSameRange(DateTimeRange a, DateTimeRange b) {
    return a.start.year == b.start.year &&
        a.start.month == b.start.month &&
        a.start.day == b.start.day &&
        a.end.year == b.end.year &&
        a.end.month == b.end.month &&
        a.end.day == b.end.day;
  }

  DateTimeRange _getThisMonthRange() {
    final now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
  }

  DateTimeRange _getLast7DaysRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 6)),
      end: now,
    );
  }

  DateTimeRange _getLast30DaysRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 29)),
      end: now,
    );
  }

  DateTimeRange _getLastMonthRange() {
    final now = DateTime.now();
    final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final endOfLastMonth = DateTime(now.year, now.month, 0);
    return DateTimeRange(start: startOfLastMonth, end: endOfLastMonth);
  }

  void _pickCustomRange() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 300,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  final range = args.value as PickerDateRange;
                  if (range.startDate != null && range.endDate != null) {
                    setState(() {
                      _selectedRange = DateTimeRange(
                        start: range.startDate!,
                        end: range.endDate!,
                      );
                      _selectedPreset = 'Custom';
                    });
                  }
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                _selectedRange.start,
                _selectedRange.end,
              ),
              maxDate: DateTime.now(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Rentang Waktu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFilterChip('Bulan Ini', _getThisMonthRange()),
              _buildFilterChip('7 Hari Terakhir', _getLast7DaysRange()),
              _buildFilterChip('30 Hari Terakhir', _getLast30DaysRange()),
              _buildFilterChip('Bulan Lalu', _getLastMonthRange()),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickCustomRange,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedPreset == 'Custom'
                      ? Colors.green
                      : Colors.grey.shade300,
                  width: _selectedPreset == 'Custom' ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: _selectedPreset == 'Custom'
                    ? Colors.green.withValues(alpha: 0.05)
                    : Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: _selectedPreset == 'Custom'
                        ? Colors.green
                        : Colors.grey,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Pilih Tanggal Manual',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  if (_selectedPreset == 'Custom')
                    Text(
                      '${DateFormat('dd MMM').format(_selectedRange.start)} - ${DateFormat('dd MMM').format(_selectedRange.end)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final thisMonthRange = DateTimeRange(
                      start: DateTime(now.year, now.month, 1),
                      end: now,
                    );
                    widget.onApply(thisMonthRange);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selectedRange);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, DateTimeRange range) {
    final isSelected = _selectedPreset == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPreset = label;
            _selectedRange = range;
          });
        }
      },
      selectedColor: Colors.green.withValues(alpha: 0.2),
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
