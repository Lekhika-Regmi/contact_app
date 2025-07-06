import 'package:flutter/material.dart';

import '../data/contact_model.dart';

class AddEditContactPage extends StatefulWidget {
  final Contact? contact;

  const AddEditContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<AddEditContactPage> createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
