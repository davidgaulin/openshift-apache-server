FROM openjdk:8-jdk-alpine
MAINTAINER David Gaulin

RUN mkdir /packages

ADD packages/apache2-2.4.27-r0.apk /packages/apache2-2.4.27-r0.apk
ADD packages/bash-4.3.48-r1.apk /packages/bash-4.3.48-r1.apk
ADD packages/curl-7.55.0-r0.apk /packages/curl-7.55.0-r0.apk

RUN ls -l /packages > /packages/ls

RUN apk add --allow-unstrusted /packages/apache2-2.4.27-r0.apk /packages/bash-4.3.48-r1.apk /packages/curl-7.55.0-r0.apk 

RUN rm -f /var/cache/apk/* && \
mkdir /app && chown -R apache:apache /app && \
mkdir /run/apache2/ && \
chmod a+rwx /run/apache2/

# Apache config
ADD httpd.conf /etc/apache2/httpd.conf

# Run scripts
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
