docker-build:
	docker build -t decenter.ai .

docker-build-v1:
	docker build  --build-arg cmd=train_v1 -t decenter.ai.v1 .

docker-build-v2:
	docker build  --build-arg cmd=train_v2 -t decenter.ai.v2 .

.PHONY: docker-build docker-build-v1 docker-build-v2 clean gh it run dc

clean:
	docker system prune -f      

gh:
	git pull 
	docker build -t app . 
	docker run app

dc:
	docker-compose down
	docker-compose up --force-recreate

it:
	docker run -it --entrypoint /bin/bash app

run: 
	poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip

install:
	pip install poetry
	poetry install --no-root
	
example_ref:
	docker run ghcr.io/nasfame/bacalhau-fvm-nft:latest python main.py --p 'Hiro'

sample_1:
	python main.py train_v2 "linear-regression.ipynb" "/app/samples/sample_v3/sample_v3.zip"

test_docker:
	 docker run app 'linear-regression.ipynb' '/app/samples/sample_v3/sample_v3.zip'

test_docker1:
	 docker run app '-t=linear-regression.ipynb' '-i=/app/samples/sample_v3/sample_v3.zip'

test_docker2:
	 docker run app '-t=linear-regression1.ipynb' '-i=/app/samples/sample_v3/sample_v3.zip'

# sh start.sh train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip