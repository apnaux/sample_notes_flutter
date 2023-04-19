import 'package:flutter/material.dart';
import 'package:sqlite_filehandling/db/db_helper.dart';
import 'package:sqlite_filehandling/pages/new_note.dart';
import '/db/note_class.dart';

// ROUTING INFORMATION: https://docs.flutter.dev/cookbook/navigation
// PERSIST DATA USING SQLITE: https://docs.flutter.dev/cookbook/persistence/sqlite#example
// USE LISTVIEW: https://api.flutter.dev/flutter/widgets/ListView-class.html
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      routes: {
        '/mainscreen': (_) => const MyApp(),
        '/createnote': (_) => const CreateNote(),
      },
      home: const MyHomePage(title: 'Sample notes application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Note> _allNotes = [];
  bool _isLoading = true;
  dynamic result;

  @override
  void initState() {
    updateList();
    super.initState();
  }

  void updateList() {
    setState(() {
      _isLoading = true;
    });
    DBHelper.getNoteList().then((value) {
      if (_allNotes.isNotEmpty) _allNotes.clear();
      _allNotes.addAll(value);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _createNote() async {
    result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CreateNote()));

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    // tbh I don't get its purpose :/
    if (!mounted) return;

    if (result['success'] == true) updateList();
    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(result['message']),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _allNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Create a new Note using the plus(+) button',
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _allNotes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(_allNotes[index].title),
                      subtitle: Text(_allNotes[index].note),
                      onTap: () {},
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
