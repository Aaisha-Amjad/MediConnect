FROM python:3.11-slim

WORKDIR /app

COPY app.py .

RUN pip install flask

EXPOSE 5003

CMD ["python", "app.py"]
