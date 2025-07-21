local interval = import 'interval.libsonnet';

{
    local tags_grafana = {
                  "builtIn": 1,
                  "datasource": {
                    "type": "grafana",
                    "uid": "-- Grafana --"
                  },
                  "enable": true,
                  "hide": false,
                  "iconColor": "rgba(0, 211, 255, 1)",
                  "name": "Annotations & Alerts",
                  "target": {
                    "limit": 100,
                    "matchAny": true,
                    "queryType": "annotations",
                    "tags": [
                      "Performance problem",
                      "YouTrack"
                    ],
                    "type": "tags"
                  },
                  "type": "dashboard"
                },
    local app_start_promql = {
                   "datasource": {
                     "type": "prometheus",
                     "uid": "${source}"
                   },
                   "enable": true,
                   "expr":
                   |||
                        avg(
                          (delta({__name__=~"process_uptime.*",  instance=~"$instance" }[%(interval)s]) < 0)
                          /
                          (delta({__name__=~"process_uptime.*",  instance=~"$instance" }[%(interval)s]) < 0)
                        ) by (instance)
                   ||| % { interval: interval.variable },
                   "iconColor": "red",
                   "name": "Reset",
                   "step": interval.min_interval,
                   "textFormat": "{{instance}}",
                   "titleFormat": "App start"
                 },
    "annotations": {
        "list": [
            tags_grafana,
            app_start_promql
        ]
    }
}