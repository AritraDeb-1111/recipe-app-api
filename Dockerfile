# alpine3 is the lightweight version of linux ideal for running docker container
FROM python:3.9-alpine3.13
LABEL maintainer="aritradeb"

# We don't want to buffer the output, the output from python will be printed directly to the console, which prevents
# any delays of messages getting from our python running application to the screen so we can see the logs immediately
ENV PYTHONBUFFERED 1

COPY ./req.txt /tmp/req.txt
COPY ./req.dev.txt /tmp/req.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# WE are overriding this inside our docker-compose file 
ARG DEV=false 
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/req.txt && \
    # Here comes the shell code
    if [ "$DEV" = "true" ]; \
        then /py/bin/pip install -r /tmp/req.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    #If we don't add this our default user would be root
    #we don't want to set any password and we also don't want to create a home directory for the user and we specify the user
        -D \   
        -H \
        django-user

# Updating the path env variable inside the image
ENV PATH="/py/bin:$PATH"
# We swicthed root user to django-user
USER django-user