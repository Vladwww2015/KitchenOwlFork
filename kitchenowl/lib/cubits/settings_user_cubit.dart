// ignore_for_file: use_build_context_synchronously

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchenowl/cubits/auth_cubit.dart';
import 'package:kitchenowl/enums/update_enum.dart';
import 'package:kitchenowl/models/token.dart';
import 'package:kitchenowl/models/user.dart';
import 'package:kitchenowl/services/api/api_service.dart';

class SettingsUserCubit extends Cubit<SettingsUserState> {
  final int? userId;
  SettingsUserCubit(this.userId, [User? initialUserData])
      : super(SettingsUserState(initialUserData, false, UpdateEnum.unchanged)) {
    refresh();
  }

  Future<void> refresh() async {
    User? user;
    user = userId != null
        ? await ApiService.getInstance().getUserById(userId!)
        : await ApiService.getInstance().getUser();
    emit(state.copyWith(user: user, setAdmin: user?.serverAdmin));
  }

  Future<void> updateUser({
    required BuildContext context,
    String? name,
    String? username,
    String? password,
    String? email,
  }) async {
    if (state.user == null) return;
    bool res = false;
    res = userId != null
        ? await ApiService.getInstance().updateUserById(
            userId!,
            name: name,
            password: password,
            email: email,
            admin: (state.setAdmin != state.user!.serverAdmin)
                ? state.setAdmin
                : null,
          )
        : await ApiService.getInstance().updateUser(
            name: name,
            password: password,
            email: email,
          );
    if (res) {
      emit(state.copyWith(updateState: UpdateEnum.updated));
      if (userId == null) {
        BlocProvider.of<AuthCubit>(context).refreshUser();
      }
      await refresh();
    }
  }

  void setAdmin(bool newAdmin) {
    emit(state.copyWith(setAdmin: newAdmin));
  }

  Future<String?> addLongLivedToken(String name) async {
    final token = await ApiService.getInstance().createLongLivedToken(name);
    if (token != null) refresh();

    return token;
  }

  Future<void> deleteLongLivedToken(Token token) async {
    final success = await ApiService.getInstance().deleteLongLivedToken(token);
    if (success) refresh();
  }

  Future<bool> deleteUser() async {
    if (state.user != null) {
      return ApiService.getInstance()
          .deleteUser(userId != null ? state.user! : null);
    }

    return false;
  }

  Future<bool> resendVerificationMail() {
    return ApiService.getInstance().resendVerificationMail();
  }
}

class SettingsUserState extends Equatable {
  final User? user;
  final bool setAdmin;
  final UpdateEnum updateState;

  const SettingsUserState(this.user, this.setAdmin, this.updateState);

  @override
  List<Object?> get props => [user, setAdmin, updateState];

  SettingsUserState copyWith({
    User? user,
    bool? setAdmin,
    UpdateEnum? updateState,
  }) =>
      SettingsUserState(
        user ?? this.user,
        setAdmin ?? this.setAdmin,
        updateState ?? this.updateState,
      );
}
