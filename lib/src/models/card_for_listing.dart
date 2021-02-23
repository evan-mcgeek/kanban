class CardForListing {
  int id;
  String row;
  int seq_num;
  String text;

  CardForListing({this.id, this.row, this.seq_num, this.text});

  factory CardForListing.fromJson(Map<String, dynamic> item) {
    return CardForListing(
      id: item['id'],
      row: item['row'],
      seq_num: item['seq_num'],
      text: item['text'],
    );
  }
  Comparator<CardForListing> sortById = (a, b) => a.id.compareTo(b.id);
}
