local g = import 'g.libsonnet';
local uid = import 'uid.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.promql.thanos.libsonnet';
local cached_jobs = queries.Xodus_entity_store_metrics.cached_jobs;
local annotations = import './annotations.libsonnet';

annotations
+ g.dashboard.new('Xodus storage: ✅ Queued → 🟡 Consistent | 🟠 Non Consistent')
+ g.dashboard.withDescription(|||
  YouTrack Xodus entity store metrics (DB):
   →
  ✅ Queued →
  🟡 Consistent | 🟠 Non Consistent
|||)
+ g.dashboard.withUid('xodus_storage_queued_' + uid.uid)
+ g.dashboard.withTags([
  'YouTrack Server' + ' ' + uid.uid,
  'Xodus' + ' ' + uid.uid,
  'Xodus Entity' + ' ' + uid.uid,
  '✅ Queued' + ' ' + uid.uid,
  '🟡 Consistent' + ' ' + uid.uid,
  '🟠 Non Consistent' + ' ' + uid.uid,
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

      row.new('ℹ️ Info: ✅ Queued → 🟡 Consistent | 🟠 Non Consistent'),
      //      + row.withCollapsed(true)
      //      + row.withPanels([
      panels.texts.image('https://polarnik.github.io/youtrack-monitoring/Cached-Enqueued.png')
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
      row.new('✅ Queued → 🟡 Consistent | 🟠 Non Consistent'),
      // ✅ Queued
      panels.combo.stat.a_bigger_value_is_better(
        '✅ Queued',
        queries.diff_over_time(cached_jobs.Queued__Non_Queued.Queued_jobs_per_sec)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '✅ Queued (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Queued__Non_Queued.Queued_jobs_per_sec),
        cached_jobs.Queued__Non_Queued.Queued_jobs_per_sec.unit
      ),

      // 🟡 Consistent
      panels.combo.stat.a_bigger_value_is_better(
        '🟡 Consistent',
        queries.diff_over_time(cached_jobs.Queued.Consistent_per_sec)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🟡 Consistent (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Queued.Consistent_per_sec),
        cached_jobs.Queued.Consistent_per_sec.unit
      ),

      // 🟠 Non Consistent
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🟠 Non Consistent',
        queries.diff_over_time(cached_jobs.Queued.Non_Consistent_per_sec)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🟠 Non Consistent (per 1 second)',
        queries.start_prev_current_diff(cached_jobs.Queued.Non_Consistent_per_sec),
        cached_jobs.Queued__Non_Queued.NotQueued_jobs_per_sec.unit
      ),

      // 🟡️ % Consistent
      panels.combo.stat.a_bigger_value_is_better(
        '🟡️ % Consistent',
        queries.diff_over_time(cached_jobs.Queued.Consistent_percent)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🟡️ % Consistent (🟡️ Consistent / ✅ Queued)',
        queries.start_prev_current_diff(cached_jobs.Queued.Consistent_percent),
        cached_jobs.Queued.Consistent_percent.unit
      ),

      // 🟠 % Non Consistent
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🟠 % Non Consistent',
        queries.diff_over_time(cached_jobs.Queued.Non_Consistent_percent)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🟠 % Non Consistent (🟠 Non Consistent / ✅ Queued)',
        queries.start_prev_current_diff(cached_jobs.Queued.Non_Consistent_percent),
        cached_jobs.Queued.Non_Consistent_percent.unit
      ),

    ], 20, 7, 0
  )
)
