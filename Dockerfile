# REF: https://docs.docker.com/engine/reference/builder/
# REF: https://hub.docker.com/_/perl
FROM perl:5.37.11

# We point to the original repository for the image
LABEL org.opencontainers.image.source https://github.com/jonasbn/scholiast

# We need C compiler and related tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends

# This is our Dist::Zilla work directory, we do not want to mix this
# with our staging area
WORKDIR /usr/src/pause

# Installing core dependency
RUN cpanm Perl::Critic

# Installing additional dependencies as a separate step, to keep previous layer intact
COPY cpanfile .
RUN cpanm --installdeps .

# This is our staging work directory
WORKDIR /tmp

# This is our executable, it consumes all parameters passed to our container
ENTRYPOINT [ "perlcritic" ]
