import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/bootstrap/app_bootstrap_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BibleApp(bootstrap: AppBootstrapController()));
}
