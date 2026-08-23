import 'package:flutter/foundation.dart';

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
