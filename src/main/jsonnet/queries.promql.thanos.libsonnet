local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local interval = import 'interval.libsonnet';

local variables = import './variables.libsonnet';
local timeSeries = g.panel.timeSeries;

local strip(str) = std.stripChars(str, "\n ");

{
  // Global common filter.
  // It is used in queries via the expression "string-with-filter-var % $".
  // If you want to modify the global filter - let's do it here.
  filter: ' instance=~"$instance"',
  local offsetExpression="offset ${offset}",
  local offsetExpression_7d="offset 7d",
  local offsetExpression_14d="offset 14d",
  local offsetExpression_21d="offset 21d",
  local offsetExpression_28d="offset 28d",
  local offsetExpression_35d="offset 35d",


  units: {
    percent: 'percent',
    percent_0_1: 'percentunit',
    bool_yes_no: 'bool_yes_no',
    none: 'none',
    ms: 'ms',
    bytes: 'bytes',
    count_per_second: 'cps',
    count_per_minute: 'cpm',
  },

  start: prometheusQuery.new(
           '${%s}' % variables.datasource.name,
           |||
             avg(
               (($app_start * delta({__name__=~"process_uptime.*", %(filter)s }[%(interval)s])) < 0)
               /
               (($app_start * delta({__name__=~"process_uptime.*", %(filter)s }[%(interval)s])) < 0)
             )
           ||| % {
            filter: $.filter,
            interval: interval.variable
           }
         )
         + prometheusQuery.withEditorMode('code')
         + prometheusQuery.withHide(false)
         + prometheusQuery.withInstant(false)
         + prometheusQuery.withLegendFormat('app start')
         + prometheusQuery.withRange(true)
         + prometheusQuery.withRefId('start')
  ,

  query: {
    one_two: {
        set(template, one, two, unitValue): {
            unit: unitValue,
            current: strip(template % { one: one.current, two: two.current }),
            prev: strip(template % { one: one.prev, two: two.prev }),
            prev_7d: strip(template % { one: one.prev_7d, two: two.prev_7d }),
            prev_14d: strip(template % { one: one.prev_14d, two: two.prev_14d }),
            prev_21d: strip(template % { one: one.prev_21d, two: two.prev_21d }),
            prev_28d: strip(template % { one: one.prev_28d, two: two.prev_28d }),
            prev_35d: strip(template % { one: one.prev_35d, two: two.prev_35d }),
            current_over_time: strip(template % { one: one.current_over_time, two: two.current_over_time }),
            prev_over_time: strip(template % { one: one.prev_over_time, two: two.prev_over_time }),
        }
    },
    one_two_free: {
        set(template, one, two, free, unitValue): {
            unit: unitValue,
            current: strip(template % { one: one.current, two: two.current, free: free.current }),
            prev: strip(template % { one: one.prev, two: two.prev, free: free.prev }),
            prev_7d: strip(template % { one: one.prev_7d, two: two.prev_7d, free: free.prev_7d }),
            prev_14d: strip(template % { one: one.prev_14d, two: two.prev_14d, free: free.prev_14d }),
            prev_21d: strip(template % { one: one.prev_21d, two: two.prev_21d, free: free.prev_21d }),
            prev_28: strip(template % { one: one.prev_28, two: two.prev_28, free: free.prev_28 }),
            prev_35: strip(template % { one: one.prev_35, two: two.prev_35, free: free.prev_35 }),
            current_over_time: strip(template % { one: one.current_over_time, two: two.current_over_time, free: free.current_over_time }),
            prev_over_time: strip(template % { one: one.prev_over_time, two: two.prev_over_time, free: free.prev_over_time }),
        }
    },
    avg: {
      set(metricName, unitValue): {
        unit: unitValue,
        current: current(metricName),
        prev: current(metricName, offsetExpression),
        prev_7d: current(metricName, offsetExpression_7d),
        prev_14d: current(metricName, offsetExpression_14d),
        prev_21d: current(metricName, offsetExpression_21d),
        prev_28d: current(metricName, offsetExpression_28d),
        prev_35d: current(metricName, offsetExpression_35d),
        current_over_time: current_over_time(metricName),
        prev_over_time: current_over_time(metricName, offsetExpression),
      },
      local current(metricName, offset="") = strip(
        |||
          avg(%(metricName)s{ %(filter)s } %(offset)s)
        ||| % {
          metricName: metricName,
          filter: $.filter,
          offset: offset
        }),
      local current_over_time(metricName, offset="") = strip(
        |||
          avg_over_time(avg(%(metricName)s{ %(filter)s } %(offset)s)[$__range:%(interval)s])
        ||| % {
          metricName: metricName,
          filter: $.filter,
          offset: offset,
          interval: interval.variable
        }),
    },
    total: {
      set(metricName): {
        unit: $.units.none,
        current: current(metricName),
        prev: current(metricName, offsetExpression),
        prev_7d: current(metricName, offsetExpression_7d),
        prev_14d: current(metricName, offsetExpression_14d),
        prev_21d: current(metricName, offsetExpression_21d),
        prev_28d: current(metricName, offsetExpression_28d),
        prev_35d: current(metricName, offsetExpression_35d),
        current_over_time: current(metricName),
        prev_over_time: current(metricName, offsetExpression),
      },
      local current(metricName, offset="") = strip(
        |||
          sum_over_time(sum(increase(%(metricName)s{ %(filter)s }[%(interval)s:] %(offset)s))[$__range:%(interval)s])
        ||| % {
          metricName: metricName,
          filter: $.filter,
          offset: offset,
          interval: interval.variable
        }),
    },
    count_per_minute: {
        set(metricName, unitValue=$.units.count_per_minute): {
          unit: unitValue,
          current: current(metricName),
          prev: current(metricName, offsetExpression),
          prev_7d: current(metricName, offsetExpression_7d),
          prev_14d: current(metricName, offsetExpression_14d),
          prev_21d: current(metricName, offsetExpression_21d),
          prev_28d: current(metricName, offsetExpression_28d),
          prev_35d: current(metricName, offsetExpression_35d),
          current_over_time: current_over_time(metricName),
          prev_over_time: current_over_time(metricName, offsetExpression),
        },
        local current(metricName, offset="") = strip(
          |||
            60 * sum(rate(%(metricName)s{ %(filter)s }[%(interval)s] %(offset)s))
          ||| % {
            metricName: metricName,
            filter: $.filter,
            offset: offset,
            interval: interval.variable
          }),
        local current_over_time(metricName, offset="") = strip(
        |||
          sum_over_time(sum(increase(%(metricName)s{ %(filter)s }[%(interval)s] %(offset)s))[$__range:%(interval)s])
        ||| % {
          metricName: metricName,
          filter: $.filter,
          offset: offset,
          interval: interval.variable
        }),
      },
    none_per_second: {
      set(metricName): {
        unit: $.units.none,
        current: strip($.query.count_per_second.current(metricName)),
        prev: strip($.query.count_per_second.prev(metricName)),
        prev_7d: strip($.query.count_per_second.prev_7d(metricName)),
        prev_14d: strip($.query.count_per_second.prev_14d(metricName)),
        prev_21d: strip($.query.count_per_second.prev_21d(metricName)),
        prev_28d: strip($.query.count_per_second.prev_28d(metricName)),
        prev_35d: strip($.query.count_per_second.prev_35d(metricName)),
        current_over_time: strip($.query.count_per_second.current_over_time(metricName)),
        prev_over_time: strip($.query.count_per_second.prev_over_time(metricName)),
      },
    },
    metric_per_time: {
      set(metricName, unitValue=$.units.count_per_second, seconds=1): {
        unit: unitValue,
        current: current(seconds, metricName),
        prev: current(seconds, metricName, offsetExpression),
        prev_7d: current(seconds, metricName, offsetExpression_7d),
        prev_14d: current(seconds, metricName, offsetExpression_14d),
        prev_21d: current(seconds, metricName, offsetExpression_21d),
        prev_28d: current(seconds, metricName, offsetExpression_28d),
        prev_35d: current(seconds, metricName, offsetExpression_35d),
        current_over_time: current_over_time(seconds, metricName),
        prev_over_time: current_over_time(seconds, metricName, offsetExpression),
      },
      local current(seconds, metricName, offset="") = strip(
        |||
          %(time)s sum(rate(%(metricName)s{ %(filter)s }[%(interval)s] %(offset)s))
        ||| % {
          metricName: metricName,
          filter: $.filter,
          offset: offset,
          time: if seconds==1 then "" else "%(seconds)s *" % {seconds: seconds},
          interval: interval.variable
        }),
      local current_over_time(seconds, metricName, offset="") = strip(
      |||
        sum_over_time(sum(increase(%(metricName)s{ %(filter)s }[%(interval)s] %(offset)s))[$__range:%(interval)s])
      ||| % {
        metricName: metricName,
        filter: $.filter,
        offset: offset,
        time: if seconds==1 then "" else "%(seconds)s *" % {seconds: seconds},
        interval: interval.variable
      }),
    },
    count_per_second: {
      set(metricName, unitValue=$.units.count_per_second): $.query.metric_per_time.set(metricName, unitValue, 1),
    },
    duration_per_event: {
      set(
        durationMetric,
        eventMetric,
        unitValue=$.units.ms): {
        unit: unitValue,
        current: current(durationMetric, eventMetric),
        prev: current(durationMetric, eventMetric, offsetExpression),
        prev_7d: current(durationMetric, eventMetric, offsetExpression_7d),
        prev_14d: current(durationMetric, eventMetric, offsetExpression_14d),
        prev_21d: current(durationMetric, eventMetric, offsetExpression_21d),
        prev_28d: current(durationMetric, eventMetric, offsetExpression_28d),
        prev_35d: current(durationMetric, eventMetric, offsetExpression_35d),
        current_over_time: current_over_time(durationMetric, eventMetric),
        prev_over_time: current_over_time(durationMetric, eventMetric, offsetExpression),
      },
      local current(durationMetric, eventMetric, offset="") = strip(
        |||
            sum(
                increase(
                    %(durationMetric)s{
                        %(filter)s
                    }[%(interval)s] %(offset)s
                ) /
                (increase(
                    %(eventMetric)s{
                        %(filter)s
                    }[%(interval)s] %(offset)s
                )>0)
            )
        ||| % {
          durationMetric: durationMetric,
          eventMetric: eventMetric,
          filter: $.filter,
          offset: offset,
          interval: interval.variable
        }),
      local current_over_time(durationMetric, eventMetric, offset="") = strip(
      |||
        sum_over_time(
          sum(
            increase(
                %(durationMetric)s{
                    %(filter)s
                }[%(interval)s] %(offset)s
            ) /
            (increase(
                %(eventMetric)s{
                    %(filter)s
                }[%(interval)s] %(offset)s
            )>0)
          )[$__range:%(interval)s]
        )
      ||| % {
          durationMetric: durationMetric,
          eventMetric: eventMetric,
          filter: $.filter,
          offset: offset,
          interval: interval.variable
      }),
    },
  },

  prev(prevQuery):
    prometheusQuery.new(
      '${%s}' % variables.datasource.name,
      prevQuery
    )
    + prometheusQuery.withEditorMode('code')
    + prometheusQuery.withLegendFormat('prev ($offset)')
    + prometheusQuery.withRange(true)
    + prometheusQuery.withRefId('prev')
  ,

  current(currentQuery):
    prometheusQuery.new(
      '${%s}' % variables.datasource.name,
      currentQuery
    )
    + prometheusQuery.withEditorMode('code')
    + prometheusQuery.withLegendFormat('current')
    + prometheusQuery.withRange(true)
    + prometheusQuery.withRefId('current')
  ,

  diff(querySet):
    prometheusQuery.new(
      '${%s}' % variables.datasource.name,
      |||
        100 * (
          (  %(current)s )
          -
          (  %(prev)s != 0 )
        )
        /
        ( %(prev)s != 0 ) OR vector(0)
      ||| % querySet
    )
    + prometheusQuery.withLegendFormat('diff')
    + prometheusQuery.withRange(true)
    + prometheusQuery.withRefId('diff')
  ,

  diff_over_time(querySet):
    prometheusQuery.new(
      '${%s}' % variables.datasource.name,
      |||
        100 * (
          (  %(current_over_time)s )
          -
          (  %(prev_over_time)s != 0 )
        )
        /
        ( %(prev_over_time)s != 0 ) OR vector(0)
      ||| % querySet
    )
    + prometheusQuery.withLegendFormat('diff')
    + prometheusQuery.withRange(false)
    + prometheusQuery.withInstant(true)
    + prometheusQuery.withRefId('diff')
  ,

  start_prev_current_diff(querySet): [
    self.start,
    self.prev(querySet.prev),
    self.current(querySet.current),
    self.diff(querySet),
  ],

  version:
    [
      prometheusQuery.new(
        '${%s}' % variables.datasource.name,
        'avg by (Version) ({__name__=~"youtrack_version_info|youtrack_version", %(filter)s })' % $
      )
      + prometheusQuery.withRefId('Version')
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(false)
      + prometheusQuery.withRange(true)
      ,
      prometheusQuery.new(
        '${%s}' % variables.datasource.name,
        'avg by (instance, Build) ({__name__=~"youtrack_version_info|youtrack_version", %(filter)s })' % $
      )
      + prometheusQuery.withRefId('Build')
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(false)
      + prometheusQuery.withRange(true),
    ],
  youtrack_Workflow: {
    RuleGuard: {

    },
    OnScheduleFull: {

    },
    Rule: {

    },
  },
  youtrack_HubIntegration: {
    HubEvents: {
      Pending: $.query.avg.set('youtrack_HubIntegration_HubEventsReceived', $.units.none),
      Received_per_minute: $.query.count_per_minute.set('youtrack_HubIntegration_HubEventsReceived'),

      Accepted_per_minute: $.query.one_two_free.set(
            |||
                ( %(one)s )
                + ( %(two)s )
                + ( %(free)s )
            |||,
            $.youtrack_HubIntegration.HubEvents.Processed_per_minute,
            $.youtrack_HubIntegration.HubEvents.Failed_per_minute,
            $.youtrack_HubIntegration.HubEvents.Ignored_per_minute,
            $.units.count_per_minute),

      Ignored_per_minute: $.query.count_per_minute.set('youtrack_HubIntegration_HubEventsIgnored'),
      Failed_per_minute: $.query.count_per_minute.set('youtrack_HubIntegration_HubEventsFailed'),
      Processed_per_minute: $.query.count_per_minute.set('youtrack_HubIntegration_HubEventsProcessed'),


      Ignored_percent: $.query.one_two.set(
            |||
                100 * ( %(one)s )
                / ( ( %(two)s ) != 0 )
            |||,
            $.youtrack_HubIntegration.HubEvents.Ignored_per_minute,
            $.youtrack_HubIntegration.HubEvents.Accepted_per_minute,
            $.units.percent
      ),
      Processed_percent: $.query.one_two.set(
             |||
                 100 * ( %(one)s )
                 / ( ( %(two)s ) != 0 )
             |||,
             $.youtrack_HubIntegration.HubEvents.Processed_per_minute,
             $.youtrack_HubIntegration.HubEvents.Accepted_per_minute,
             $.units.percent
       ),
      Failed_percent: $.query.one_two.set(
              |||
                  100 * ( %(one)s )
                  / ( ( %(two)s ) != 0 )
              |||,
              $.youtrack_HubIntegration.HubEvents.Failed_per_minute,
              $.youtrack_HubIntegration.HubEvents.Accepted_per_minute,
              $.units.percent
        ),
    },
  },
  Xodus_entity_store_metrics: {
    cached_jobs: {
      // ⚙️ Cached Jobs → ✅ Queued → (🟡|🟠) → ❇️ Execute → ✳️ Started → 🚫️ Interrupted → ⌛️ Obsolete | ⏰ Overdue
      Interrupted: {
        // 🚫️ Interrupted
        Interrupted_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsInterrupted'),
        // ⌛️ Obsolete
        Obsolete_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsObsolete'),
        // ⏰ Overdue
        Overdue_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsOverdue'),
        // ⌛️ % Obsolete
        Obsolete_percent: $.query.one_two.set(
            |||
                100 * ( %(one)s )
                / ( ( %(two)s ) != 0 )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Interrupted.Obsolete_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Interrupted.Interrupted_per_sec,
            $.units.percent),
        // ⏰ % Overdue
        Overdue_percent: $.query.one_two.set(
            |||
                 100 * ( %(one)s )
                 / ( ( %(two)s ) != 0 )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Interrupted.Overdue_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Interrupted.Interrupted_per_sec,
            $.units.percent),
      },
      // ⚙️ Cached Jobs → ✅ Queued → (🟡|🟠) → ❇️ Execute → ✳️ Started → ↩️ Retried → 🟡 Consistent | 🟠 Non Consistent
      Retried: {
        // ↩️ Retried
        Retried_per_sec: $.query.one_two.set(
            |||
                ( %(one)s )
                + ( %(two)s )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Retried.Consistent_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Retried.NonConsistent_per_sec,
            $.units.count_per_second
        ),
        // 🟡 Consistent
        Consistent_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsRetried'),
        // 🟠 Non Consistent
        NonConsistent_per_sec: $.query.count_per_second.set('youtrack_TotalCachingCountJobsRetried'),
        // 🟡 % Consistent
        Consistent_percent: $.query.one_two.set(
            |||
              100 * ( %(one)s )
              / ( ( %(two)s ) != 0 )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Retried.Consistent_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Retried.Retried_per_sec,
            $.units.percent
        ),
        // 🟠 % Non Consistent
        NonConsistent_percent: $.query.one_two.set(
           |||
             100 * ( %(one)s )
             / ( ( %(two)s ) != 0 )
           |||,
           $.Xodus_entity_store_metrics.cached_jobs.Retried.NonConsistent_per_sec,
           $.Xodus_entity_store_metrics.cached_jobs.Retried.Retried_per_sec,
           $.units.percent
        ),
      },
      // ⚙️ Cached Jobs → ✅ Queued → (🟡|🟠) → ❇️ Execute → ✳️ Started → ❎ Completed | ↩️ Retried | 🚫️ Interrupted
      Started: {
        // ✳️ Started
        Started_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsStarted'),
        // ❎ Completed
        Completed_per_sec: $.query.one_two_free.set(
            |||
              ( %(one)s )
              - ( %(two)s )
              - ( %(free)s )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Started.Started_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Started.Retried_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Started.Interrupted_per_sec,
            $.units.count_per_second
        ),
        // ↩️ Retried
        Retried_per_sec: $.Xodus_entity_store_metrics.cached_jobs.Retried.Retried_per_sec,
        // 🚫️ Interrupted
        Interrupted_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsInterrupted'),
        // ❎ % Completed
        Completed_percent: $.query.one_two.set(
          |||
            100 * ( %(one)s )
            / ( ( %(two)s ) != 0 )
          |||,
          $.Xodus_entity_store_metrics.cached_jobs.Started.Completed_per_sec,
          $.Xodus_entity_store_metrics.cached_jobs.Started.Started_per_sec,
          $.units.percent
        ),
        // ↩️ % Retried
        Retried_percent: $.query.one_two.set(
           |||
             100 * ( %(one)s )
             / ( ( %(two)s ) != 0 )
           |||,
           $.Xodus_entity_store_metrics.cached_jobs.Started.Retried_per_sec,
           $.Xodus_entity_store_metrics.cached_jobs.Started.Started_per_sec,
           $.units.percent
        ),
        // 🚫️ % Interrupted
        Interrupted_percent: $.query.one_two.set(
            |||
              100 * ( %(one)s )
              / ( ( %(two)s ) != 0 )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Started.Interrupted_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Started.Started_per_sec,
            $.units.percent
        ),
      },
      // ⚙️ Cached Jobs -> Execute -> Started | Not Started
      Execute: {
        // Execute (per 1 second)
        Execute_per_sec: $.query.one_two.set(
             |||
               ( %(one)s )
               + ( %(two)s )
             |||,
             $.Xodus_entity_store_metrics.cached_jobs.Execute.Started_per_sec,
             $.Xodus_entity_store_metrics.cached_jobs.Execute.Not_Started_per_sec,
             $.units.percent
        ),
        // ✅ Started (per 1 second)
        Started_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsStarted'),
        // ❌ Not Started (per 1 second)
        Not_Started_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsNotStarted'),
        // ✅ % Started
        Started_percent: $.query.one_two.set(
             |||
               100 * ( %(one)s )
               / ( ( %(two)s ) != 0 )
             |||,
             $.Xodus_entity_store_metrics.cached_jobs.Execute.Started_per_sec,
             $.Xodus_entity_store_metrics.cached_jobs.Execute.Execute_per_sec,
             $.units.percent
        ),
        // ❌ % Not Started
        Not_Started_percent: $.query.one_two.set(
          |||
            100 * ( %(one)s )
            / ( ( %(two)s ) != 0 )
          |||,
          $.Xodus_entity_store_metrics.cached_jobs.Execute.Not_Started_per_sec,
          $.Xodus_entity_store_metrics.cached_jobs.Execute.Execute_per_sec,
          $.units.percent
        ),
      },
      Queued: {
        // ✅ Consistent (per 1 second)
        Consistent_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsEnqueued'),
        // ❌ Non Consistent (per 1 second)
        Non_Consistent_per_sec: $.query.count_per_second.set('youtrack_TotalCachingCountJobsEnqueued'),
        // ✅ % Consistent ( 100 * Consistent / Queued )
        Consistent_percent:  $.query.one_two.set(
          |||
            100 * ( %(one)s )
            / ( ( %(two)s ) != 0 )
          |||,
          $.Xodus_entity_store_metrics.cached_jobs.Queued.Consistent_per_sec,
          $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.Queued_jobs_per_sec,
          $.units.percent
        ),
        // ❌ % Non Consistent ( 100 * Non Consistent / Queued )
        Non_Consistent_percent: $.query.one_two.set(
          |||
            100 * ( %(one)s )
            / ( ( %(two)s ) != 0 )
          |||,
          $.Xodus_entity_store_metrics.cached_jobs.Queued.Non_Consistent_per_sec,
          $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.Queued_jobs_per_sec,
          $.units.percent
        ),
      },
      Queued__Non_Queued: {
        // ➕ Queued + Not Queued (per 1 second)
        Queued__and__Non_Queued_per_sec: $.query.one_two_free.set(
           |||
             ( %(one)s )
             + ( %(two)s )
             + ( %(free)s )
           |||,
           $.Xodus_entity_store_metrics.cached_jobs.Queued.Consistent_per_sec,
           $.Xodus_entity_store_metrics.cached_jobs.Queued.Non_Consistent_per_sec,
           $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.NotQueued_jobs_per_sec,
           $.units.count_per_second
        ),
        // ✅ Queued (per 1 second)
        Queued_jobs_per_sec: $.query.one_two.set(
            |||
              ( %(one)s )
              + ( %(two)s )
            |||,
            $.Xodus_entity_store_metrics.cached_jobs.Queued.Consistent_per_sec,
            $.Xodus_entity_store_metrics.cached_jobs.Queued.Non_Consistent_per_sec,
            $.units.count_per_second
        ),
        // ❌ Not Queued (per 1 second)
        NotQueued_jobs_per_sec: $.query.count_per_second.set('youtrack_TotalCachingJobsNotQueued'),
        // ✅ % Queued
        Queued_percent: $.query.one_two.set(
          |||
            100 * ( %(one)s )
            / ( ( %(two)s ) != 0 )
          |||,
          $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.Queued_jobs_per_sec,
          $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.Queued__and__Non_Queued_per_sec,
          $.units.percent
        ),
        // ❌ % Not Queued
        NotQueued_percent: $.query.one_two.set(
         |||
           100 * ( %(one)s )
           / ( ( %(two)s ) != 0 )
         |||,
         $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.NotQueued_jobs_per_sec,
         $.Xodus_entity_store_metrics.cached_jobs.Queued__Non_Queued.Queued__and__Non_Queued_per_sec,
         $.units.percent
        ),
      },

    },
  },

  process: {
    cpu: $.query.avg.set('process_cpu_load', $.units.percent_0_1),
    cpu_cores: $.query.count_per_second.set('process_cpu_seconds_total', $.units.none),
    resident_memory: $.query.avg.set('process_resident_memory_bytes', $.units.bytes),
    virtual_memory: $.query.avg.set('process_virtual_memory_bytes', $.units.bytes),
    open_fds: $.query.avg.set('process_open_fds', $.units.none),
  },

  workflows: {
  local youtrack_Workflow_template_by_group_script(metricName, group) =
        |||
          sum_over_time(
              (
                  sum(
                      increase(
                          label_replace(
                              %(metricName)s{
                                  %(filter)s
                              },
                              "group", "%(group)s", "script", ".*"
                          )[%(interval)s:]
                      )
                  ) by (script, group)
              )[$__range:%(interval)s]
          )
        ||| % {group:group, metricName:metricName, filter: $.filter, interval: interval.variable},
  local youtrack_Workflow_template_by_script(metricName) =
        |||
          sum_over_time(
              (
                  sum(
                      increase(
                              %(metricName)s{
                                  %(filter)s
                              }
                          )[%(interval)s:]
                      )
                  ) by (script)
              )[$__range:%(interval)s]
          )
        ||| % {metricName:metricName, filter: $.filter, interval: interval.variable},
      local youtrack_Workflow_template_by_group(metricName, group) =
            |||
              sum_over_time(
                  (
                      sum(
                          increase(
                              label_replace(
                                  %(metricName)s{
                                      %(filter)s
                                  },
                                  "group", "%(group)s", "script", ".*"
                              )[%(interval)s:]
                          )
                      ) by (group)
                  )[$__range:%(interval)s]
              )
            ||| % {metricName:metricName, filter: $.filter, interval: interval.variable},
    Rule: {
      average_failed_per_minute: $.query.count_per_minute.set("youtrack_Workflow_Rule_FailedCount"),
      average_events_per_minute: $.query.count_per_minute.set("youtrack_Workflow_Rule_TotalCount"),
      average_duration_per_minute: $.query.count_per_minute.set("youtrack_Workflow_Rule_TotalDuration", $.units.ms),
      average_duration_per_event: $.query.duration_per_event.set("youtrack_Workflow_Rule_TotalDuration", "youtrack_Workflow_Rule_TotalCount", $.units.ms),
      average_duration_per_hour: $.query.metric_per_time.set("youtrack_Workflow_Rule_TotalDuration", $.units.ms, 3600),
    },
    RuleGuard: {
      average_failed_per_minute: $.query.count_per_minute.set("youtrack_Workflow_RuleGuard_FailedCount"),
      average_events_per_minute: $.query.count_per_minute.set("youtrack_Workflow_RuleGuard_TotalCount"),
      average_duration_per_minute: $.query.count_per_minute.set("youtrack_Workflow_RuleGuard_TotalDuration", $.units.ms),
      average_duration_per_event: $.query.duration_per_event.set("youtrack_Workflow_RuleGuard_TotalDuration", "youtrack_Workflow_RuleGuard_TotalCount", $.units.ms),
      average_duration_per_hour: $.query.metric_per_time.set("youtrack_Workflow_RuleGuard_TotalDuration", $.units.ms, 3600),
    },
    OnScheduleFull: {
      average_failed_per_minute: $.query.count_per_minute.set("youtrack_Workflow_OnScheduleFull_FailedCount"),
      average_events_per_minute: $.query.count_per_minute.set("youtrack_Workflow_OnScheduleFull_TotalCount"),
      average_duration_per_minute: $.query.count_per_minute.set("youtrack_Workflow_OnScheduleFull_TotalDuration", $.units.ms),
      average_duration_per_event: $.query.duration_per_event.set("youtrack_Workflow_OnScheduleFull_TotalDuration", "youtrack_Workflow_OnScheduleFull_TotalCount", $.units.ms),
      average_duration_per_hour: $.query.metric_per_time.set("youtrack_Workflow_OnScheduleFull_TotalDuration", $.units.ms, 3600),
    },
    Rule_Total_by_group_script: {
      TotalDuration_ms: youtrack_Workflow_template_by_group_script("youtrack_Workflow_Rule_TotalDuration", "❇️ Rule"),
      TotalCount: youtrack_Workflow_template_by_group_script("youtrack_Workflow_Rule_TotalCount", "❇️ Rule"),
      FailedCount: youtrack_Workflow_template_by_group_script("youtrack_Workflow_Rule_FailedCount", "❇️ Rule"),
    },
    RuleGuard_Total_by_group_script: {
      TotalDuration_ms: youtrack_Workflow_template_by_group_script("youtrack_Workflow_RuleGuard_TotalDuration", "🛡 Rule Guard"),
      TotalCount: youtrack_Workflow_template_by_group_script("youtrack_Workflow_RuleGuard_TotalCount", "🛡 Rule Guard"),
      FailedCount: youtrack_Workflow_template_by_group_script("youtrack_Workflow_RuleGuard_FailedCount", "🛡 Rule Guard"),
    },
    OnScheduleFull_Total_by_group_script: {
      TotalDuration_ms: youtrack_Workflow_template_by_group_script("youtrack_Workflow_OnScheduleFull_TotalDuration", "🗓 On Schedule Full"),
      TotalCount: youtrack_Workflow_template_by_group_script("youtrack_Workflow_OnScheduleFull_TotalCount", "🗓 On Schedule Full"),
      FailedCount: youtrack_Workflow_template_by_group_script("youtrack_Workflow_OnScheduleFull_FailedCount", "🗓 On Schedule Full"),
    },

        Rule_Total_by_script: {
          TotalDuration_ms: youtrack_Workflow_template_by_script("youtrack_Workflow_Rule_TotalDuration"),
          TotalCount: youtrack_Workflow_template_by_script("youtrack_Workflow_Rule_TotalCount"),
          FailedCount: youtrack_Workflow_template_by_script("youtrack_Workflow_Rule_FailedCount"),
        },
        RuleGuard_Total_by_script: {
          TotalDuration_ms: youtrack_Workflow_template_by_script("youtrack_Workflow_RuleGuard_TotalDuration"),
          TotalCount: youtrack_Workflow_template_by_script("youtrack_Workflow_RuleGuard_TotalCount"),
          FailedCount: youtrack_Workflow_template_by_script("youtrack_Workflow_RuleGuard_FailedCount"),
        },
        OnScheduleFull_Total_by_script: {
          TotalDuration_ms: youtrack_Workflow_template_by_script("youtrack_Workflow_OnScheduleFull_TotalDuration"),
          TotalCount: youtrack_Workflow_template_by_script("youtrack_Workflow_OnScheduleFull_TotalCount"),
          FailedCount: youtrack_Workflow_template_by_script("youtrack_Workflow_OnScheduleFull_FailedCount"),
        },

        Rule_Total_by_group: {
          TotalDuration_ms: youtrack_Workflow_template_by_group("youtrack_Workflow_Rule_TotalDuration", "❇️ Rule"),
          TotalCount: youtrack_Workflow_template_by_group("youtrack_Workflow_Rule_TotalCount", "❇️ Rule"),
          FailedCount: youtrack_Workflow_template_by_group("youtrack_Workflow_Rule_FailedCount", "❇️ Rule"),
        },
        RuleGuard_Total_by_group: {
          TotalDuration_ms: youtrack_Workflow_template_by_group("youtrack_Workflow_RuleGuard_TotalDuration", "🛡 Rule Guard"),
          TotalCount: youtrack_Workflow_template_by_group("youtrack_Workflow_RuleGuard_TotalCount", "🛡 Rule Guard"),
          FailedCount: youtrack_Workflow_template_by_group("youtrack_Workflow_RuleGuard_FailedCount", "🛡 Rule Guard"),
        },
        OnScheduleFull_Total_by_group: {
          TotalDuration_ms: youtrack_Workflow_template_by_group("youtrack_Workflow_OnScheduleFull_TotalDuration", "🗓 On Schedule Full"),
          TotalCount: youtrack_Workflow_template_by_group("youtrack_Workflow_OnScheduleFull_TotalCount", "🗓 On Schedule Full"),
          FailedCount: youtrack_Workflow_template_by_group("youtrack_Workflow_OnScheduleFull_FailedCount", "🗓 On Schedule Full"),
        },
  },
}
