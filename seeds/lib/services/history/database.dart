import '../database.dart';
import '../topics/reference.dart';

abstract class HistoryDatabase<D>
    extends CustomDatabase<D, Reference, DateTime> {}
