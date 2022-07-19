
### first stage builder
ARG   DOCKER_REGISTRY
FROM  $DOCKER_REGISTRY/node:14-alpine as builder

LABEL version="0.1.1"
LABEL company="Company name"
LABEL maintainer="myname@company.com"
LABEL description="script build via yarn and transfer result for nginx running port 80" 

ENV   TargetDir=/app

RUN   mkdir -p ${TargetDir}
COPY  ./ ${TargetDir}   # copy to /app
WORKDIR  ${TargetDir}   # workdir /app

RUN   apk add --no-cache yarn && yarn install && yarn build  


### result stage nginx
FROM  $DOCKER_REGISTRY/nginx:1.21.6

COPY  ./nginx.conf /etc/nginx/nginx.conf
RUN   rm -rf /usr/share/nginx/html
COPY  --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

ENTRYPOINT [ "nginx" ]
CMD [ "-g", "daemon off;" ]