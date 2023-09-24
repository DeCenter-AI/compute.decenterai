docker-build:
	docker build -t decenter.ai .

docker-build-v1:
	docker build  --build-arg cmd=train_v1 -t decenter.ai.v1 .

docker-build-v2:
	docker build  --build-arg cmd=train_v2 -t decenter.ai.v2 .

.PHONY: docker-build docker-build-v1 docker-build-v2 clean gh it

clean:
	docker system prune -f      

gh:
	git pull && docker build -t app . && docker run app $@


it:
	docker run -it --entrypoint /bin/bash app