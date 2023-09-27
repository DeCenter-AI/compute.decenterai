# Decenter Compute

## Python

```
 python main.py train_v2 "linear-regression.ipynb" "/app/samples/sample_v3/sample_v3.zip"
 DATA_DIR='./data' poetry run python main.py train_v2 --train_script=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
```

## Docker

```
  docker run app '-t=linear-regression.ipynb' '-i=/app/samples/sample_v3/sample_v3.zip'

  docker run app 'linear-regression.ipynb' '/app/samples/sample_v3/sample_v3.zip'

```

## GHCR

```
  docker run ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute:sha-6c846a0
  docker run ghcr.io/decenter-ai/compute.decenter-ai:main

```

## Bacalhau

```
bacalhau docker run --gpu 1 ghcr.io/decenter-ai/compute.decenter-ai:main
```

Download by default

```
bacalhau docker run --download ghcr.io/decenter-ai/compute.decenter-ai:main -- \
  /app/venv/bin/python main.py train_v2 -t=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip
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

