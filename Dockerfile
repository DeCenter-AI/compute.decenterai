FROM python:3.10 AS builder

WORKDIR /app

RUN pip install poetry

ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_VIRTUALENVS_OPTIONS_ALWAYS_COPY=true
ENV POETRY_VIRTUALENVS_OPTIONS_NO_PIP=false
ENV POETRY_VIRTUALENVS_OPTIONS_NO_SETUPTOOLS=true
# ENV POETRY_VIRTUALENVS_PATH={cache-dir}/virtualenvs not required since virtual env is set in
# fixme: add setup tooools

RUN poetry config virtualenvs.create true

COPY pyproject.toml poetry.lock ./

RUN poetry install --no-root

FROM python:3.10-slim

ARG cmd="train_v2"
ARG data_dir='/data'


WORKDIR /app

RUN mkdir -p $data_dir


COPY . .

# Copy dependencies from the builder stage
# COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /app/.venv /app/venv

# RUN . venv/bin/activate

RUN chmod +x start.sh

# ENTRYPOINT ['/app/venv/bin/python main.py',"train_v2"] FIXME: not working

# ENTRYPOINT ["/bin/bash", "-c", "/app/start.sh train_v2 --train_script=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip"]

ENTRYPOINT ["/app/venv/bin/python", 'main.py $cmd--train_script=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip']

# ENTRYPOINT ["/bin/bash", "-c", "/app/start.sh", "train_v2"]

# CMD ["--train_script=linear-regression.ipynb", "-i=/app/samples/sample_v3/sample_v3.zip"]

LABEL maintainer="Hiro <laciferin@gmail.com>"
