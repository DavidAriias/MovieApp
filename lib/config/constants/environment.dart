import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String movieKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay key';
}
