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

RUN poetry install 

FROM python:3.10-slim

ARG cmd="train_v2"
ARG data_dir='/data'

ENV PYTHON_COMMAND=$cmd

ENV DATA_DIR=$data_dir
ENV OUTPUT_DIR = '/outputs'
ENV INPUT_DIR = '/inputs'
# arg doesn't work

# VOLUME ["/data"]

WORKDIR /app

RUN mkdir -p ${DATA_DIR}
RUN mkdir -p ${INPUT_DIR}

COPY . .

# Copy dependencies from the builder stage
# COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /app/.venv /app/venv

# COPY samples ${data_dir} Don't do we are zipping the data dir

# RUN . venv/bin/activate


# ENTRYPOINT ['/app/venv/bin/python main.py',"train_v2"] FIXME: not working

# ENTRYPOINT ["/bin/bash", "-c", "/app/start.sh train_v2 --train_script=linear-regression.ipynb -i=/app/samples/sample_v3/sample_v3.zip"]

# ENTRYPOINT ["/bin/bash", "-c", "/app/start.sh", "train_v2"]

#FIXME: support cmd

# HEALTHCHECK ['']

# ENTRYPOINT "/app/venv/bin/python main.py $PYTHON_COMMAND"
RUN venv/bin/python -m pip install --upgrade --force-reinstall jupyter

ENTRYPOINT ["/app/venv/bin/python","main.py","train_v2"]

CMD ["-t=linear-regression.ipynb", "-i=/app/samples/sample_v3/sample_v3.zip"]


LABEL maintainer="Hiro <laciferin@gmail.com>"
