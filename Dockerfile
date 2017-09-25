FROM openjdk:8-jdk-alpine
MAINTAINER David Gaulin

RUN mkdir /packages

COPY packages/ /packages/

RUN ls /packages/

RUN truncate -s 0 /etc/apk/repositories 
RUN rm -f /var/cache/apk/* 
RUN apk add --allow-untrusted --force /packages/* 
RUN adduser -D apache 
RUN mkdir /app 
RUN chown -R apache:apache /app 
RUN mkdir -p /run/apache2/ 
RUN chmod a+rwx /run/apache2/

# Apache config
ADD httpd.conf /etc/apache2/httpd.conf

# Run scripts
RUN mkdir /scripts
ADD scripts/run.sh /scripts/run.sh
RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
chmod -R 755 /scripts

# Your app
ADD app/index.html /app/index.html

# Exposed Port
EXPOSE 8080

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Alpine linux based Apache container" \
      io.k8s.display-name="alpine apache" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,apache" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="false"
