# upload-chart-to-artifactory

This template will help to push artifact to artifactory if its now exists at the given artifactory path by downloading it from external source.

Also we can use it in the dockerfile where sometime we requires different versions of some packages and artifacts to use in docker file.

It will keeps our artifactory updated with all the artifacts and versions we are using regularly.

1. Refer the sample dockerfile in the repo which download terraform from artifactory if available and if its not available then it download artifact from the given external source URL and upload it to artifactory.

2. Building docker image.

while building docker image we need to pass Artifactory url as URL , artifactory username as USERNAME and artifactory password as PASSWORD.

    docker build -t terraform-alpine . --build-arg URL="https://<ARTIFACTORY-URl>/artifactory<REPo-NAME> --build-arg USERNAME=<USERNAME> --build-arg=<PASSWORD>

