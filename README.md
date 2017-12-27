To update bundler:

```
docker run --rm -it -v $PWD:/app -w /app ruby:2.4-alpine bundle update
docker run --rm -it -v $PWD:/app -w /app ruby:2.4-alpine bundle install --standalone --clean
```

To run it:

```
docker build . -t graphdf
docker run graphdf
```
