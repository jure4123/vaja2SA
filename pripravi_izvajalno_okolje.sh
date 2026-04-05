#!/bin/bash

# preveri argument
if [ -z "$1" ]; then
  echo "Uporaba: $0 <git_url>"
  exit 1
fi

GIT_URL=$1
REPO_NAME=$(basename "$GIT_URL" .git)

# kloniranje
echo "Kloniram..."

rm -rf "$REPO_NAME"

if ! git clone "$GIT_URL"; then
  echo "Napaka pri kloniranju!"
  exit 1
fi

cd "$REPO_NAME" || exit 1

# zaznavanje aplikacije
if [ -f "run.py" ]; then
  TYPE="python"
elif [ -f "run.sh" ]; then
  TYPE="bash"
else
  TYPE="none"
fi

echo "Tip: $TYPE"

# Dockerfile
if [ "$TYPE" = "python" ]; then

cat <<EOF > Dockerfile
FROM python:3.10

WORKDIR /app

COPY . /app

RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

CMD ["python", "run.py"]
EOF

elif [ "$TYPE" = "bash" ]; then

cat <<EOF > Dockerfile
FROM ubuntu:22.04

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y bash && chmod +x run.sh

CMD ["./run.sh"]
EOF

else

cat <<EOF > Dockerfile
FROM ubuntu:22.04

WORKDIR /app

CMD ["sleep", "infinity"]
EOF

fi

# build
IMAGE_NAME="moja_slika"

echo "Gradim Docker sliko..."

if ! docker build -t "$IMAGE_NAME" .; then
  echo "Napaka pri buildanju Docker slike!"
  exit 1
fi

# run
echo "Zaganjam kontejner..."

if ! docker run -d --name moja_aplikacija "$IMAGE_NAME"; then
  echo "Napaka pri zagonu kontejnerja!"
  exit 1
fi

echo "Konec."