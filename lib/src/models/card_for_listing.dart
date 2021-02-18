class Card {
  int id;
  String row;
  int seq_num;
  String text;

  Card({this.id, this.row, this.seq_num, this.text});

  factory Card.fromJson(Map<String, dynamic> item) {
    return Card(
      id: item['id'],
      row: item['row'],
      seq_num: item['seq_num'],
      text: item['text'],
    );
  }
}
