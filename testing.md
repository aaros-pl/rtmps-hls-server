## Generate keys

For sanity testing certificate generation

1. Generate cert for localhost

```
cd certs
./make_cert.sh localhost
```

2. Install .crt as trusted root certificate (step varies per OS)

```
$ sudo apt-get install -y ca-certificates
$ sudo cp ./example.com.crt /usr/local/share/ca-certificates
$ sudo update-ca-certificates
```

Update `etc/hosts` to include:

127.0.0.1    mydomain.com

3. In Chrome, go to: `https://localhost:8443/stats`. There should be no security errors.

## Test Stream

For sanity testing streaming from a controlled device.

Using [OBS](https://obsproject.com/):

### RTMP

1. Test via:

```
ffmpeg -r 30 -f lavfi -i testsrc -vf scale=1280:960 -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -f flv rtmp://mydomain.com:1935/live/test
```

2. View at: http://mydomain.com:8080/players/

### RTMPS

1. Test via:

```
ffmpeg -r 30 -f lavfi -i testsrc -vf scale=1280:960 -vcodec libx264 -profile:v baseline -pix_fmt yuv420p -f flv rtmps://mydomain.com:1936/live/test
```

2. View at: http://mydomain.com:8080/players/

## Actual Test

### RTMP

stream to: `rtmp://192.168.50.66:1935/stream/gopro`

poetry run gopro-livestream dabugdabug pleasedontguessme "rtmp://192.168.50.66:1935/stream/gopro"

### RTMPS

Stream to `rtmps://192.168.50.66:8443/stream/gopro`

poetry run gopro-livestream --cert ./certs/example.com.crt dabugdabug pleasedontguessme "rtmps://192.168.50.66:8443/stream/g
opro"

## View

`http://localhost:8080/player.html?url=http://localhost:8080/live/gopro.m3u8`

`https://hls-js.netlify.app/demo/?src=http%3A%2F%2Flocalhost%3A8080%2Flive%2Fgopro.m3u8`

## Debugging

http://localhost:8080/stats