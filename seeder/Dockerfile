# seeder/Dockerfile
FROM python:3.12-alpine

# dependencias para psycopg2 y argon2
RUN apk add --no-cache build-base libffi-dev musl-dev postgresql-dev

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY seed.py .
# opcional: si quieres copiar fixtures al contenedor
# COPY ../test/fixtures /app/fixtures

CMD ["python", "seed.py"]
