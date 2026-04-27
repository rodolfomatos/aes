#!/bin/bash
set -e

# AES Language Detection
# Sets AES_LANGUAGE, AES_LINT, AES_TEST, AES_FORMAT, AES_BUILD, AES_RUN env vars

echo "🔍 Detecting project language..."

if [ -f "package.json" ]; then
  export AES_LANGUAGE="javascript"
  export AES_LINT="npx eslint"
  export AES_TEST="jest"
  export AES_FORMAT="prettier --write"
  export AES_BUILD="npm run build"
  export AES_RUN="npm start"
  echo "✅ Detected: JavaScript/TypeScript (Node.js)"

elif [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "setup.cfg" ]; then
  export AES_LANGUAGE="python"
  export AES_LINT="ruff check"
  export AES_TEST="pytest"
  export AES_FORMAT="black"
  export AES_BUILD="python -m build"
  export AES_RUN="python -m src"
  echo "✅ Detected: Python"

elif [ -f "go.mod" ]; then
  export AES_LANGUAGE="go"
  export AES_LINT="go vet"
  export AES_TEST="go test"
  export AES_FORMAT="gofmt -w"
  export AES_BUILD="go build"
  export AES_RUN="go run"
  echo "✅ Detected: Go"

elif [ -f "Cargo.toml" ]; then
  export AES_LANGUAGE="rust"
  export AES_LINT="cargo clippy"
  export AES_TEST="cargo test"
  export AES_FORMAT="cargo fmt --all"
  export AES_BUILD="cargo build"
  export AES_RUN="cargo run"
  echo "✅ Detected: Rust"

elif [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  export AES_LANGUAGE="java"
  export AES_LINT="./gradlew check"
  export AES_TEST="./gradlew test"
  export AES_FORMAT="google-java-format -i"
  export AES_BUILD="./gradlew build"
  export AES_RUN="./gradlew run"
  echo "✅ Detected: Java (Spring/Gradle)"

elif [ -f "composer.json" ]; then
  export AES_LANGUAGE="php"
  export AES_LINT="php -l"
  export AES_TEST="phpunit"
  export AES_FORMAT="php-cs-fixer fix"
  export AES_BUILD="composer install"
  export AES_RUN="php -S localhost:8000"
  echo "✅ Detected: PHP (Laravel)"

elif [ -f "pubspec.yaml" ]; then
  export AES_LANGUAGE="flutter"
  export AES_LINT="flutter analyze"
  export AES_TEST="flutter test"
  export AES_FORMAT="dart format ."
  export AES_BUILD="flutter build apk"
  export AES_RUN="flutter run"
  echo "✅ Detected: Flutter (Dart)"

else
  echo "⚠️  Unknown language. Please configure manually in Makefile or add detection rule."
  export AES_LANGUAGE="unknown"
  export AES_LINT="echo 'No linter configured'"
  export AES_TEST="echo 'No tests configured'"
  export AES_FORMAT="echo 'No formatter configured'"
  export AES_BUILD="echo 'No build configured'"
  export AES_RUN="echo 'No run command configured'"
fi

# Export to subshells
export AES_LANGUAGE AES_LINT AES_TEST AES_FORMAT AES_BUILD AES_RUN
