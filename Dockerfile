FROM python:slim

WORKDIR /code
COPY . .

RUN apt-get update && apt-get install -y g++

RUN g++ main.cpp radix.cpp -o program

RUN pip install -r requirements.txt

CMD ["python", "run.py"]