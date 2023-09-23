# Stage 1: Install dependencies
FROM python:3.10 AS builder

WORKDIR /app

# Install Poetry
RUN pip install poetry

ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_VIRTUALENVS_OPTIONS_ALWAYS_COPY=true
ENV POETRY_VIRTUALENVS_OPTIONS_NO_PIP=false
ENV POETRY_VIRTUALENVS_OPTIONS_NO_SETUPTOOLS=true
# ENV POETRY_VIRTUALENVS_PATH={cache-dir}/virtualenvs not required since virtual env is set in
# fixme: add setup tooools

# Copy only the dependency-related files
COPY pyproject.toml poetry.lock ./

# Install project dependencies using Poetry
RUN poetry install --no-root

# Stage 2: Copy application code and configure Streamlit
FROM python:3.10-slim

ARG cmd=train_v2
ARG data_dir='/data'

ENV mode=production

EXPOSE 8501

WORKDIR /app

RUN mkdir -p $data_dir

# Copy dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /app/.venv /app/venv

RUN . venv/bin/activate

COPY . .

ENTRYPOINT ["venv/python","main.py","$cmd"]

CMD ["--train_script=linear-regression.ipynb", "-i=samples/sample_v3/sample_v3.zip"]
