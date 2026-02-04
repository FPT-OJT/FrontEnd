run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.json
run-prod:
	flutter run --flavor prod --dart-define-from-file=env/prod.json
splash:
	dart run flutter_native_splash:create
build-play-store: splash
	flutter build appbundle --flavor prod --release --dart-define-from-file=env/prod.json
gen-app-icons:
	dart run flutter_launcher_icons
gen-code:
	flutter pub run build_runner build --delete-conflicting-outputs