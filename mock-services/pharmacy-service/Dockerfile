FROM python:3.11-slim
WORKDIR /app
RUN pip install flask flask-cors
COPY app.py .
EXPOSE 5003
CMD ["python", "app.py"]