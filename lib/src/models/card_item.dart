class CardItem {
  int id;
  String row;
  int seq_num;
  String text;

  CardItem({this.id, this.row, this.seq_num, this.text});

  factory CardItem.fromJson(Map<String, dynamic> item) {
    return CardItem(
      id: item['id'],
      row: item['row'],
      seq_num: item['seq_num'],
      text: item['text'],
    );
  }
}
