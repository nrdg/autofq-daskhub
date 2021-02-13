# ubuntu:20.04
# pangeo/base-image: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile
# pangeo/pangeo-notebook definition: https://github.com/pangeo-data/pangeo-docker-images/tree/master/pangeo-notebook
# pangeo/pangeo-notebook tags: https://hub.docker.com/r/pangeo/pangeo-notebook/tags
# pangeo-notebook conda package: https://github.com/conda-forge/pangeo-notebook-feedstock/blob/master/recipe/meta.yaml
FROM pangeo/pangeo-notebook:2020.11.18
ARG DEBIAN_FRONTEND=noninteractive
RUN conda config --system --prepend envs_dirs '~/.conda/envs'
