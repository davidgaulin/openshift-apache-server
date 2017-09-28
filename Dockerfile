FROM alpine:3.6
MAINTAINER David Gaulin

RUN mkdir -p /packages/x86_64
COPY packages/ /packages/x86_64/
RUN echo '' > /etc/apk/repositories
#RUN echo '/packages/' >> /etc/apk/repositories
#RUN apk index
#RUN ls /packages/x86_64/
#RUN ls /packages/
#RUN cat /etc/apk/repositories
#RUN apk update
#RUN apk search -v 

RUN apk add --no-cache /packages/x86_64/apache2-2.4.27-r1.apk /packages/x86_64/apr-util-1.5.4-r3.apk /packages/x86_64/apr-1.5.2-r1.apk /packages/x86_64/libuuid-2.28.2-r2.apk

# RUN adduser -D apache 
# RUN adduser -D apache 
RUN mkdir /app 
RUN chown -R apache:apache /app 
RUN mkdir -p /run/apache2/ 
RUN chmod a+rwx /run/apache2/

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

LABEL io.k8s.description="Alpine linux based Apache container" \
      io.k8s.display-name="alpine apache" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,apache" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="false"

#RUN mkdir /packages

#COPY packages/ /packages/

#RUN ls /packages/

#USER root 
#RUN truncate -s 0 /etc/apk/repositories 
#RUN rm -f /var/cache/apk/* 
#USER root 
#RUN apk add --allow-untrusted --force /packages/bash-4.3.48-r1.apk
#RUN echo $?
#RUN apk add --allow-untrusted --force /packages/apr-1.5.2-r1.apk
#RUN apk add --allow-untrusted --force /packages/apr-util-1.5.4-r3.apk
#RUN apk add --allow-untrusted --force /packages/curl-7.55.0-r0.apk
#RUN echo $?
#RUN apk add --allow-untrusted --force /packages/expat-2.2.0-r1.apk
#RUN apk add --allow-untrusted --force /packages/openrc-0.24.1-r2.apk
#RUN apk add --allow-untrusted --force /packages/pcre-8.41-r0.apk
#RUN apk add --allow-untrusted --force /packages/busybox-1.26.2-r6.apk

#RUN apk add --allow-untrusted --force /packages/apache2-2.4.27-r1.apk
#RUN apk info 
#RUN echo $?

#RUN adduser -D apache 
#RUN mkdir /app 
#RUN chown -R apache:apache /app 
#RUN mkdir -p /run/apache2/ 
#RUN chmod a+rwx /run/apache2/

# Apache config
#ADD httpd.conf /etc/apache2/httpd.conf

# Run scripts
#RUN mkdir /scripts
#ADD scripts/run.sh /scripts/run.sh
#RUN mkdir /scripts/pre-exec.d && \
#mkdir /scripts/pre-init.d && \
#chmod -R 755 /scripts

# Your app
#ADD app/index.html /app/index.html

# Exposed Port
#EXPOSE 8080

# VOLUME /app
#WORKDIR /app

#ENTRYPOINT ["/scripts/run.sh"]

# Set labels used in OpenShift to describe the builder images
#LABEL io.k8s.description="Alpine linux based Apache container" \
 #     io.k8s.display-name="alpine apache" \
  #    io.openshift.expose-services="8080:http" \
   #   io.openshift.tags="builder,html,apache" \
    #  io.openshift.min-memory="1Gi" \
     # io.openshift.min-cpu="1" \
      #io.openshift.non-scalable="false"
