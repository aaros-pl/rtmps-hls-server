## Usage

Start server with:

`SSL_DOMAIN="{IP_ADDRESS}" docker-compose up`

where IP_ADDRESS is the IP Address of the device the server is running on.

## Generate Certificate

Certificate and key are generated when docker image starts and placed in `.ssl`

Install `rtmp.crt` as trusted root certificate (step varies per OS). On Ubuntu for example:

```
$ sudo cp ./.ssl/self-signed/rtmp.crt /usr/local/share/ca-certificates
$ sudo update-ca-certificates
```

## Test Stream

For sanity testing streaming from a controlled device.

### RTMP

1. Test via:

```
docker run --rm jrottenberg/ffmpeg -r 30 -f lavfi -i testsrc -vf scale=1280:960 -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -f flv rtmp:/{IP_ADDRESS}:1935/live/test
```

2. View at: http://localhost:8080

### RTMPS

1. Test via:

```
docker run --rm jrottenberg/ffmpeg -r 30 -f lavfi -i testsrc -vf scale=1280:960 -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -f flv rtmps://{IP_ADDRESS}:1936/live/test
```

2. View at: http://localhost:8080

## Debugging

Stats can be viewed at `http://localhost:8080/stats`. This is a good way to just make
sure the server / stream are running.
