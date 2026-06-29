import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:myid/enums.dart';
import 'package:myid/myid.dart';
import 'package:myid/myid_config.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../../../core/utils/logger/logger.dart';

class MyIdConf {
  static const String _clientId =
      'instat_sdk-rLwcdCa93hJmKPxRAFf9BSgQXaXuRQ8h4vv8fe5F';
  static const String _clientHashId = 'e07fd12c-7aee-445b-b512-51e2478d8916';
  static const String _clientHash =
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp64tPQLPNz+q9N6qc3ZFnJYRhFBhKsKc07bUT5aahz+QSny9u94+gcEIhMJeyFID8NeWCiUPAyntOWhWQl6JQfe+GyxAfyHPbfYNsCh+FxICwzdBo/P4q0wco8g6kQpbLxlrJO9MAC/JnG4itnOuD6tc1hDMi/pQjoJzd8eT8mWCmSxzcGKRy5uyBPtW19I9PZ2ZgPCvMbxfQULUSSPWDuTgFQAhCXOxja1dywORZkFVYFpi2+LeJ+bR+btk8wOeLJ6gm8/+E1QkxRLnH8cou8suaOa1aqJemXPLsdDkgjhIpbPgjGPW8Q3sVSxGsDZUi6dzbdRXRDHHYhpPlMvjFwIDAQAB';

  Future<bool> startFaceVerification(BuildContext context) async {
    try {
      final result = await MyIdClient.start(
        //! Production
        config: MyIdConfig(
          // sessionId: _clientHashId,
          clientId: _clientId,
          clientHash: _clientHash,
          clientHashId: _clientHashId,
          environment: MyIdEnvironment.DEBUG,
          entryType: MyIdEntryType.IDENTIFICATION,
        ),
        iosAppearance: MyIdIOSAppearance(),
      );

      logger.f("MyID verification completed successfully.");
      logger.f("Code: ${result.code}");
      logger.f("Base64 length: ${result.base64?.length}");

      final raw = cleanBase64(result.base64);
      if (raw == null || raw.isEmpty) {
        logger.e(" No image in MyID result");
        return false;
      }

      final bytes = base64Decode(raw);
      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/myid_image.jpg");
      await file.writeAsBytes(bytes);

      logger.f("Image saved at: ${file.path}");

      // context.read<FaceRecMyIdBloc>().add(
      //   FaceRecMyIdEvent(result.code ?? '', file),
      // );
      logger.f("code: ${result.code}");
      return true;
    } on PlatformException catch (e) {
      errorFlushBar(context, e.message ?? "Verification failed");
      logger.e('${e.message ?? "Verification failed"} ');
      return false;
    } catch (e, st) {
      logger.e("Unexpected error: $e\n$st");
      return false;
    }
  }

  String? cleanBase64(String? input) {
    if (input == null) return null;
    return input
        .replaceAll("\n", "")
        .replaceAll("\r", "")
        .replaceAll(" ", "")
        .replaceAll("-", "+")
        .replaceAll("_", "/")
        .replaceAll(RegExp(r"^data:image\/[a-z]+;base64,"), "");
  }
}
