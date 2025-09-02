FROM python:3.9-slim-buster

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

RUN addgroup --system app && adduser --system --ingroup app app

COPY app /app

USER app
EXPOSE 7894

CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:7894", "hello:app"]
