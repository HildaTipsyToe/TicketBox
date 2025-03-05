import 'dart:async';

import 'package:ticketbox/config/injection_container.dart';
import 'package:ticketbox/domain/entities/post.dart';
import 'package:ticketbox/infrastructure/repository/post_repository.dart';
import 'package:ticketbox/presentation/views/base/base_view_model.dart';

class GroupViewModel extends BaseViewModel {
  GroupViewModel();

  Stream<List<Post>> getPostsByReceiverIdAndGroupId(receiverId, groupId) {
    Stream<List<Post>> tempPosts;
    tempPosts = sl<IPostRepository>()
        .getPostsByReceiverIdAndGroupIdStream(receiverId, groupId);

    return tempPosts;
  }

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
