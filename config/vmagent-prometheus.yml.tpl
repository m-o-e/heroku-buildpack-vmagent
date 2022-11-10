global:
  scrape_interval: "1m"
  external_labels: { "src": "vmagent", "dyno": "$DYNO", "app": "$HEROKU_APP_NAME" }

scrape_configs:
  - job_name: web
    stream_parse: true
    static_configs:
    - targets: ['localhost:$PORT']
    basic_auth:
      username: $VMAGENT_SCRAPE_USERNAME
      password: $VMAGENT_SCRAPE_PASSWORD
