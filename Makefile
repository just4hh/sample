### version 0.1.1

# sonar_check:  @ Check quality code on sonarqube
.PHONY sonar_check
sonar_check:
	docker run --rm -e SONAR_HOST_URL="${sonar_host_url}"  -e SONAR_LOGIN="${sonar_token}" -v "$(pwd):/usr/src"   --user 997:997 ${docker_registry_https}/sonarsource/sonar-scanner-cli:latest

# sonar-check:  @ Clean check on sonarqube
.PHONY sonar_clean
sonar_clean:
    rm -rf "$(pwd)/.scannerwork"

#test_hadolint: @ Check Dockerfile errors
.PHONY test_hadolint
test_hadolint:
	docker run --rm  ${docker_registry_https}/hadolint/hadolint:latest-alpine < $dockerfilename

#git_clone_endpoints: @ Get endpoints for project
.PHONY git_clone_endpoints
git_clone_endpoints:
	git clone -b feature git@gitlab.server:endpoints/endpoints.git

#build:  @ docker build image
.PHONY build
build:
	docker build --pull -t  ${docker_registry_https}/${name}:$CI_COMMIT_BRANCH  --build-arg DOCKER_REGISTRY=${docker_registry_https} -f ${dockerfilename} .

#push:  @ push docker image to docker registry
.PHONY push
push:
    docker push ${docker_registry_https}/${name}:$CI_COMMIT_BRANCH

# deploy:  @ deploy docker image on target serever
.PHONY deploy deploy.clean deploy.new

deploy: deploy.clean deploy.new

# deploy.clean @ kill old version & remove old version image 
deploy.clean:
	ssh  ${username}@${target_server}  " docker rm -f ${name} || true "
    ssh  ${username}@${target_server}  " docker rmi ${docker_registry_https}/${name}:$CI_COMMIT_BRANCH || true "

# deploy.new @ deploy new vesrion application
deploy.new:
    ssh  ${username}@${target_server}  " docker run  -d --name ${name} -v  /content:/usr/share/nginx/html/content --restart=always  -p ${port_public}:${port_internal} --log-driver=fluentd --log-opt fluentd-address=${log_server} --log-opt tag="${name}-${target_server}"  ${docker_registry_https}/${name}:$CI_COMMIT_BRANCH"

# clean: @ clean gitlab runner
.PHONY clean
clean:
	rm -rf ./*
	docker rmi ${docker_registry_https}/${name}:$CI_COMMIT_BRANCH || true


