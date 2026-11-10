// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteApi)
final remoteApiProvider = RemoteApiProvider._();

final class RemoteApiProvider
    extends $FunctionalProvider<RemoteApi, RemoteApi, RemoteApi>
    with $Provider<RemoteApi> {
  RemoteApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteApiHash();

  @$internal
  @override
  $ProviderElement<RemoteApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteApi create(Ref ref) {
    return remoteApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteApi>(value),
    );
  }
}

String _$remoteApiHash() => r'9c8cfac0e53337b8308fedf9ed23278011529ace';
