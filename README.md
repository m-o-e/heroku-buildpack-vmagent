# Heroku Buildpack: vmagent

A Heroku buildpack to run the [VictoriaMetrics agent](https://docs.victoriametrics.com/vmagent.html)
inside a dyno, scrape metrics directly from the app server, and send them to a VictoriaMetrics cluster
using the Prometheus remote write protocol.

## Usage

Set vmagent config vars on your Heroku app:

```
$ heroku config:set \
  VMAGENT_REMOTE_WRITE_URL="https://victoriametrics.example.com" \
  VMAGENT_REMOTE_WRITE_USERNAME="<vminsert_username>" \
  VMAGENT_REMOTE_WRITE_PASSWORD="<vminsert_password>" \
  VMAGENT_SCRAPE_USERNAME="<scrape_request_username>" \
  VMAGENT_SCRAPE_PASSWORD="<scrape_request_password>"
```

_See the [Configuration section](#configuration) below for a full list of config vars that can be set._

Add the buildpack to your Heroku app:

```
$ heroku buildpacks:add https://github.com/ably/heroku-buildpack-vmagent.git
```

Update your Procfile to run your app server command with the [bin/start-vmagent](bin/start-vmagent) script,
for example:

```
web: bin/start-vmagent bundle exec rackup config.ru -p ${PORT:-5000}
```

Deploy your app, and see that vmagent was installed:

```
remote: -----> vmagent buildpack app detected
remote: -----> vmagent-buildpack: Installing vmagent v1.63.0
remote: -----> vmagent-buildpack: Downloading vmutils from GitHub
remote: -----> vmagent-buildpack: Extracting vmagent binary
remote: -----> vmagent-buildpack: Verifying vmagent binary
remote: vmagent-prod: OK
remote: -----> vmagent-buildpack: Caching vmagent binary
remote: -----> vmagent-buildpack: Copying vmagent binary into bin/
remote: -----> vmagent-buildpack: Copying vmagent start script into bin/
remote: -----> vmagent-buildpack: Copying vmagent-prometheus.yml.erb into config/
```

vmagent will now be scraping metrics from the app server and sending them to VictoriaMetrics.

_See [config/vmagent-prometheus.yml.erb](config/vmagent-prometheus.yml.erb) for more information
on how vmagent is configured to scrape the app server._

## Configuration

#### `VMAGENT_REMOTE_WRITE_URL`

**Required.** The remote write URL to send metrics to.

#### `VMAGENT_REMOTE_WRITE_USERNAME`

**Required.** The basic auth username for the remote write URL.

#### `VMAGENT_REMOTE_WRITE_PASSWORD`

**Required.** The basic auth password for the remote write URL.

#### `VMAGENT_SCRAPE_USERNAME`

**Required.** The basic auth username for the scrape request.

#### `VMAGENT_SCRAPE_PASSWORD`

**Required.** The basic auth password for the scrape request.

#### `VMAGENT_EXTERNAL_LABELS`

**Optional.** A comma separated list of additional external labels to add to all metrics in `key=value` format,
for example `app=my-app,environment=production`.

#### `VMAGENT_VERSION`

**Optional.** The version of vmagent to install (default: see [bin/vars.sh](bin/vars.sh)).

#### `VMAGENT_SHA256`

**Optional.** The expected SHA256 hash of the vmagent binary (default: see [bin/vars.sh](bin/vars.sh)).

#### `VMAGENT_APP_JOB_NAME`

**Optional.** The job_name used for the app server scrape target (default: web).

#### `VMAGENT_SCRAPE_INTERVAL`

**Optional.** How frequently to scrape metrics from the app server (default: 15s).

#### `VMAGENT_MAX_DISK_USAGE`

**Optional.** The maximum file-based buffer size in bytes that vmagent can use (default: 1GB).

#### `VMAGENT_HTTP_PORT`

**Optional.** TCP port vmagent listens on for http connections (default: 8429).

## Testing

This buildpack includes tests that can be run using the [heroku-buildpack-testrunner](https://github.com/heroku/heroku-buildpack-testrunner).

Follow the [testrunner setup instructions](https://github.com/heroku/heroku-buildpack-testrunner#local-setup)
and then run the tests:

```
$ bin/run /path/to/heroku-buildpack-vmagent

BUILDPACK: /path/to/heroku-buildpack-vmagent
  TEST SUITE: compile_test.sh
  testCompile

  Ran 1 test.

  OK
  4 SECONDS

  TEST SUITE: detect_test.sh
  testDetect

  Ran 1 test.

  OK
  0 SECONDS

  TEST SUITE: release_test.sh
  testRelease

  Ran 1 test.

  OK
  1 SECONDS

5 SECONDS

------
ALL OK
5 SECONDS
```

This buildpack also includes a simple Ruby Rack application that can be deployed to
Heroku along with this buildpack to test metric collection of an app server:

```
$ heroku create

$ heroku config:set \
  VMAGENT_REMOTE_WRITE_URL="https://victoriametrics.example.com" \
  VMAGENT_REMOTE_WRITE_USERNAME="<vminsert_username>" \
  VMAGENT_REMOTE_WRITE_PASSWORD="<vminsert_password>"

$ heroku buildpacks:add heroku/ruby
$ heroku buildpacks:add https://github.com/ably/heroku-buildpack-vmagent.git

$ git push heroku main
```

Visit the resulting Heroku app a few times, and you should see associated metrics appear
in your VictoriaMetrics cluster.
