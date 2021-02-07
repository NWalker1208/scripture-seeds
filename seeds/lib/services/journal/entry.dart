import 'package:built_collection/built_collection.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class JournalEntry implements Comparable<JournalEntry> {
  JournalEntry({
    DateTime created,
    this.category = 'other',
    this.quote = '',
    this.reference = '',
    this.url = '',
    this.commentary = '',
    Iterable<String> tags = const [],
  })  : created = created ?? DateTime.now(),
        _tags = tags.toBuiltList();

  @HiveField(0)
  final DateTime created;
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String quote;
  @HiveField(3)
  final String reference;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final String commentary;
  final BuiltList<String> _tags;
  @HiveField(6)
  Iterable<String> get tags => _tags;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);

  @override
  String toString() {
    if (quote != reference) {
      return '$quote - $reference\n$commentary\n$url';
    } else {
      return '$quote\n$commentary';
    }
  }

  String get name => created.toIso8601String().replaceAll(RegExp(r'[:.]'), '_');

  @override
  int compareTo(JournalEntry other) => created.compareTo(other.created);
}
