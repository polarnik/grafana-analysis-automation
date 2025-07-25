local g = import 'g.libsonnet';
local uid = import 'uid.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.promql.thanos.libsonnet';
local cached_jobs = queries.Xodus_entity_store_metrics.cached_jobs;
local annotations = import './annotations.libsonnet';

annotations
+ g.dashboard.new('Xodus storage: ✳️ Started → ❎ Completed | ↩️ Retried | 🚫️ Interrupted')
+ g.dashboard.withDescription(|||
  YouTrack Xodus entity store metrics (DB):
  ⚙️ Cached Jobs →
  ✅ Queued →
  (🟡 Consistent | 🟠 Non Consistent) →
  🛠 Execute →
  ✳️ Started →
  ❎ Completed | ↩️ Retried | 🚫️ Interrupted
|||)
+ g.dashboard.withUid('xodus_storage_started_' + uid.uid)
+ g.dashboard.withTags([
  'YouTrack Server' + ' ' + uid.uid,
  'Xodus' + ' ' + uid.uid,
  'Xodus Entity' + ' ' + uid.uid,
  '✳️ Started' + ' ' + uid.uid,
  '❎ Completed' + ' ' + uid.uid,
  '↩️ Retried' + ' ' + uid.uid,
  '🚫️ Interrupted' + ' ' + uid.uid,
])
+ panels.links(['YouTrack Server' + ' ' + uid.uid, 'Xodus' + ' ' + uid.uid, 'Xodus Entity' + ' ' + uid.uid])
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.datasource,
  variables.offset,
  variables.instance,
  variables.app_start,
])
+ g.dashboard.withPanels(
  g.util.grid.wrapPanels(
    [
      // Version
      row.new('Version'),
      panels.texts.version,
      panels.timeseries.version('Version', queries.version),

      // ⚙️ Cached Jobs → Queued | Non Queued
      row.new('ℹ️ Info: ✳️ Started → ❎ Completed | ↩️ Retried | 🚫️ Interrupted'),
      //      + row.withCollapsed(true)
      //      + row.withPanels([
      panels.texts.image('https://polarnik.github.io/youtrack-monitoring/Execute-Started.png')
      + {
        gridPos: {
          h: 8,
          w: 12,
          x: 0,
          y: 9,
        },
      },
      panels.diagram.base(),
      //      ]),
      /*
      %%{ init: { 'flowchart': { 'curve': 'monotoneX' } } }%%
      flowchart LR
          A(⚙️ Cached Jobs) ==> B(✅ Queued)
          A(⚙️ Cached Jobs) -.-> C(❌ Non Queued)
          B ==> D(🟡 Consistent)
          B ==> E(🟠 Non Consistent)
          D ==> F(🛠 Execute)
          E ==> F
          F ==> G(✳️ Started)
          F -.-> H(⛔️ Not Started)
          G -.-> I(↩️ Retried)
          G ==> J(❎ Completed)
          G -.-> K(🚫️ Interrupted)
          I -.-> L(🟡 Consistent)
          I -.-> M(🟠 Non Consistent)
          K -.-> N(⌛️ Obsolete)
          K -.-> O(⏰ Overdue)
      */

      row.new('✳️ Started → ❎ Completed | ↩️ Retried | 🚫️ Interrupted'),
      // ✳️ Started
      panels.combo.stat.a_bigger_value_is_better(
        '✳️ Started',
        queries.diff_over_time(cached_jobs.Started.Started_per_sec)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '✳️ Started (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Started.Started_per_sec),
        cached_jobs.Started.Started_per_sec.unit
      ),

      // ✳️ Completed
      panels.combo.stat.a_bigger_value_is_better(
        '✳️ Completed',
        queries.diff_over_time(cached_jobs.Started.Completed_per_sec)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '✳️ Completed (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Started.Completed_per_sec),
        cached_jobs.Started.Completed_per_sec.unit
      ),

      // ↩️ Retried
      panels.combo.stat.a_bigger_value_is_a_problem(
        '↩️ Retried',
        queries.diff_over_time(cached_jobs.Started.Retried_per_sec)
      )
      + panels.link_panel(
        [{ title: '↩️ Retried', UID: 'xodus_storage_retried_' + uid.uid }]
      )
      + g.panel.stat.standardOptions.withLinksMixin(panels.one_link('↩️ Retried', 'xodus_storage_retried_' + uid.uid))
      ,
      panels.combo.timeSeries.current_vs_prev(
        '↩️ Retried (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Started.Retried_per_sec),
        cached_jobs.Started.Retried_per_sec.unit
      )
      + panels.link_panel(
        [{ title: '↩️ Retried', UID: 'xodus_storage_retried_' + uid.uid }]
      )
      ,

      // 🚫️ Interrupted
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🚫️ Interrupted',
        queries.diff_over_time(cached_jobs.Started.Interrupted_per_sec)
      )
      + panels.link_panel(
        [{ title: '🚫️ Interrupted', UID: 'xodus_storage_interrupted_' + uid.uid }]
      )
      + g.panel.stat.standardOptions.withLinksMixin(panels.one_link('🚫️ Interrupted', 'xodus_storage_interrupted_' + uid.uid))
      ,
      panels.combo.timeSeries.current_vs_prev(
        '🚫️ Interrupted (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Started.Interrupted_per_sec),
        cached_jobs.Started.Interrupted_per_sec.unit
      )
      + panels.link_panel(
        [{ title: '🚫️ Interrupted', UID: 'xodus_storage_interrupted_' + uid.uid }]
      )
      ,

      // ✳️ % Completed
      panels.combo.stat.a_bigger_value_is_better(
        '✳️ % Completed',
        queries.diff_over_time(cached_jobs.Started.Completed_percent)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '✳️ % Completed (100 * ✳️ Completed / ✳️ Started)',
        queries.start_prev_current_diff(cached_jobs.Started.Completed_percent),
        cached_jobs.Started.Completed_percent.unit
      ),

      // ↩️ % Retried
      panels.combo.stat.a_bigger_value_is_a_problem(
        '↩️ % Retried',
        queries.diff_over_time(cached_jobs.Started.Retried_percent)
      )
      + panels.link_panel(
        [{ title: '↩️ Retried', UID: 'xodus_storage_retried_' + uid.uid }]
      )
      + g.panel.stat.standardOptions.withLinksMixin(panels.one_link('↩️ Retried', 'xodus_storage_retried_' + uid.uid))
      ,
      panels.combo.timeSeries.current_vs_prev(
        '↩️ % Retried (100 * ↩️ Retried / ✳️ Started)',
        queries.start_prev_current_diff(cached_jobs.Started.Retried_percent),
        cached_jobs.Started.Retried_percent.unit
      )
      + panels.link_panel(
        [{ title: '↩️ Retried', UID: 'xodus_storage_retried_' + uid.uid }]
      )
      ,

      // 🚫️ % Interrupted
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🚫️ % Interrupted',
        queries.diff_over_time(cached_jobs.Started.Interrupted_percent)
      )
      + panels.link_panel(
        [{ title: '🚫️ Interrupted', UID: 'xodus_storage_interrupted' }]
      )
      + g.panel.stat.standardOptions.withLinksMixin(panels.one_link('🚫️ Interrupted', 'xodus_storage_interrupted_' + uid.uid))
      ,
      panels.combo.timeSeries.current_vs_prev(
        '🚫️ % Interrupted (100 * 🚫️ Interrupted / ✳️ Started)',
        queries.start_prev_current_diff(cached_jobs.Started.Interrupted_percent),
        cached_jobs.Started.Interrupted_percent.unit
      )
      + panels.link_panel(
        [{ title: '🚫️ Interrupted', UID: 'xodus_storage_interrupted_' + uid.uid }]
      ),

    ], 20, 7, 0
  )
)
