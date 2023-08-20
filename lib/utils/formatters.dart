String removeSymbols(String input) {
  return input.replaceAll(RegExp(r'\W'), '');
}

bool validateDate(String date) {
  if (date.contains('-')) date = convertDate(date);
  List<String> parts = date.split('/');

  return ![
    (int.parse(parts[0]) > 0 && int.parse(parts[0]) <= 31),
    (int.parse(parts[1]) > 0 && int.parse(parts[1]) <= 12),
    (int.parse(parts[2]) > 1800 && int.parse(parts[2]) <= DateTime.now().year),
  ].contains(false);
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

bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w+.]+@\w+\.\w{2,}(?:\.\w{2})?$');
  return regex.hasMatch(email);
}

bool validateCPF(String cpf) {
  // Remove os caracteres não numéricos do CPF
  cpf = cpf.replaceAll(RegExp(r'\D'), '');

  // Verifica se o CPF tem 11 dígitos
  if (cpf.length != 11) {
    return false;
  }

  // Verifica se todos os dígitos são iguais (CPF inválido)
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
    return false;
  }

  // Calcula o primeiro dígito verificador
  int soma = 0;
  for (int i = 0; i < 9; i++) {
    soma += int.parse(cpf[i]) * (10 - i);
  }
  int digito1 = (soma * 10) % 11;
  if (digito1 == 10) {
    digito1 = 0;
  }

  // Calcula o segundo dígito verificador
  soma = 0;
  for (int i = 0; i < 10; i++) {
    soma += int.parse(cpf[i]) * (11 - i);
  }
  int digito2 = (soma * 10) % 11;
  if (digito2 == 10) {
    digito2 = 0;
  }

  // Verifica se os dígitos verificadores calculados são iguais aos do CPF
  return cpf.substring(9) == '$digito1$digito2';
}

String formatCPF(String input) {
  String digits = input.replaceAll(RegExp(r'[^0-9]'), '');

  if (digits.length >= 11) return input.substring(0, 14);

  if (digits.length >= 10) {
    String formatted =
        '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
    return formatted;
  }

  return input;
}

String formatPhoneNumber(String input) {
  String digits = input.replaceAll(RegExp(r'[^0-9]'), '');

  if (digits.length >= 11) return input.substring(0, 15);

  if (digits.length >= 8) {
    String formatted =
        '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    return formatted;
  }

  return input;
}

String formatDate(String input) {
  String digits = input.replaceAll(RegExp(r'[^0-9]'), '');

  if (digits.length >= 8) return input.substring(0, 10);

  if (digits.length >= 5) {
    String formatted =
        '${digits.substring(0, 2)}/${digits.substring(2, 4)}/${digits.substring(4)}';
    return formatted;
  }

  return input;
}

String formatCEP(String input) {
  String digits = input.replaceAll(RegExp(r'[^0-9]'), '');

  if (digits.length >= 8) return input.substring(0, 9);

  if (digits.length >= 6) {
    String formatted = '${digits.substring(0, 5)}-${digits.substring(5)}';
    return formatted;
  }

  return input;
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
