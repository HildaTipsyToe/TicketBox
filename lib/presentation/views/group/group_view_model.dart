import 'dart:async';

import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/post.dart';
import 'package:ticketbox/infrastructure/repository/post_repository.dart';
import 'package:ticketbox/presentation/views/base/base_view_model.dart';

/// Class handeling model data for the Group view
/// 
/// This class contains:
///  - [getPostsByReceiverIdAndGroupId]
///  - 
class GroupViewModel extends BaseViewModel {
  GroupViewModel();

  /// Method for getting the posts by [receiverId] and [groupId]
  Stream<List<Post>> getPostsByReceiverIdAndGroupId(receiverId, groupId) {
    Stream<List<Post>> tempPosts = sl<IPostRepository>()
        .getPostsByReceiverIdAndGroupIdStream(receiverId, groupId);
    return tempPosts;
  }

  //Dummy data, for the testing
  List<Post> tickets = [
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 20,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'For sent'),
    Post(
        adminId: '',
        adminName: '',
        groupId: '',
        price: 40,
        receiverId: '',
        receiverName: '',
        ticketTypeId: '',
        ticketTypeName: 'Glemt tøj')
  ];
}
