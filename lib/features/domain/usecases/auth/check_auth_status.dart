import 'package:e_commerce_client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entity/user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class CheckAuthStatus implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;
  CheckAuthStatus(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
