FROM ubuntu:latest AS codeql_base

LABEL maintainer="mpreziuso@kaosdynamics.com"

ENV CODEQL_HOME /usr/local/codeql

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        wget git unzip \
        ca-certificates && \
    apt-get clean && \
    update-ca-certificates

RUN mkdir -p ${CODEQL_HOME} ${CODEQL_HOME}/scripts

RUN git clone https://github.com/github/codeql ${CODEQL_HOME}/codeql-repo

RUN wget -q https://github.com/github/codeql-cli-binaries/releases/latest/download/codeql-linux64.zip -O /tmp/codeql_linux.zip && \
    unzip /tmp/codeql_linux.zip -d ${CODEQL_HOME} && \
    rm /tmp/codeql_linux.zip

ENV PATH="${CODEQL_HOME}/codeql:${PATH}"

COPY scan.sh /usr/local/codeql/

ENTRYPOINT ["/usr/local/codeql/scan.sh"]

#####################################

FROM codeql_base AS python_codeql

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-pip && \
    ln -s $(which python3) /usr/bin/python && \
    apt-get clean

# Pre-compile our queries to save time later
RUN codeql query compile --threads=0 ${CODEQL_HOME}/codeql-repo/python/ql/src/codeql-suites/*.qls

####################################

FROM codeql_base AS javascript_codeql

# Pre-compile our queries to save time later
RUN codeql query compile --threads=0 ${CODEQL_HOME}/codeql-repo/javascript/ql/src/codeql-suites/*.qls

ENV DEBIAN_FRONTEND noninteractive

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean

####################################

FROM codeql_base AS java_codeql

# Pre-compile our queries to save time later
RUN codeql query compile --threads=0 ${CODEQL_HOME}/codeql-repo/java/ql/src/codeql-suites/*.qls


####################################

FROM codeql_base AS go_codeql

RUN git clone https://github.com/github/codeql-go ${CODEQL_HOME}/codeql-go-repo

# Pre-compile our queries to save time later
RUN codeql query compile --threads=0 ${CODEQL_HOME}/codeql-go-repo/ql/src/codeql-suites/*.qls

RUN cd /tmp && \
    wget 'https://golang.org/dl/go1.16.5.linux-amd64.tar.gz' && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.16.5.linux-amd64.tar.gz && \
    rm -rf /tmp/go1.16.5.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
