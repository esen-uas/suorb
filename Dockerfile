FROM mcr.microsoft.com/vscode/devcontainers/cpp:ubuntu-20.04

# Build dependencies from apt
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --quiet --no-install-recommends \
        ccache \
        clang-format \
        clang-tidy \
        doxygen \
        graphviz \
        make \
        ninja-build \
        python-is-python3 \
        python3-pip \
        vim


# Build dependencies from pypi
RUN pip install conan cpplint


# User niceties
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --quiet --no-install-recommends \
        bash-completion

USER vscode
