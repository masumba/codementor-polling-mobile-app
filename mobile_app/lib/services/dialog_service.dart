import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/constants/app_string.dart';
import 'package:mobile_app/extensions/string_extension.dart';
import 'package:mobile_app/service_locator.dart';
import 'package:mobile_app/services/alert_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:ndialog/ndialog.dart';

/// The `DialogService` class provides methods for displaying various types of dialogs and alerts, as well as progress indicators.
/// It uses the `NavigationService` to get the current context for displaying these dialogs.
/// This service also includes options to customize the appearance and behavior of the dialogs.
class DialogService {
  final NavigationService _navigationService = locator<NavigationService>();
  final AlertService _alertService = AlertService();
  ProgressDialog? _progressDialog;

  /// Show an edge alert with a specified message and alert type, with optional duration in seconds.
  void showEdgeAlert(
      {required String message,
      required AlertType type,
      int durationInSec = 1}) {
    try {
      _alertService.show(
        message: message,
        type: type,
        durationInSec: durationInSec,
        context: _navigationService.navigationKey.currentContext!,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Display a progress dialog with optional title, message, and dismissible settings.
  void showProgress(
      {String title = 'Loading',
      String message = 'Please Wait.....',
      bool dismissible = false}) {
    if (_progressDialog != null) {
      _progressDialog!.dismiss();
    }
    _progressDialog = ProgressDialog(
      _navigationService.navigationKey.currentContext!,
      dialogStyle: DialogStyle(
          borderRadius: BorderRadius.circular(12.0),
          backgroundColor: AppColor.primaryColorDark.toColor(),
          titleTextStyle: const TextStyle(color: Colors.white),
          contentTextStyle: const TextStyle(color: Colors.white)),
      blur: 0,
      dismissable: dismissible,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      message: Text(message),
      onDismiss: () {
        debugPrint("Do something onDismiss");
      },
    );
    _progressDialog!.setLoadingWidget(
      const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
    _progressDialog!.show();
  }

  /// Close the current progress dialog, if it exists.
  void closeProgress() {
    if (_progressDialog != null) {
      _progressDialog!.dismiss();
    }
  }

  /// Show a confirmation dialog with a specified message and optional positive/negative responses.
  Future<bool> showConfirmationDialog(
    String message, {
    String positiveResponse = "Yes",
    String negativeResponse = "No",
  }) async {
    var result = await showDialog(
      context: _navigationService.navigationKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              child: Text(
                positiveResponse,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text(
                negativeResponse,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
    result ??= false;
    return result;
  }

  /// Show a decision dialog with optional title, message, note, positive/negative responses and their corresponding styles.
  Future<bool> showDecisionDialog({
    String title = 'Alert',
    String message = 'Are you sure the information provided is correct ?',
    String? messageNote,
    String positiveResponse = "Yes",
    ButtonStyle? positiveResponseButtonStyle,
    String negativeResponse = "No",
    ButtonStyle? negativeResponseButtonStyle,
  }) async {
    var result = await showDialog(
      barrierDismissible: false,
      context: _navigationService.navigationKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('$message\n'),
                if (messageNote != null)
                  Text(
                    '$messageNote\n',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: positiveResponseButtonStyle,
              child: Text(
                positiveResponse,
              ),
            ),
            TextButton(
              style: negativeResponseButtonStyle,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                negativeResponse,
              ),
            ),
          ],
        );
      },
    );
    result ??= false;
    return result;
  }

  /// Show an accept decision dialog with optional title, message, positive/negative responses.
  Future<bool> showAcceptDecisionDialog({
    String title = 'Alert',
    String message = 'Are you sure the information provided is correct ?',
    String positiveResponse = "Yes",
    String negativeResponse = "No",
  }) async {
    var result = await showDialog(
      barrierDismissible: false,
      context: _navigationService.navigationKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            //fontFamily: appDefaultDialogFontFamily,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black,
            //fontFamily: appDefaultDialogFontFamily,
            fontWeight: FontWeight.normal,
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: Text('$message\n'),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  positiveResponse,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                )),
            TextButton(
              child: Text(
                negativeResponse,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
    result ??= false;
    return result;
  }

  /// Show a generic confirmation dialog with a specified action on acceptance, and optional title and message.
  Future<void> showGenericConfirmationDialog({
    required Function onAccept,
    String title = 'Alert',
    String message = 'Are you sure the information provided is correct ?',
  }) async {
    showGenericDialog(
      title: title,
      content: message,
      options: <Widget>[
        TextButton(
            onPressed: () async {
              _navigationService.pop();
              onAccept();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )),
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            _navigationService.pop();
          },
        ),
      ],
    );
  }

  /// Show an alert dialog with optional title and message.
  Future<void> showAlertDialog(
      {String title = 'Alert',
      String message = 'Please provide all required data!!'}) async {
    showGenericDialog(
      title: title,
      content: message,
      options: <Widget>[
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            _navigationService.pop();
          },
        ),
      ],
    );
  }

