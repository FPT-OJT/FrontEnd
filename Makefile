run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.json
run-prod:
	flutter run --flavor prod --dart-define-from-file=env/prod.json
make-native-splash:
	dart run flutter_native_splash:create
build-play-store: make-native-splash
	flutter build appbundle --flavor prod --release --dart-define-from-file=env/prod.json
