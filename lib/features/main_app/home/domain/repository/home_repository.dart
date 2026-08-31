import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';
import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/country/country_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_response.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_response.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';

abstract class HomeRepository {
  Future<UserEntity> getUserMe();

  Future<CourseListResponse> getActiveCourses({int page = 1});

  Future<List<BannerEntity>> getActiveBanners();

  /// pick the avatar
  Future<void> postAvatar({required AvatarParams params});

  //! Face Recognition
  Future<void> faceRecognition({required FaceRecParams params});

  Future<String> getMyIdSessionId({
    required String birthDate,
    required String passportData,
  });

  //! not-resident (foreign user) account confirmation
  Future<List<CountryEntity>> getCountries();

  Future<void> registerNotResident({required RegisterNotResidentParams params});

  //! Notifications
  Future<NotifResponse> getNotifs({required NotifParams params});

  Future<List<ActiveDevicesEntity>> getActiveDevices();

  Future<void> deleteAllDevices();

  Future<ModuleCategoryResponse> getModuleCategory({
    required ModuleCategoryParams params,
  });
}
