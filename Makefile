test:
	pytest

install:
	pip install poetry
	poetry install --no-root

dev-setup:
	make install
	pre-commit install

clean:
	rm -rf ./data/*
	rm -rf ./outputs/*

run:
	# DATA_DIR='$(pwd)/data' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
	DATA_DIR='./data' OUTPUT_DIR='./outputs' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
	# DATA_DIR='./data' poetry run python main.py train_v2 -t=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip

run_cid:
	DATA_DIR='./data'  OUTPUT_DIR='./outputs' poetry run python main.py train_v2 -t=linear-regression.ipynb -i=Qme1HnwLHVzRxra7mT5gRkG7WbyE4FhnGFn9inETSj33Hw

dc:
	docker-compose down -v --rmi all
	docker-compose up -d

	# docker-compose down
	# docker-compose up --force-recreate

it:
	docker run -it --entrypoint /bin/bash app

docker:
	docker build -t app .

docker-run:
	docker run app -it -t=headbrain.ipynb -i=/app/samples/kaggle/inputs/headbrain.zip

	# docker run app -it 'linear-regression.ipynb' '/app/samples/sample_v3/sample_v3.zip'

docker-build:
	docker build  --build-arg cmd=train_v1 -t decenter.ai.v1 .
	docker build  --build-arg cmd=train_v2 -t decenter.ai.v2 .

docker-clean:
	docker system prune -f

gh:
	git pull
	docker build -t app .
	docker run -it app

ghcr:
	docker run ghcr.io/decenter-ai/compute.decenter-ai:main
	docker run ghcr.io/nasfame/bacalhau-fvm-nft:latest python main.py --p 'Hiro'


.PHONY: docker docker-build docker-clean clean gh ghcr it run dc test

lily:
	cp lilypad_module.json lilypad_module.json.tmpl


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
	 -i https://gateway.lighthouse.storage/ipfs/QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/outputs/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
	  -- /app/venv/bin/python main.py train_v2 -t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip


sample_b:
	make sample_bacalhau

lily_sample:
	lilypad run sdxl:v0.9-lilypad1 "an astronaut riding on a unicorn"

lily_sample_2:
	lilypad run sdxl:v0.9-lilypad1 '{"prompt": "an astronaut riding on a unicorn", "seed": 9}'
	# Since modules are deterministic, running this command with the same text prompt will produce the same image, since the same seed is also used (the default seed is 0).
	# Hack: pass in different seeds
	# TODO: enter https://ipfs.io/ipfs/<resultCID> or ipfs://<resultCID>
	# doc: https://docs.lilypadnetwork.org/lilypad-v1-examples/stable-diffusion


lily_decenter:
	lilypad run github.com/DeCenter-AI/compute.decenter-ai:main '{"train_cmd": "train_v2", "t": "linear-regression.ipynb", "i": "/app/samples/sample_v3/sample_v3.zip", "seed": 1}'
	#lilypad run decenter:main '{"train_cmd": "train_v2", "t": "linear-regression.ipynb", "i": "/app/samples/sample_v3/sample_v3.zip", "seed": 1}'


lily_v1_sample:
# lilypad-modicium
# https://github.com/bacalhau-project/lilypad-modicum
	lilypad run --template stable_diffusion:v0.0.1 --params "blue frog"


lily_v1_decenter:
	# commented ones don't work
	lilypad run --template github.com/DeCenter-AI/compute.decenter-ai:main '{"train_cmd": "train_v2", "t": "linear-regression.ipynb", "i": "/app/samples/sample_v3/sample_v3.zip", "seed": 1}'
	lilypad run --template decenter:main  '{"train_cmd": "train_v2", "t": "linear-regression.ipynb", "i": "/app/samples/sample_v3/sample_v3.zip", "seed": 1}'
	lilypad run --template ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main  '{"train_cmd": "train_v2", "t": "linear-regression.ipynb", "i": "/app/samples/sample_v3/sample_v3.zip", "seed": 1}'

lilypad_v2:
	# lilypad run cowsay:v0.0.1 -i Message="moo"
	# lilypad run github.com/DeCenter-AI/compute.decenter-ai:v1.6.0-alpha
	# lilypad run github.com/DeCenter-AI/compute.decenter-ai:feat/lilypad-module-v2
	# lilypad run github.com/DeCenter-AI/compute.decenter-ai:7eca4ccf1e01a746447cf62a268a7be6c600514c -i trainScript=headbrain.ipynb -i inputCid=Qme1HnwLHVzRxra7mT5gRkG7WbyE4FhnGFn9inETSj33Hw
  # commit doesn't work
	lilypad run github.com/DeCenter-AI/compute.decenter-ai:v1.7.0-beta.2 -i trainScript=headbrain.ipynb -i inputCid=Qme1HnwLHVzRxra7mT5gRkG7WbyE4FhnGFn9inETSj33Hw

	# git tag -a v1.6.0-beta.1 -m "just rolled out lilypad v2 module"
	# git tag -a v1.6.0-beta.2 -m "just rolled out lilypad v2 module" && git push --tags




# sh start.sh train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
