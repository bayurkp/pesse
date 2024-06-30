String formatSentenceCase(String input) {
  List<String> words = input.split(' ');

  List<String> capitalizedWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).toList();

  return capitalizedWords.join(' ');
}
