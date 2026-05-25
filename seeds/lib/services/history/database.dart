import '../saved.dart';
import '../scriptures/reference.dart';

abstract class HistoryDatabase<D extends Object>
    extends SavedDatabase<D, ScriptureReference, DateTime> {}
