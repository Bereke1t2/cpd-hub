# Feature Scaffold

Boilerplate layout for a new feature module (e.g. `auth`, `attendance`, `settings`). Mirrors the existing
`future/main` structure but feature-scoped. Replace `xyz` with the feature name.

```
lib/features/xyz/
  data/
    datasources/
      xyz_remote_data_source.dart      # abstract + Impl(Dio)
    models/
      xyz_model.dart                   # extends entity, fromJson/toJson
    repository/
      xyz_repository_impl.dart         # implements domain repo, maps exceptions→Failure
  domain/
    entity/
      xyz_entity.dart                  # Equatable
    repository/
      xyz_repository.dart              # abstract, returns Either<T, Failure>  (Left=success)
    usecase/
      get_xyz.dart                     # thin wrapper over repo
  presentation/
    bloc/xyz/
      xyz_bloc.dart                    # part 'xyz_event.dart'; part 'xyz_state.dart';
      xyz_event.dart
      xyz_state.dart
    page/
      xyz_page.dart                    # BlocProvider(create: () => getIt<XyzBloc>()) + AsyncView
```

## Minimal files

### `domain/entity/xyz_entity.dart`
```dart
import 'package:equatable/equatable.dart';

class XyzEntity extends Equatable {
  final String id;
  final String name;
  const XyzEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
```

### `data/models/xyz_model.dart`
```dart
import '../../domain/entity/xyz_entity.dart';

class XyzModel extends XyzEntity {
  const XyzModel({required super.id, required super.name});

  factory XyzModel.fromJson(Map<String, dynamic> json) => XyzModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### `domain/repository/xyz_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure.dart';
import '../entity/xyz_entity.dart';

abstract class XyzRepository {
  // Left = success, Right = Failure (repo convention)
  Future<Either<List<XyzEntity>, Failure>> getXyz();
}
```

### `domain/usecase/get_xyz.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure.dart';
import '../entity/xyz_entity.dart';
import '../repository/xyz_repository.dart';

class GetXyz {
  final XyzRepository repo;
  GetXyz(this.repo);
  Future<Either<List<XyzEntity>, Failure>> call() => repo.getXyz();
}
```

### `presentation/bloc/xyz/xyz_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/xyz_entity.dart';
import '../../../domain/usecase/get_xyz.dart';

part 'xyz_event.dart';
part 'xyz_state.dart';

class XyzBloc extends Bloc<XyzEvent, XyzState> {
  final GetXyz getXyz;
  XyzBloc({required this.getXyz}) : super(const XyzInitial()) {
    on<XyzStarted>((event, emit) async {
      emit(const XyzLoading());
      final result = await getXyz();
      result.fold(
        (data) => emit(XyzLoaded(data)),          // Left = success
        (failure) => emit(XyzError(failure.message)),
      );
    });
  }
}
```

### `presentation/bloc/xyz/xyz_state.dart`
```dart
part of 'xyz_bloc.dart';

abstract class XyzState extends Equatable {
  const XyzState();
  @override
  List<Object?> get props => [];
}
class XyzInitial extends XyzState { const XyzInitial(); }
class XyzLoading extends XyzState { const XyzLoading(); }
class XyzLoaded extends XyzState {
  final List<XyzEntity> items;
  const XyzLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class XyzError extends XyzState {
  final String message;
  const XyzError(this.message);
  @override
  List<Object?> get props => [message];
}
```

### `presentation/bloc/xyz/xyz_event.dart`
```dart
part of 'xyz_bloc.dart';

abstract class XyzEvent extends Equatable {
  const XyzEvent();
  @override
  List<Object?> get props => [];
}
class XyzStarted extends XyzEvent { const XyzStarted(); }
```

### `presentation/page/xyz_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/async_view.dart';
import '../../domain/entity/xyz_entity.dart';
import '../bloc/xyz/xyz_bloc.dart';

class XyzPage extends StatelessWidget {
  const XyzPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<XyzBloc>()..add(const XyzStarted()),
      child: Scaffold(
        body: BlocBuilder<XyzBloc, XyzState>(
          builder: (context, state) => AsyncView<List<XyzEntity>>(
            isLoading: state is XyzLoading,
            error: state is XyzError ? state.message : null,
            data: state is XyzLoaded ? state.items : null,
            isEmpty: (d) => d.isEmpty,
            onRetry: () => context.read<XyzBloc>().add(const XyzStarted()),
            builder: (items) => ListView(
              children: [for (final x in items) ListTile(title: Text(x.name))],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Checklist for a new feature
- [ ] Entity + Model (with `fromJson`/`toJson`).
- [ ] Repository interface (domain) + Impl (data) mapping exceptions → failures.
- [ ] Remote data source (Dio) — and a mock if you want offline dev.
- [ ] Usecase(s).
- [ ] BLoC (4-state shape) + page through `AsyncView`.
- [ ] Register everything in `core/di/injection.dart`.
- [ ] Add the route to `core/routing/`.
- [ ] Tests (model round-trip, bloc sequence) — Phase 8.
