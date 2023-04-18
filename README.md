## Usage

Start server with:

`SSL_DOMAIN="192.168.50.66" docker-compose up`

## Generate Certificate

Certificate and key are generated when docker image starts and placed in `.ssl`

Install `rtmp.crt` as trusted root certificate (step varies per OS)

```
$ sudo cp ./example.com.crt /usr/local/share/ca-certificates
$ sudo update-ca-certificates
```

## Test Stream

For sanity testing streaming from a controlled device.

### RTMP

1. Test via:

```
docker run --rm jrottenberg/ffmpeg -r 30 -f lavfi -i testsrc -vf scale=1280:960 -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -f flv rtmp:/192.168.50.66:1935/live/test
```

2. View at: http://192.168.50.66:8080

### RTMPS

1. Test via:

```
docker run --rm jrottenberg/ffmpeg -r 30 -f lavfi -i testsrc -vf scale=1280:960 -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -f flv rtmps://192.168.50.66:1936/live/test
```

2. View at: http://192.168.50.66:8080

## Actual Test

### RTMP

stream to: `rtmp://192.168.50.66:1935/live/test`

```
poetry run gopro-livestream dabugdabug pleasedontguessme "rtmp://192.168.50.66:1935/live/test"
```

### RTMPS

Stream to `rtmps://192.168.50.66:8443/live/test`

```
poetry run gopro-livestream --cert ./certs/example.com.crt dabugdabug pleasedontguessme "rtmps://192.168.50.66:1936/live/test"
```

## Debugging

Stats can be viewed at `http://localhost:8080/stats`. This is a good way to just make
sure the server / stream are running.
