
import 'package:get_it/get_it.dart';

import '../infrastructure/repository/auth_repository.dart';

final sl = GetIt.instance;
bool mock = false;


Future<void> injectionInit() async {
  _initViewModels();
  _initUseCases();
  _initRepositories();
  _initDataSources();
  _initExternals();
}

void _initViewModels() {
  // sl.registerLazySingleton<DashboardViewModel>(() => DashboardViewModel());
  // sl.registerLazySingleton<MembersViewModel>(() => MembersViewModel());
  // sl.registerLazySingleton<LoginViewModel>(() => LoginViewModel());
  // sl.registerLazySingleton<FinesViewModel>(() => FinesViewModel());
  // sl.registerLazySingleton<GroupViewModel>(() => GroupViewModel());
  // sl.registerLazySingleton<GroupAdminViewModel>(() => GroupAdminViewModel());

}

void _initUseCases() {
  // sl.registerLazySingleton<Settings>(() => Settings(isLoggedIn: false));
  // sl.registerLazySingleton<BKUser>(() => BKUser(userId: '1', userName: '2', userMail: '3'));
}

void _initRepositories() {
  if (mock) {
    sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryMock());
    // sl.registerLazySingleton<IUserRepository>(() => UserRepositoryMock(sl<ApiDataSource>()));
    // sl.registerLazySingleton<IGroupRepository>(() => GroupRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<IMembershipRepository>(() => MembershipRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<ITicketTypeRepository>(() => TicketTypeRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<IPostRepository>(() => PostRepositoryImpl(sl<ApiDataSource>()));
  } else {
    sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl());
    // sl.registerLazySingleton<IUserRepository>(() => UserRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<IGroupRepository>(() => GroupRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<IMembershipRepository>(() => MembershipRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<ITicketTypeRepository>(() => TicketTypeRepositoryImpl(sl<ApiDataSource>()));
    // sl.registerLazySingleton<IPostRepository>(() => PostRepositoryImpl(sl<ApiDataSource>()));
  }
}


void _initDataSources() {
  // sl.registerLazySingleton<ApiDataSource>(() => ApiDataSource());
  // sl.registerLazySingleton<AuthDataSource>(() => FirebaseAuthDataSource(firebaseAuth: FirebaseAuth.instance));
}


void _initExternals() {
  // sl.registerLazySingleton(() => const FlutterSecureStorage());
}
