import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histora_admin/dependency_injection.dart';
import 'package:histora_admin/firebase_options.dart';
import 'package:histora_admin/state/structure/bloc/upload_bloc.dart';
import 'package:histora_admin/view/upload_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  init();

  runApp(BlocProvider(
    create: (context) => UploadBloc(sl()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("[ Histora Mod   ;) ].... wonderful guys here..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Container(
                  color: Colors.grey.shade200,
                  child: const UploadForm(),
                )),
            const SizedBox(height: 10),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey.shade200,
                )),
          ],
        ),
      ),
    );
  }
}
