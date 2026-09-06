import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';
import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';
import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/country/country_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_response.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_response.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications_count/notifications_count_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/site_faqs/site_faqs_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity> getUserMe() {
    return _remoteDataSource.fetchUserMe();
  }

  @override
  Future<CourseListResponse> getActiveCourses({int page = 1}) {
    return _remoteDataSource.fetchCourses(page: page);
  }

  @override
  Future<List<BannerEntity>> getActiveBanners() {
    return _remoteDataSource.fetchActiveBanners();
  }

  @override
  Future<void> postAvatar({required AvatarParams params}) {
    return _remoteDataSource.postModelAvatar(params: params);
  }

  @override
  Future<void> faceRecognition({required FaceRecParams params}) {
    return _remoteDataSource.faceRec(params: params);
  }

  @override
  Future<String> getMyIdSessionId({
    required String birthDate,
    required String passportData,
  }) {
    return _remoteDataSource.fetchMyIdSessionId(
      birthDate: birthDate,
      passportData: passportData,
    );
  }

  @override
  Future<List<CountryEntity>> getCountries() {
    return _remoteDataSource.fetchCountries();
  }

  @override
  Future<void> registerNotResident({
    required RegisterNotResidentParams params,
  }) {
    return _remoteDataSource.registerNotResident(params: params);
  }

  @override
  Future<NotifResponse> getNotifs({required NotifParams params}) {
    return _remoteDataSource.fetchNotif(params: params);
  }

  @override
  Future<List<ActiveDevicesEntity>> getActiveDevices() {
    return _remoteDataSource.fetchActiveDevices();
  }

  @override
  Future<void> deleteAllDevices() {
    return _remoteDataSource.deleteAllDevices();
  }

  @override
  Future<ModuleCategoryResponse> getModuleCategory({
    required ModuleCategoryParams params,
  }) {
    return _remoteDataSource.fetchModuleCategory(params: params);
  }

  @override
  Future<NotificationsCountEntity> getNotifCount() {
    return _remoteDataSource.fetchNotifCount();
  }

  @override
  Future<List<SiteFaqsEntity>> getSiteFaqs({required SiteFaqsParams params}) {
    return _remoteDataSource.fetchSiteFaqs(params: params);
  }
}
