ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}


RUN apt-get update \
	&& apt-get -o Dpkg::Use-Pty=0 --no-install-recommends -y install \
		git build-essential ca-certificates wget libpq-dev libssl-dev \
		zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
		libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
		liblzma-dev python-openssl \
	&& rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/pyenv/pyenv.git /root/.pyenv
WORKDIR /root/.pyenv
RUN echo 'export PYENV_ROOT="/root/.pyenv"' >> /root/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc


RUN git clone https://github.com/pyenv/pyenv-virtualenv.git /root/.pyenv/plugins/pyenv-virtualenv
WORKDIR /root/.pyenv/plugins/pyenv-virtualenv
RUN echo 'eval "$(pyenv init -)"' >> /root/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc


WORKDIR /usr/src/app
COPY requirements.txt ./


ENV PYENV_ROOT=/root/.pyenv
ENV PATH=$PYENV_ROOT/bin:$PATH
ARG PYTHON_VERSION
RUN bash -i -c "pyenv install ${PYTHON_VERSION} \
	&& pyenv virtualenv ${PYTHON_VERSION} current \
	&& pyenv activate current \
	&& pip install --upgrade pip \
	&& pip install -r requirements.txt"
RUN echo 'pyenv activate current' >> /root/.bashrc
