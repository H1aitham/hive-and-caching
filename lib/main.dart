import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hiveandcach/config/get_config.dart';
import 'package:hiveandcach/controller/counter_controller.dart';
import 'package:hiveandcach/model/bird_model.2.dart';
import 'package:hiveandcach/model/bird_model.dart';
import 'package:hiveandcach/model/handle_model.dart';
import 'package:hiveandcach/service/bird_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BirdModelAdapter());
  await Hive.openBox<BirdModel>('bird');

  init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  ValueNotifier<ResultModel> result = ValueNotifier(ResultModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageWithListBird(),
                  ));
            },
            icon: Icon(Icons.toc)),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomePageWithListBird extends StatelessWidget {
  HomePageWithListBird({super.key});

  ValueNotifier<ResultModel> result = ValueNotifier(ResultModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: result,
        builder: (context, value, child) {
          if (value is ListOf<BirdModel>) {
            return ListView.builder(
                itemCount: value.modelList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(value.modelList[index].name),
                    leading: Image.network(value.modelList[index].image),
                  );
                });
          } else if (value is ExceptionModel) {
            return Text(value.message);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        result.value = await core.get<BirdServiceImp>().getAllBird();
      }),
    );
  }
}
