class TermSection {
  final int number;
  final String title;
  final String content;
  final List<String>? bullets;

  const TermSection({
    required this.number,
    required this.title,
    required this.content,
    this.bullets,
  });
}