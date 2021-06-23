ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}


RUN apt-get update \
	&& apt-get -o Dpkg::Use-Pty=0 --no-install-recommends -y install \
		git build-essential ca-certificates wget libpq-dev libssl-dev \
		zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
		libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
		liblzma-dev python-openssl \
	&& rm -rf /var/lib/apt/lists/*

ARG CMDSTAN_VERSION
RUN wget https://github.com/stan-dev/cmdstan/releases/download/v${CMDSTAN_VERSION}/cmdstan-${CMDSTAN_VERSION}.tar.gz
RUN tar -xvzf cmdstan-${CMDSTAN_VERSION}.tar.gz --directory /root/
WORKDIR /root/cmdstan-${CMDSTAN_VERSION}
RUN make build
ENV CMDSTAN=/root/cmdstan-${CMDSTAN_VERSION}


RUN git clone https://github.com/pyenv/pyenv.git /root/.pyenv
WORKDIR /root/.pyenv
RUN echo 'export PYENV_ROOT="/root/.pyenv"' >> /root/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc
RUN echo 'eval "$(pyenv init --path)"' >> /root/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> /root/.bashrc


WORKDIR /usr/src/app
COPY pyproject.toml ./
COPY poetry.lock ./


ENV PYENV_ROOT=/root/.pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH
ARG PYTHON_VERSION
ENV PYENV_VERSION=${PYTHON_VERSION}
RUN bash -i -c "pyenv install ${PYTHON_VERSION} \
	&& curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py \
	| python -"
RUN echo 'export PATH="$HOME/.poetry/bin:$PATH"' >> /root/.bashrc
RUN bash -i -c "poetry install"
