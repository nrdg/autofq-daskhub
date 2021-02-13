# ubuntu:20.04
# pangeo/base-image: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile
# pangeo/pangeo-notebook definition: https://github.com/pangeo-data/pangeo-docker-images/tree/master/pangeo-notebook
# pangeo/pangeo-notebook tags: https://hub.docker.com/r/pangeo/pangeo-notebook/tags
# pangeo-notebook conda package: https://github.com/conda-forge/pangeo-notebook-feedstock/blob/master/recipe/meta.yaml
FROM pangeo/pangeo-notebook:2020.11.18
ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN echo "Installing apt-get packages..." \
    && apt-get update \
    && apt-get install -y \
        gcc \
        nano \
    && rm -rf /var/lib/apt/lists/*
USER ${NB_USER}


# We only need to install packages not listed in this file already:
# https://github.com/pangeo-data/pangeo-docker-images/blob/master/pangeo-notebook/packages.txt
RUN echo "Installing conda packages..." \
 && mamba install -n ${CONDA_ENV} -y -c plotly \
   nibabel==2.5.1 \
   seaborn==0.9.0 \
   plotly==3.9.0 \
   statsmodels \
   xgboost \
   shap \
   dipy==1.3.0 \
   cvxpy==1.1.10 \
   && echo "Installing conda packages complete!"


# We only need to install packages not listed in this file already:
# https://github.com/pangeo-data/pangeo-docker-images/blob/master/pangeo-notebook/packages.txt
RUN echo "Installing pip packages..." \
 && HDF5_DIR=$NB_PYTHON_PREFIX \
    ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir --no-binary=h5py \
    pyAFQ \
    afqinsight \
    neuropythy \
 && echo "Installing pip packages complete!"


RUN echo "Installing jupyterlab extensions..." \
    && export PATH=${NB_PYTHON_PREFIX}/bin:${PATH} \
    && jupyter labextension install -y --clean \
        @jupyter-widgets/jupyterlab-manager \
        dask-labextension@3.0.0 \
 && echo "Installing jupyterlab extensions complete!"

RUN echo "Enabling jupyter serverextensions..." \
    && export PATH=${NB_PYTHON_PREFIX}/bin:${PATH} \
    && jupyter serverextension enable --sys-prefix --py nbresuse

# Configure conda to create new environments within the home folder by default.
# This allows the environments to remain in between restarts of the container
# if only the home folder is persisted.
RUN conda config --system --prepend envs_dirs '~/.conda/envs'
