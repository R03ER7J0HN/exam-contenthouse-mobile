export 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:mobile_exam/core/app/bloc.dart' as base;
import 'package:mobile_exam/core/app/view.dart';
import 'package:mobile_exam/core/extensions/map.dart';
import 'package:mobile_exam/core/services/server.dart';

import 'views/main.dart' as main_view;
import 'views/loading.dart' as loading_view;
import 'views/error.dart' as server_busy_view;

extension Extension on BuildContext {
  Bloc get bloc => read<Bloc>();
}

class Bloc extends base.Bloc {
  Bloc(BuildContext context)
      : super(loading_view.ViewState(), context: context);

  late final Server service;
  late String message;
  late String imageURL;

  @override
  void init() async {
    service = context.server;
    reloadView();
  }

  void reloadView() async {
    if (state is! loading_view.ViewState) {
      emit(loading_view.ViewState());
    }

    final serverResponse = await service.data;
    final statusCode = serverResponse.tryGet('status_code');

    message = serverResponse.tryGet(
      'message',
      ifnull: () => serverResponse.tryGet(
        'error_message',
        ifnull: () => context.strings.myExamDefaultErrorMessage,
      ),
    );

    imageURL = serverResponse.tryGet('image', ifnull: () => "");

    switch (statusCode) {
      case 200:
        emit(main_view.ViewState());
        break;
      default:
        emit(server_busy_view.ViewState());
        break;
    }
  }

  void incrementValue() async {
    await service.addToCount(1);
    super.updateView();
  }
}
