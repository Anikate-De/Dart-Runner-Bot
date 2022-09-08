FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline

# RUN dart compile exe bin/dart_runner_bot.dart -o bin/dart_runner_bot

# # Build minimal serving image from AOT-compiled `/server` and required system
# # libraries and configuration files stored in `/runtime/` from the build stage.
# FROM scratch
# COPY --from=build /runtime/ /
# COPY --from=build /app/bin/dart_runner_bot /app/bin/

# CMD [ "/app/bin/dart_runner_bot" ]

CMD [ "dart", "bin/dart_runner_bot.dart" ]