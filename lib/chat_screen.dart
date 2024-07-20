import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  List<String> data = [];

  @override
  void initState() {
    data = List.generate(100, (index) => (index + 1).toString());
    WidgetsBinding.instance.addPostFrameCallback((d) {
      scrollToBottom();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Web Chat'),
      ),
      backgroundColor: const Color.fromARGB(255, 34, 1, 99),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemBuilder: (context, index) {
                  return Container(
                    key: ValueKey(data[index]),
                    height: 70,
                    color: Colors.blueAccent,
                    margin: const EdgeInsets.only(bottom: 15),
                    width: double.infinity,
                    child: Center(
                      child: Text('data ${data[index]} : $index'),
                    ),
                  );
                },
                itemCount: data.length,
              ),
            ),
            // const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: CupertinoTextField(
                    controller: _controller,
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    data.add(_controller.text);
                    _controller.clear();
                    setState(() {});
                    // scrollToBottom();
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   scrollToBottom();
                    // });
                    // SchedulerBinding.instance.addPostFrameCallback((_) {
                    // });
                    // scrollToBottom();
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      // Задержка для обеспечения выполнения после завершения всех обновлений
                      Future.delayed(const Duration(milliseconds: 50), () {
                        // Еще одна проверка состояния перед скроллингом
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          scrollToBottom();
                        });
                      });
                    });
                  },
                  child: const Icon(CupertinoIcons.arrow_up),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (_scroll.hasClients) {
      final position = _scroll.position;
      _scroll.animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
      );
    }
  }

  // void scrollToBottom() async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   if (_scroll.hasClients) {
  //     _scroll.animateTo(
  //       _scroll.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 350),
  //       curve: Curves.linear,
  //     );
  //   }
  //   // _scroll.animateTo(
  //   //   _scroll.position.maxScrollExtent,
  //   //   duration: const Duration(milliseconds: 350),
  //   //   curve: Curves.linear,
  //   // );
  //   // setState(() {});
  // }
}
