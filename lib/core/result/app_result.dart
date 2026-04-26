import 'package:fpdart/fpdart.dart';

import '../failures/app_failure.dart';

typedef AppResult<T> = Either<AppFailure, T>;
typedef AppTaskResult<T> = TaskEither<AppFailure, T>;

AppResult<T> success<T>(T value) => right(value);

AppResult<T> failure<T>(AppFailure error) => left(error);
