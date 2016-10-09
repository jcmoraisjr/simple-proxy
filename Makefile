REPO=quay.io/jcmoraisjr/simple-proxy
TAG=latest
NAME=simple-proxy
build:
	docker build -t $(REPO):$(TAG) .
run:
	docker stop $(NAME) || :
	docker rm $(NAME) || :
	docker run -d -p 1936:1936 -p $(PORT):$(PORT) -e PROXY_PORT=$(PORT) -e SERVER_LIST=$(SERVERS) --name $(NAME) $(REPO):$(TAG)
