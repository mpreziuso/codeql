# CodeQL

Easy to use CodeQL containers for your projects.

## How to use

Currently supported languages:

* Go
* Java
* Javascript
* Python

### 1. Generate a CodeQL Database for your project

```
docker run --rm --name codeql-<language> -v <path-to-your-repository>:/opt/src -v <path-to-your-codeql-database>:/opt/results -e CODEQL_CLI_ARGS="database create --language=javascript /opt/results/source_db -s /opt/src" mpreziuso/codeql:<language>
```

So, if you had a Go project, you'd run something like this:

```
docker run --rm --name codeql-go -v ~/git/my-project:/opt/src -v ~/codeql/my-project:/opt/results -e CODEQL_CLI_ARGS="database create --language=go /opt/results/source_db -s /opt/src" mpreziuso/codeql:go
```

### 2. Analyse your project

```
docker run --rm --name codeql-<language> -v <path-to-your-repository>:/opt/src -v <path-to-your-codeql-database>:/opt/results -e CODEQL_CLI_ARGS="database analyze --format=sarifv2.1.0 --output=/opt/results/issues.sarif /opt/results/source_db /usr/local/codeql-home/codeql-go-repo/ql/src/codeql-suites/go-lgtm-full.qls" mpreziuso/codeql:go
```

So, if you had the same Go project, you'd run something like this:

```
docker run --rm --name codeql-go -v ~/git/my-project:/opt/src -v ~/codeql/my-project:/opt/results -e CODEQL_CLI_ARGS="database analyze --format=sarifv2.1.0 --output=/opt/results/issues.sarif /opt/results/source_db /usr/local/codeql-home/codeql-go-repo/ql/src/codeql-suites/go-lgtm.qls" mpreziuso/codeql:go
```

### 3. Profit $$$ 

You should now see a file called `issues.sarif` in `~/codeql/my-project` which can be viewed using the [Microsoft SARIF Viewer](https://microsoft.github.io/sarif-web-component/)

