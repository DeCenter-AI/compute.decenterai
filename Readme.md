# Decenter Compute

## Python

```
 python main.py train_v2 "linear-regression.ipynb" "/app/samples/sample_v3/sample_v3.zip"
```

#### Venv

```
 venv/bin/python main.py train_v2 "linear-regression.ipynb" "/app/samples/sample_v3/sample_v3.zip"

 venv/bin/python -m jupyter nbconvert --execute --to html  /app/samples/sample_v3/linear-regression.ipynb
```

## Poetry

```
 DATA_DIR='./data' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
```

## Docker

```
  docker run app '-t=linear-regression.ipynb' '-i=/app/samples/sample_v3/sample_v3.zip'

  docker run app -it 'linear-regression.ipynb' '/app/samples/sample_v3/sample_v3.zip'

  docker run -it app '-t=headbrain.ipynb' '-i=/app/samples/kaggle/inputs/headbrain.zip'

```

## GHCR

```
  docker run ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute:sha-6c846a0
  docker run ghcr.io/decenter-ai/compute.decenter-ai:main

```

```
docker run -it ghcr.io/decenter-ai/compute.decenter-ai:main -t=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip

```

## Bacalhau

<!-- 
	bacalhau docker run --gpu 1 ghcr.io/bacalhau-project/examples/stable-diffusion-gpu:0.0.1 -- python main.py --o ./outputs --p "cod swimming through data"
 -->

```
bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main
```

Download by default

```
bacalhau docker run --download ghcr.io/decenter-ai/compute.decenter-ai:main -- /app/venv/bin/python main.py train_v2 -t=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip
```

With Output folder mount

```
bacalhau docker run --download  -o ./outputs:/outputs  ghcr.io/decenter-ai/compute.decenter-ai:main -- \
  /app/venv/bin/python main.py train_v2 -t=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip
```

```
bacalhau docker run \
  -i ipfs://QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/data/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
   -- /app/venv/bin/python main.py train_v2 -t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip
```

## Lilypad Module

```

```

