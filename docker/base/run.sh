CONTAINER=test_synthcloud
docker rm $CONTAINER
docker run -d -P --name $CONTAINER synth-cloud
