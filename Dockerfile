#test activate actions
# Basic dockerfile
FROM python:3.11-slim

RUN apt-get update
#ENV FLASK_ENV="docker"
ENV FLASK_APP=webapp.py

EXPOSE 5000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /hello_app
COPY . /hello_app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /hello_app
USER appuser

# During debugging, this entry point will be overridden.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "hello_app.webapp:app"]
#CMD ["python", "-m" , "flask", "run", "--host=0.0.0.0:5000"]
