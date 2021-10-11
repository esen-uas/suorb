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
        vim \
    ; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
    # This is a dev container so don't kill pkg management by removıng /var/lib/dpkg etc.


# Build dependencies from pypi
RUN pip install conan cpplint


# iwyu needs libclang-dev
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --quiet --no-install-recommends \
        libclang-dev \
    ; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
    # This is a dev container so don't kill pkg management by removıng /var/lib/dpkg etc.

# iwyu - clang 10 compatible version is 0.14
RUN set -eux; \
    cd tmp; \
    git clone --branch 0.14 \
        https://github.com/include-what-you-use/include-what-you-use.git \
        /tmp/iwyu; \
    mkdir -p /tmp/build; \
    cmake -B /tmp/build --DCMAKE_PREFIX_PATH=/usr/lib/llvm-10 /tmp/iwyu ; \
    cmake --build /tmp/build --target install; \
    rm -rf /tmp/*


# User niceties
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --quiet --no-install-recommends \
        bash-completion

USER vscode
