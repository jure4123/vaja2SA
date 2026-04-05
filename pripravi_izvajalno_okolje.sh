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
git clone "$GIT_URL"
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
if [ "$TYPE" == "python" ]; then

cat <<EOF > Dockerfile
FROM python:3.10
WORKDIR /app
COPY . /app
CMD ["python", "run.py"]
EOF

elif [ "$TYPE" == "bash" ]; then

cat <<EOF > Dockerfile
FROM ubuntu:latest
WORKDIR /app
COPY . /app
RUN chmod +x run.sh
CMD ["./run.sh"]
EOF

else

cat <<EOF > Dockerfile
FROM ubuntu:latest
CMD ["sleep", "infinity"]
EOF

fi

# build
docker build -t moja_slika .

# run
docker run -d moja_slika

echo "Konec."