import '../saved.dart';
import '../scriptures/reference.dart';

abstract class HistoryDatabase<D>
    extends SavedDatabase<D, ScriptureReference, DateTime> {}
