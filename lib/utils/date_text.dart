/// Tarihi "Oct 28, 2024" biçiminde yazar (ek paket kullanmadan).
class DateText {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String format(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
