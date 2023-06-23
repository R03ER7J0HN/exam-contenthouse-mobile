import 'package:flutter/material.dart';
import 'package:mobile_exam/core/app/view.dart' as base;
import 'package:mobile_exam/screens/exam/bloc.dart';

class ViewState extends base.ViewState {
  @override
  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          SizedBox(
            height: 450,
            child: Image.network(
              context.bloc.imageURL,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("assets/images/sad.jpg"),
            ),
          ),
          const SizedBox(height: 20),
          Text(context.bloc.message),
          Row(
            children: [
              ListenableBuilder(
                listenable: context.bloc,
                builder: (context, child) => Text(
                  "COUNTER: ${context.bloc.service.count}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () => context.bloc.incrementValue(),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
