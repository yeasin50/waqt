install:
	flutter clean && \
	flutter build apk && \
	flutter install


icon:
	dart run flutter_launcher_icons
