run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.json
run-prod:
	flutter run --flavor prod --dart-define-from-file=env/prod.json
	
build-play-store:
	flutter build appbundle --flavor prod --release --dart-define-from-file=env/prod.json
gen-app-icons:
	dart run flutter_launcher_icons
