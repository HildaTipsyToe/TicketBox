
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ticketbox/infrastructure/datasource/api_datasource.dart';
import 'package:ticketbox/infrastructure/repository/group_repository.dart';
import 'package:ticketbox/infrastructure/repository/membership_repository.dart';
import 'package:ticketbox/infrastructure/repository/post_repository.dart';
import 'package:ticketbox/infrastructure/repository/user_repository.dart';
import 'package:ticketbox/presentation/views/dashboard/dashboard_view_model.dart';
import 'package:ticketbox/presentation/views/fines/fines_view_model.dart';
import 'package:ticketbox/presentation/views/group/group_view_model.dart';
import 'package:ticketbox/presentation/views/members/members_view_model.dart';

import '../domain/entities/settings.dart';
import '../domain/entities/user.dart';
import '../infrastructure/datasource/auth_datasource.dart';
import '../infrastructure/repository/auth_repository.dart';
import '../infrastructure/repository/group_repository.dart';
import '../infrastructure/repository/message_repository.dart';
import '../infrastructure/repository/tickettype_repository.dart';
import '../presentation/views/chat/chat_view_model.dart';
import '../presentation/views/login/login_view_model.dart';

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
  sl.registerLazySingleton<DashboardViewModel>(() => DashboardViewModel());
  sl.registerLazySingleton<MembersViewModel>(() => MembersViewModel());
  sl.registerLazySingleton<LoginViewModel>(() => LoginViewModel());
  sl.registerLazySingleton<FinesViewModel>(() => FinesViewModel());
  sl.registerLazySingleton<GroupViewModel>(() => GroupViewModel());
  // sl.registerLazySingleton<GroupAdminViewModel>(() => GroupAdminViewModel());
  sl.registerLazySingleton<ChatViewModel>(() => ChatViewModel());

}

void _initUseCases() {
  sl.registerLazySingleton<TBSettings>(() => TBSettings(isLoggedIn: false));
  sl.registerLazySingleton<TBUser>(() => TBUser(userId: '1', userName: '2', userMail: '3'));
}

void _initRepositories() {
  if (mock) {
    sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryMock());
    sl.registerLazySingleton<IUserRepository>(() => UserRepositoryMock());
    sl.registerLazySingleton<IGroupRepository>(() => GroupRepositoryMock());
    sl.registerLazySingleton<IMembershipRepository>(() => MembershipRepositoryMock());
    sl.registerLazySingleton<ITicketTypeRepository>(() => TicketTypeRepositoryMock());
    sl.registerLazySingleton<IPostRepository>(() => PostRepositoryMock());
    sl.registerLazySingleton<IMessageRepository>(() => MessageRepositoryMock());
  } else {
    sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(sl<AuthDataSource>(), sl<TBSettings>()));
    sl.registerLazySingleton<IUserRepository>(() => UserRepositoryImpl(sl<ApiDataSource>()));
    sl.registerLazySingleton<IMembershipRepository>(() => MembershipRepositoryImpl(sl<ApiDataSource>()));
    sl.registerLazySingleton<IPostRepository>(() => PostRepositoryImpl(sl<ApiDataSource>()));
    sl.registerLazySingleton<IGroupRepository>(() => GroupRepositoryImpl(sl<ApiDataSource>()));
    sl.registerLazySingleton<ITicketTypeRepository>(() => TicketTypeRepositoryImpl(sl<ApiDataSource>()));
    sl.registerLazySingleton<IMessageRepository>(() => MessageRepositoryImpl(sl<ApiDataSource>()));
  }
}



void _initDataSources() {
  sl.registerLazySingleton<ApiDataSource>(() => ApiDataSource());
  sl.registerLazySingleton<AuthDataSource>(() => FirebaseAuthDataSource(firebaseAuth: FirebaseAuth.instance));
}


void _initExternals() {
  // sl.registerLazySingleton(() => const FlutterSecureStorage());
}
