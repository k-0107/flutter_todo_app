import 'package:flutter/material.dart';

void main() {
  // 最初に表示するWidget
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPage createState() {
    return _TodoListPage();
  }
}

class _TodoListPage extends State<TodoListPage> {
  List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リスト一覧'),
      ),
      body: ReorderableListView.builder(
        itemCount: todoList.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(todoList[index]),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
              });
            },
            child: Card(
              child: ListTile(
                onTap: () async {
                  final String? editedText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TodoAddPage(
                          initialText: todoList[index],
                        );
                      },
                    ),
                  );
                  if (editedText != null) {
                    setState(() {
                      todoList[index] = editedText;
                    });
                  }
                },
                title: Text(todoList[index]),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          final String? newListText = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TodoAddPage();
              },
            ),
          );
          if (newListText != null) {
            setState(() {
              todoList.add(newListText);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //タップ長押しで上下に移動できる
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = todoList.removeAt(oldIndex);
      todoList.insert(newIndex, item);
    });
  }
}

class TodoAddPage extends StatefulWidget {
  final String? initialText;

  TodoAddPage({this.initialText});
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  late String _text = '';
  @override
  void initState() {
    super.initState();
    _text = widget.initialText ?? ''; // 初期テキストを設定（新規追加の場合は空）
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialText == null ? 'タスクを追加' : 'タスクを編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: TextEditingController(text: _text),
              onChanged: (String value) {
                setState(() {
                  _text = value;
                });
              },
              decoration: const InputDecoration(
                labelText: '追加したいタスクを入力',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_text);
                },
                child: const Text(
                  '追加',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
