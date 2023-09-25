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
	# DATA_DIR='./data' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
	DATA_DIR='./data' poetry run python main.py train_v2 -t=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip

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

sample_b_5:
	bacalhau docker run ghcr.io/decenter-ai/compute.decenter-ai:main -- '--train_script=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip'

sample_b_6:
# FIXME: doens't work need to override entrypoint as 
	bacalhau docker run \
	 -i ipfs://QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/data/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
	  -- '-t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip'
# TODO: put in the ipfs swarm nodes of lighthouse: 
#  --ipfs-swarm-addrs=(default "/ip4/35.245.115.191/tcp/1235/p2p/QmdZQ7ZbhnvWY1J12XYKGHApJ6aufKyLNSvf8jZBrBaAVL,/ip4/35.245.61.251/tcp/1235/p2p/QmXaXu9N5GNe
# tatsvwnTfQqNtSeKAD6uCmarbh3LMRYAcF,/ip4/35.245.251.239/tcp/1235/p2p/QmYgxZiySj3MRkwLSL4X2MF5F9f2PMhAE3LV49XkfNL1o3")

sample_b_6_local:
		bacalhau docker run --local \
		-i ipfs://QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/data/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
		 -- '-t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip'

sample_b_7:
	bacalhau docker run \
	 --download \
	 -o ./outputs:/outputs \
	 -o ./data:/data \
	 -i ipfs://QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/data/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
	  -- '-t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip'


sample_b_8_https:
# TOOD: working 
	bacalhau docker run \
	 --download \
	 -o ./outputs:/outputs \
	 -i https://gateway.lighthouse.storage/ipfs/QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/data/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
	  -- /app/venv/bin/python main.py train_v2 -t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip



sample_b:
	make sample_bacalhau

# sh start.sh train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip