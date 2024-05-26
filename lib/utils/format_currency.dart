String formatCurrency(String amount) {
  try {
    return 'Rp ${amount.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  } catch (e) {
    return 'Rp 0';
  }
}
