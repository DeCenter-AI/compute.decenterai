docker-build:
	docker build -t decenter.ai .

docker-build-v1:
	docker build  --build-arg cmd=train_v1 -t decenter.ai.v1 .

docker-build-v2:
	docker build  --build-arg cmd=train_v2 -t decenter.ai.v2 .

.PHONY: docker-build docker-build-v1 docker-build-v2 clean gh it run dc test test_docker test_docker1 test_docker2

clean:
	docker system prune -f      

gh:
	git pull 
	docker build -t app . 
	docker run app

dc:
	docker-compose down -v --rmi all
	docker-compose up -d

	# docker-compose down
	# docker-compose up --force-recreate

it:
	docker run -it --entrypoint /bin/bash app

run: 
	# DATA_DIR='$(pwd)/data' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
	DATA_DIR='./data' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip

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

test:
	pytest

run_ghcr:
	 docker run ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute:sha-6c846a0
	 docker run ghcr.io/decenter-ai/compute.decenter-ai:main

sample_bacalhau:
	bacalhau docker run ubuntu echo Hello World

sample_b_1:
	bacalhau docker run --gpu 1 ghcr.io/bacalhau-project/examples/stable-diffusion-gpu:0.0.1 -- python main.py --o ./outputs --p "cod swimming through data"


sample_b_2:
	bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main -- /app/venv/bin/python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip

sample_b_3:
	# bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main -- --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
	# bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main '-t=linear-regression.ipynb' '-i=/app/samples/sample_v3/sample_v3.zip'
	bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main '--train_script=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip'

sample_b_4:
	bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main

sample_b:
	make sample_bacalhau

# sh start.sh train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip