# Container that reads an analog input from an MCP3008 (over SPI0) and sets
# the brightness accordingly for an LED on board pin 32 using PWM.

DOCKERHUB_ID:=ibmosquito
NAME:="jetson-mcp3008"
VERSION:="1.0.0"

defaut: build run

build:
	docker build -t $(DOCKERHUB_ID)/$(NAME):$(VERSION) .

dev: stop
	docker run -it -v `pwd`:/outside \
	  --privileged \
	  --name ${NAME} \
	  $(DOCKERHUB_ID)/$(NAME):$(VERSION) /bin/bash

run: stop
	docker run -d \
	  --privileged \
	  --restart unless-stopped \
	  --name ${NAME} \
	  $(DOCKERHUB_ID)/$(NAME):$(VERSION)

push:
	docker push $(DOCKERHUB_ID)/$(NAME):$(VERSION) 

stop:
	@docker rm -f ${NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKERHUB_ID)/$(NAME):$(VERSION) >/dev/null 2>&1 || :

.PHONY: build dev run push stop clean

