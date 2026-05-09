import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Intents
class OpenFileIntent extends Intent { const OpenFileIntent(); }
class NextPageIntent extends Intent { const NextPageIntent(); }
class PrevPageIntent extends Intent { const PrevPageIntent(); }
class FirstPageIntent extends Intent { const FirstPageIntent(); }
class LastPageIntent extends Intent { const LastPageIntent(); }
class SearchIntent extends Intent { const SearchIntent(); }
class EscapeIntent extends Intent { const EscapeIntent(); }
class PrintIntent extends Intent { const PrintIntent(); }
class BookmarkIntent extends Intent { const BookmarkIntent(); }
class PresentationModeIntent extends Intent { const PresentationModeIntent(); }
class ZoomInIntent extends Intent { const ZoomInIntent(); }
class ZoomOutIntent extends Intent { const ZoomOutIntent(); }
class ZoomResetIntent extends Intent { const ZoomResetIntent(); }

// Shortcuts Map
final Map<ShortcutActivator, Intent> readerShortcuts = {
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO): const OpenFileIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextPageIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowLeft): const PrevPageIntent(),
  LogicalKeySet(LogicalKeyboardKey.home): const FirstPageIntent(),
  LogicalKeySet(LogicalKeyboardKey.end): const LastPageIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF): const SearchIntent(),
  LogicalKeySet(LogicalKeyboardKey.escape): const EscapeIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP): const PrintIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD): const BookmarkIntent(),
  LogicalKeySet(LogicalKeyboardKey.f11): const PresentationModeIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.numpadAdd): const ZoomInIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.add): const ZoomInIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.numpadSubtract): const ZoomOutIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus): const ZoomOutIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.numpad0): const ZoomResetIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit0): const ZoomResetIntent(),
};
