run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.json
run-prod:
	flutter run --flavor prod --dart-define-from-file=env/prod.json
