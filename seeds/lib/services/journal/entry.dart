import 'package:built_collection/built_collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@JsonSerializable()
class JournalEntry implements Comparable<JournalEntry> {
  JournalEntry({
    DateTime created,
    this.category = 'other',
    this.quote = '',
    this.reference = '',
    this.url = '',
    this.commentary = '',
    Iterable<String> tags,
  })  : created = created ?? DateTime.now(),
        tags = (tags ?? <String>[]).toBuiltList();

  final DateTime created;
  final String category;
  final String quote;
  final String reference;
  final String url;
  final String commentary;
  final BuiltList<String> tags;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  Map<String, dynamic> toJSON() => _$JournalEntryToJson(this);

  @override
  String toString() {
    if (quote != reference) {
      return '$quote - $reference\n$commentary\n$url';
    } else {
      return '$quote\n$commentary';
    }
  }

  String get fileName =>
      '${created.toIso8601String().replaceAll(RegExp(r'[:.]'), '_')}.jrnent';

  @override
  int compareTo(JournalEntry other) => created.compareTo(other.created);
}