  /// Show a default error dialog with optional title, message, and an action on support button click.
  Future<void> showDefaultErrorDialog(
      {String title = 'Error',
      String message = AppString.defaultRequestErrorMessage,
      Function? onSupportClick}) async {
    showGenericDialog(
      title: title,
      content: message,
      options: <Widget>[
        onSupportClick != null
            ? TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColor.primaryColor.toColor(),
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                ),
                child: const Text(
                  'Talk To Someone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _navigationService.pop();
                  onSupportClick();
                },
              )
            : Container(),
        TextButton(
          child: const Text(
            'Close',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            _navigationService.pop();
          },
        ),
      ],
    );
  }

  /// Show a generic dialog with specified title, content, and options, along with optional title/content text styles, content bold, and barrier dismissible settings.
  Future<void> showGenericDialog({
    required String title,
    required String? content,
    required List<Widget> options,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    bool contentBold = false,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: _navigationService.navigationKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            //fontFamily: appDefaultDialogFontFamily,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            //fontFamily: appDefaultDialogFontFamily,
            fontWeight: contentBold ? FontWeight.bold : FontWeight.normal,
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: Text('$content\n'),
          ),
          actions: options,
        );
      },
    );
  }

  /// Show an options dialog with specified title, content, and dialog options, along with optional title/content text styles, content bold, and barrier dismissible settings.
  Future<void> showOptionsDialog({
    required String title,
    required String? content,
    required List<DialogOption> options,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    bool contentBold = false,
    bool barrierDismissible = false,
  }) {
    List<Widget> buttonOptions = [];
    for (var element in options) {
      buttonOptions.add(
        TextButton(
          child: Text(
            element.title.toTitleCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            _navigationService.pop();
            element.onTap();
          },
        ),
      );
    }
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: _navigationService.navigationKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            //fontFamily: appDefaultDialogFontFamily,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            //fontFamily: appDefaultDialogFontFamily,
            fontWeight: contentBold ? FontWeight.bold : FontWeight.normal,
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: Text('$content\n'),
          ),
          actions: [
            ...buttonOptions,
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                disabledForegroundColor: Colors.grey.withOpacity(0.38),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _navigationService.pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show a non dismissible dialog with specified title, content, and options, along with optional title/content text styles and content bold settings.
  Future<void> showNonDismissibleDialog({
    required String title,
    required String content,
    required List<Widget> options,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    bool contentBold = false,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: _navigationService.navigationKey.currentContext!,
      builder: (context) {
        return WillPopScope(
            child: AlertDialog(
              backgroundColor: Colors.white,
              titleTextStyle: const TextStyle(
                color: Colors.black,
                //fontFamily: appDefaultDialogFontFamily,
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: TextStyle(
                color: Colors.black,
                //fontFamily: appDefaultDialogFontFamily,
                fontWeight: contentBold ? FontWeight.bold : FontWeight.normal,
              ),
              title: Text(title),
              content: SingleChildScrollView(
                child: Text('$content\n'),
              ),
              actions: options,
            ),
            onWillPop: () async => false);
      },
    );
  }

  Future<void> showBottomSheet(
      {required Widget content, bool isExpanded = false}) {
    double sheetHeight = 0.65;

    if (isExpanded) {
      sheetHeight = 0.90;
    }

    return showModalBottomSheet(
      context: _navigationService.navigationKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * sheetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: content,
        ),
      ),
    );
  }

  void showToast(
      {Icon? icon, String? title, String? content, int durationInSec = 10}) {
    Flushbar(
      icon: icon ??
          Icon(
            Icons.info,
            size: 28.0,
            color: Colors.blue[300],
          ),
      flushbarStyle: FlushbarStyle.FLOATING,
      title: title,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      message: content,
      duration: Duration(seconds: durationInSec),
    ).show(_navigationService.navigationKey.currentContext!);
  }
}

class DialogOption {
  final String title;
  final VoidCallback onTap;

  DialogOption({required this.title, required this.onTap});
}
