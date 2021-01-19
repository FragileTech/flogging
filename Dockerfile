FROM fragiletech/ubuntu20.04-base-py39
ARG JUPYTER_PASSWORD=""
ENV BROWSER=/browser \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

COPY . flogging/

RUN cd flogging \
    && python3 -m pip install -U pip \
    && pip3 install -r requirements-lint.txt  \
    && pip3 install -r requirements-test.txt  \
    && pip3 install -r requirements.txt  \
    && pip install ipython jupyter \
    && pip3 install -e . --no-use-pep517
RUN make -f flogging/scripts/makefile.docker remove-dev-packages
RUN mkdir /root/.jupyter && \
    echo 'c.NotebookApp.token = "'${JUPYTER_PASSWORD}'"' > /root/.jupyter/jupyter_notebook_config.py
CMD jupyter notebook --allow-root --port 8080 --ip 0.0.0.0