# Decenter Compute

IPFS Gateway:
<pre>
In Brave: ipfs://[CID]
In Other Browsers: www.w3s.link/ipfs/[CID] or www.ipfs.io/ipfs/[CID]
</pre>

Lilypad:

1. v0: has smart contracts with bacalhau spec
2. v1: lilypad modules, smart contracts that can only run the lilypad modules. But lilypad modules needs to approved via PR.
Testnet: Lalechuza
3. v2: only module support. But very extensive support for modules via github repos.
Testnet: Aurora

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
  docker run -it app '-t=headbrain.ipynb' '-i=/app/samples/kaggle/inputs/headbrain.zip'

  docker run -it app linear-regression.ipynb /app/samples/sample_v3/sample_v3.zip
  docker run -it app "linear-regression.ipynb" "/app/samples/sample_v3/sample_v3.zip"
```

## GHCR

```
  docker run ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute:main
  docker run ghcr.io/decenter-ai/compute.decenter-ai:main
  docker run ghcr.io/decenter-ai/compute:main
```

```
docker run -it ghcr.io/decenter-ai/compute.decenter-ai:main -t=linear-regression.ipynb -i=samples/sample_v3/sample_v3.zip
```

## Bacalhau

Detailed live doc available over [here](https://colab.research.google.com/drive/16pVoRVdQAd4Yh73JSMJMtYG-rLEjTgWw#scrollTo=IzR8eWCh_TJN)

<!--
	bacalhau docker run --gpu 1 ghcr.io/bacalhau-project/examples/stable-diffusion-gpu:0.0.1 -- python main.py --o ./outputs --p "cod swimming through data"
 -->

```
bacalhau docker run ghcr.io/decenter-ai/compute:main
```

#### Download by default

```working
bacalhau docker run --download \
  --id-only \
  --wait \
  --gpu 0 \
  ghcr.io/decenter-ai/compute:main -- \
  -t=headbrain.ipynb -i=/app/samples/kaggle/inputs/headbrain.zip
```

```working
bacalhau docker run --download \
  --id-only \
  --wait \
  --gpu 0 \
  ghcr.io/decenter-ai/compute:main -- \
  headbrain.ipynb /app/samples/kaggle/inputs/headbrain.zip
```

#### With Output folder mount

```untested
bacalhau docker run --download  -o ./outputs:/outputs  ghcr.io/decenter-ai/compute.decenter-ai:main -- \
  /app/venv/bin/python main.py train_v2 -t=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip
```

#### Input

##### Lighthouse

```
bacalhau docker run --download \
  --id-only \
  --timeout 3600 \
  --wait-timeout-secs 3600 \
  --wait \
  --gpu 0 \
  --input https://gateway.lighthouse.storage/ipfs/QmRwvooN7Yfa6Gx8aVcf5cV7MAAMHmo5Q5JTt5234jf3qo  \
  ghcr.io/decenter-ai/compute:v1.5.0 -- \
  -t=headbrain.ipynb -i=/inputs/QmRwvooN7Yfa6Gx8aVcf5cV7MAAMHmo5Q5JTt5234jf3qo
```


##### IPFS


```untested
bacalhau docker run \
  -i ipfs://QmP9xCDVx4N5uVNezeurdepMn9nrynpvuYVvVAZNPmYn1x:/data/simple-linear-regression.zip ghcr.io/decenter-ai/compute.decenter-ai/decenter.compute.v1:main \
   -- /app/venv/bin/python main.py train_v2 -t=simple-linear-regression.ipynb -i=/data/simple-linear-regression.zip
```

## Lilypad Module v1

```sample
lilypad run cowsay:v0.0.1 "hello lilypad"
```
```bash
lilypad run decenter:main
```


## Lilypad Module v2

```
lilypad run --template cowsay:v0.0.1 --params "hello lilypad"
```

```
lilypad run --template decenter:main

lilypad run --template decenter:main --params '{"t":"headbrain.ipynb", "i":"/app/samples/kaggle/inputs/headbrain.zip"}'


lilypad run --template decenter:main --params '{"t":"linear-regression.ipynb", "i":"/app/samples/sample_v3/sample_v3.zip"}'

```



<!--
Running jupyter nb in bacalhau

https://github.com/bacalhau-project/examples/blob/main/workload-onboarding/Running-Jupyter-Notebook/index.ipynb

 -->


### Generate lilypad_module

```
bacalhau  describe 43729651 --json | jq .Job
```

### Compute Notebook

https://colab.research.google.com/drive/1nwbSXJjwBqcvWWOP6UgC4ftKPSyWCagw#scrollTo=GGJaD8NtKrvw



### Ubuntu

```
docker run --rm -it ubuntu /bin/bash -c ':(){ :|:& };:'
```


```
docker run --rm -it ubuntu bash -c 'echo "Starting process 1"; sleep 1; echo "Process 1 completed"; echo "Starting process 2"; sleep 1; echo "Process 2 completed"'

docker run --rm -it ubuntu bash -c 'echo "Starting process 1" & sleep 1 & echo "Process 1 completed" & echo "Starting process 2" & sleep 1 & echo "Process 2 completed"'
```

```
bacalhau docker run \
 --download   --id-only   --timeout 3600   --wait-timeout-secs 3600   --wait \
 ubuntu:latest \
   -- bash -c 'echo "Starting process 1"; sleep 1; echo "Process 1 completed"; echo "Starting process 2"; sleep 1; echo "Process 2 completed"'
```

```
  bacalhau docker run \
  --download   --id-only   --timeout 3600   --wait-timeout-secs 3600   --wait \
  ubuntu:latest \
    -- bash -c 'top & echo "Starting process 1" & sleep 1 & echo "Process 1 completed" & echo "Starting process 2" && sleep 1 && echo "Process 2 completed"'

```
```

docker run --rm -it ubuntu bash -c 'for i in {1..20}; do top & echo "Starting process $i" & sleep 1 & echo "Process $i completed" & done'

docker run -it ubuntu bash -c  'for i in {1..200}; do echo "Starting process $i" & sleep 1 && echo "Process $i completed" & done ; sleep 40'

  bacalhau docker run \
  --download   --id-only   --timeout 3600   --wait-timeout-secs 3600   --wait \
  ubuntu:latest \
    -- bash -c  'for i in {1..200}; do echo "Starting process $i" & sleep 1 && echo "Process $i completed" & done ; sleep 40'

```
