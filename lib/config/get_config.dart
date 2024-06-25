
import 'package:get_it/get_it.dart';
import 'package:hiveandcach/service/bird_service.dart';

GetIt core = GetIt.instance;

init() {
  core.registerSingleton(BirdServiceImp());
}
