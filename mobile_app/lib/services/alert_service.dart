import 'package:edge_alerts/edge_alerts.dart';
import 'package:flutter/material.dart';

enum AlertType { success, error, warning, info, network }

class AlertService {
  void show(
      {required String message,
      required AlertType type,
      required BuildContext context,
      int durationInSec = 1}) {
    edgeAlert(
      context,
      title: _chooseTitle(type),
      description: message,
      duration: durationInSec,
      icon: _chooseIcon(type),
      backgroundColor: _chooseColor(type),
      gravity: Gravity.top,
    );
  }

  Color _chooseColor(AlertType type) {
    if (type == AlertType.success) {
      return Colors.green;
    } else if (type == AlertType.error) {
      return Colors.red;
    } else if (type == AlertType.warning) {
      return Colors.orange;
    } else if (type == AlertType.network) {
      return Colors.orangeAccent;
    } else {
      return Colors.cyan;
    }
  }

  String _chooseTitle(AlertType type) {
    if (type == AlertType.success) {
      return "Success!!!";
    } else if (type == AlertType.error) {
      return "Error!!!";
    } else if (type == AlertType.warning) {
      return "Warning!!!";
    } else if (type == AlertType.network) {
      return "Network Connection!!!";
    } else {
      return "Info";
    }
  }

  IconData _chooseIcon(AlertType type) {
    if (type == AlertType.success) {
      return Icons.check_circle_outline;
    } else if (type == AlertType.error) {
      return Icons.error_outline;
    } else if (type == AlertType.network) {
      return Icons.wifi_off;
    } else {
      return Icons.info_outline;
    }
  }
}
