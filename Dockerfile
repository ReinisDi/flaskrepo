FROM python:3.8-slim

RUN apt-get update -y
RUN apt-get install python3-pip -y
RUN apt-get install gunicorn -y

# set current env
#ENV HOME /app
WORKDIR /app
#ENV PATH="/app/.local/bin:${PATH}"

# set app config option
#ENV FLASK_ENV=production

# set argument vars in docker-run command
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION


ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION


# Avoid cache purge by adding requirements first
ADD ./requirements.txt ./requirements.txt

RUN pip3 install -r requirements.txt

# Add the rest of the files
COPY . /app
WORKDIR /app

# start web server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app", "--workers=5"]
