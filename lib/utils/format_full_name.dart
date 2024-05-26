String formatFullName(String fullName) {
  List<String> nameParts = fullName.split(' ');
  if (nameParts.length > 2) {
    String firstName = nameParts.first;
    String lastName = nameParts.last;

    String middleNameInitials = '';
    for (int i = 1; i < nameParts.length - 1; i++) {
      middleNameInitials += nameParts[i][0];
      middleNameInitials += ' ';
    }
    middleNameInitials = middleNameInitials.trim();
    return '$firstName $middleNameInitials $lastName';
  } else {
    return fullName;
  }
}
