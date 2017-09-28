FROM alpine:3.6
MAINTAINER David Gaulin

RUN mkdir -p /packages/x86_64
COPY packages/ /packages/x86_64/
RUN echo '' > /etc/apk/repositories

RUN apk add --no-cache /packages/x86_64/apache2-2.4.27-r1.apk \
/packages/x86_64/apr-util-1.5.4-r3.apk \
/packages/x86_64/apr-1.5.2-r1.apk \
/packages/x86_64/libuuid-2.28.2-r2.apk \
/packages/x86_64/expat-2.2.0-r1.apk \
/packages/x86_64/pcre-8.41-r0.apk \
/packages/x86_64/apache2-proxy-2.4.27-r1.apk

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

# Apache config
ADD httpd.conf /etc/apache2/httpd.conf

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
