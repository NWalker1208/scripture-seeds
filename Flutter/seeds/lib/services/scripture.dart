class Scripture {
  String book;
  int chapter;
  int verse;

  String text;

  Scripture({this.book, this.chapter, this.verse, this.text});

  @override
  String toString() {
    return '$book $chapter:$verse';
  }
}
