String removeSymbols(String input) {
  return input.replaceAll(RegExp(r'\W'), '');
}

String convertDate(String? date) {
  if (date == null || date.isEmpty) return '';

  if (date.contains('-')) {
    date = date.replaceAll('-', '/');
    return '${date.split('/')[2]}/${date.split('/')[1]}/${date.split('/')[0]}';
  } else {
    date = date.replaceAll('/', '-');
    return '${date.split('-')[2]}-${date.split('-')[1]}-${date.split('-')[0]}';
  }
}

String formatCurrency(String value) {
  value = value.replaceAll(RegExp(r'\D'), '');
  List<String> valueChars = value.split('');
  if (value.trim().length > 2) {
    valueChars.insert(value.trim().length - 2, ',');
  }
  value = valueChars.join('');
  return value;
}
