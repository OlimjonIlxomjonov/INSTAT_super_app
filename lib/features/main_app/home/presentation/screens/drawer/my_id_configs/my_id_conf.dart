import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
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

  Future<bool> startFaceVerification(
    BuildContext context, {
    required String sessionId,
  }) async {
    try {
      final result = await MyIdClient.start(
        //! Production
        config: MyIdConfig(
          sessionId: sessionId,
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
      logger.f(raw);
      if (raw == null || raw.isEmpty) {
        logger.e(" No image in MyID result");
        return false;
      }

      var bytes = base64Decode(raw);

      // The myid SDK's own camera capture may not deliver pixels in the
      // orientation they should display in — same class of bug as our own
      // CameraService. Bake in the EXIF rotation (if any) before this ever
      // reaches the backend.
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        logger.f(
          '🔎 MyID image decoded: ${decoded.width}x${decoded.height}, '
          'exif orientation tag: ${decoded.exif.imageIfd.hasOrientation ? decoded.exif.imageIfd.orientation : 'none'}',
        );
        final baked = img.bakeOrientation(decoded);
        logger.f('🔎 After bakeOrientation: ${baked.width}x${baked.height}');
        bytes = Uint8List.fromList(img.encodeJpg(baked));
      } else {
        logger.e('❌ Failed to decode MyID image for orientation check');
      }

      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/myid_image.jpg");
      await file.writeAsBytes(bytes);

      logger.f("Image saved at: ${file.path}");

      final faceRecBloc = context.read<FaceRecBloc>();
      // Wait for the actual backend verification (the /my-id/accept +
      // face-recognition calls) to finish before reporting success —
      // add() only enqueues the event, it doesn't wait for it to process.
      final resultState = faceRecBloc.stream.firstWhere(
        (state) => state is FaceRecLoaded || state is FaceRecError,
      );
      faceRecBloc.add(
        FaceRecEvent(
          params: FaceRecParams(code: result.code ?? '', imgPath: file),
        ),
      );
      logger.f("code: ${result.code}");

      final finalState = await resultState;
      return finalState is FaceRecLoaded;
    } on PlatformException catch (e) {
      logger.e('${e.message ?? "Verification failed"} ');
      if (context.mounted) {
        errorFlushBar(context, e.message ?? "Verification failed");
      }
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
        .replaceAll(RegExp(r"^data:image/[a-z]+;base64,"), "");
  }
}
