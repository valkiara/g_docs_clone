import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_docs_clone/colors.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController textEditingController =
      TextEditingController(text: 'Untitled Document');
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Row(
              children: [
                Image.asset('assets/images/docs-logo.png', height: 40),
                const SizedBox(width: 10),
                SizedBox(
                    width: 200,
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                          hintText: 'Untitled document',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kBlueColor)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10)),
                    ))
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kGrayColor, width: 0.1),
              ),
            ),
          ),
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlueColor,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              quill.QuillToolbar.basic(controller: _controller),
              const SizedBox(height: 10),
              Expanded(
                  child: SizedBox(
                width: 750,
                child: Card(
                  color: kWhiteColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: false,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}
