# openshift-apache-server

Template for running a apache on a container based on alpine linux/openshift/docker.

### Installation

You need oc (https://github.com/openshift/origin/releases) locally installed:

create a new project (change to your whishes) or add this to your existing project

Deploy (externally)

```sh
oc new-app https://github.com/openshift-apache-webserver.git --name apache-webserver
```

Deploy (weepee internally)
add to Your buildconfig
```yaml
spec:
  strategy:
    dockerStrategy:
      from:
        kind: ImageStreamTag
        name: apache-webserver:latest
        namespace: boc-registry
    type: Docker
```
use in your Dockerfile
```sh
FROM boc-registry/apache-webserver

# Your app
ADD app /app
```

#### Route.yml

Create route for development and testing

```sh
curl https://raw.githubusercontent.com/ure/openshift-apache-webserver/master/Route.yaml | oc create -f -
```