import 'package:get_it/get_it.dart';
import 'package:todo_app/routes/navigation_service.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerSingleton(() => NavigationService());
}