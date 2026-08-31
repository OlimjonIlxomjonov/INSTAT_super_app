import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/main_app/home/data/model/banner/banner_model.dart';
import 'package:my_template/features/main_app/home/data/model/country/country_model.dart';
import 'package:my_template/features/main_app/home/data/model/module_category/module_category_response_model.dart';
import 'package:my_template/features/main_app/home/data/model/notifications/notif_response_model.dart';
import 'package:my_template/features/main_app/home/data/model/user_me/user_model.dart';
import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> fetchUserMe();

  Future<CourseListResponseModel> fetchCourses({int page = 1});

  Future<List<BannerModel>> fetchActiveBanners();

  Future<void> postModelAvatar({required AvatarParams params});

  //! face rec
  Future<void> faceRec({required FaceRecParams params});

  Future<String> fetchMyIdSessionId({
    required String birthDate,
    required String passportData,
  });

  //! not-resident (foreign user) account confirmation
  Future<List<CountryModel>> fetchCountries();

  Future<void> registerNotResident({required RegisterNotResidentParams params});

  //! Notifications
  Future<NotifResponseModel> fetchNotif({required NotifParams params});

  Future<List<ActiveDevicesEntity>> fetchActiveDevices();

  Future<void> deleteAllDevices();

  Future<ModuleCategoryResponseModel> fetchModuleCategory({
    required ModuleCategoryParams params,
  });
}
