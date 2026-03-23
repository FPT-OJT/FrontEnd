run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.json
run-prod:
	flutter run --flavor prod --dart-define-from-file=env/prod.json
splash:
	dart run flutter_native_splash:create
gen-code:
	flutter pub run build_runner build --delete-conflicting-outputs
gen-app-icons:
	dart run flutter_launcher_icons
gen-code:
	flutter pub run build_runner build --delete-conflicting-outputs
pre-built-prod:
	dart scripts/pre_built.dart prod
pre-built-dev:
	dart scripts/pre_built.dart dev
build-play-store: splash gen-app-icons gen-code pre-built-prod
	flutter build appbundle --flavor prod --release --dart-define-from-file=env/prod.json
build-release: splash gen-app-icons gen-code pre-built-prod
	flutter build apk --flavor prod --release --dart-define-from-file=env/prod.json

