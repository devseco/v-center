class TestItem {
  String label;
  int value;
  TestItem({
    required this.label,
    required this.value
  });
  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(
        label: json['label'],
        value: json['value']
    );
  }
}