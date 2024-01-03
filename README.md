# my-go-app

## Build Application

```bash
docker build . -t aunnk/my-go-app
```

## Login to Docker Hub

```bash
docker login -u aunnk
```

## Push to Docker Hub

```bash
docker push aunnk/my-go-app:latest
```

## Install Application via Helm Chart

Install the chart for the first time.

```bash
helm install my-go-app .
```

Redeploy the chart by running the following command.

```bash
helm upgrade my-go-app .
```
