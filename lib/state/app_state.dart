import 'package:flutter/foundation.dart';

/// Lightweight app-wide state. Provider is used only where a piece of UI state
/// is shared across widgets (the overview tabs and the neuro-toggle); pure
/// navigation state is left to the Navigator.
class AppState extends ChangeNotifier {
  OverviewTab _tab = OverviewTab.phenotype;
  OverviewTab get tab => _tab;
  set tab(OverviewTab value) {
    if (_tab == value) return;
    _tab = value;
    notifyListeners();
  }

  NeuroToggle _neuro = NeuroToggle.serotonin;
  NeuroToggle get neuro => _neuro;
  set neuro(NeuroToggle value) {
    if (_neuro == value) return;
    _neuro = value;
    notifyListeners();
  }
}

enum OverviewTab { genotype, phenotype }

enum NeuroToggle { dopamine, serotonin }
