local g = import 'g.libsonnet';
local uid = import 'uid.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.promql.thanos.libsonnet';
local hub = queries.youtrack_HubIntegration;
local annotations = import './annotations.libsonnet';

annotations
+ g.dashboard.new('YouTrack HubIntegration')
+ g.dashboard.withDescription(|||
  YouTrack HubIntegration metrics:
  ⚙️ Received, ✅ Processed, ⛔️ Ignored, ⌛️ Pending, ❌ Failed,
|||)
+ g.dashboard.withUid('yt_hubint_' + uid.uid)
+ g.dashboard.withTags([
  'YouTrack Server' + ' ' + uid.uid,
  'HubIntegration' + ' ' + uid.uid,
])
+ panels.links(['YouTrack Server' + ' ' + uid.uid])
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

      row.new('ℹ️ Info')
      + row.withCollapsed(true),

      row.new('YouTrack HubIntegration: ⚙️ Received, ⌛️ Pending'),

      panels.combo.stat.a_bigger_value_is_better(
        '⚙️ Received',
        queries.diff_over_time(hub.HubEvents.Received_per_minute)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '⚙️ Received (per 1 minute)',
        queries.start_prev_current_diff(hub.HubEvents.Received_per_minute),
        hub.HubEvents.Received_per_minute.unit
      )
      ,

      // ⌛️ Pending
      panels.combo.stat.a_bigger_value_is_a_problem(
        '⌛️ Pending',
        queries.diff_over_time(hub.HubEvents.Pending)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '⌛️ Pending (average Queue lenght)',
        queries.start_prev_current_diff(hub.HubEvents.Pending),
        hub.HubEvents.Pending.unit
      )
      ,


      row.new('YouTrack HubIntegration (percents): ⛔️ Ignored, ✅ Processed, ❌ Failed'),

      // ⛔️ % Ignored
      panels.combo.stat.a_bigger_value_is_a_problem(
        '⛔️ % Ignored',
        queries.diff_over_time(hub.HubEvents.Ignored_percent)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '⛔️ % Ignored: skip all events caused by internal actions',
        queries.start_prev_current_diff(hub.HubEvents.Ignored_percent),
        hub.HubEvents.Ignored_percent.unit
      )
      ,

      // ✅ % Processed
      panels.combo.stat.a_bigger_value_is_better(
        '✅ % Processed',
        queries.diff_over_time(hub.HubEvents.Processed_percent)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '✅ % Processed',
        queries.start_prev_current_diff(hub.HubEvents.Processed_percent),
        hub.HubEvents.Processed_percent.unit
      )
      ,

      // ❌ % Failed
      panels.combo.stat.a_bigger_value_is_a_problem(
        '❌ % Failed',
        queries.diff_over_time(hub.HubEvents.Failed_percent)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '❌ % Failed: see error messages "Got exception while processing Ring event" in logs',
        queries.start_prev_current_diff(hub.HubEvents.Failed_percent),
        hub.HubEvents.Failed_percent.unit
      )
      ,

      row.new('YouTrack HubIntegration (events per minute): ⛔️ Ignored, ✅ Processed, ❌ Failed'),

      // ⛔️ Ignored
      panels.combo.stat.a_bigger_value_is_a_problem(
        '⛔️ Ignored',
        queries.diff_over_time(hub.HubEvents.Ignored_per_minute)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '⛔️ Ignored (per 1 minute): skip all events caused by internal actions',
        queries.start_prev_current_diff(hub.HubEvents.Ignored_per_minute),
        hub.HubEvents.Ignored_per_minute.unit
      )
      ,

      // ✅ Processed
      panels.combo.stat.a_bigger_value_is_better(
        '✅ Processed',
        queries.diff_over_time(hub.HubEvents.Processed_per_minute)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '✅ Processed (per 1 minute)',
        queries.start_prev_current_diff(hub.HubEvents.Processed_per_minute),
        hub.HubEvents.Processed_per_minute.unit
      )
      ,

      // ❌ Failed
      panels.combo.stat.a_bigger_value_is_a_problem(
        '❌ Failed',
        queries.diff_over_time(hub.HubEvents.Failed_per_minute)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '❌ Failed (per 1 minute): see error messages "Got exception while processing Ring event" in logs',
        queries.start_prev_current_diff(hub.HubEvents.Failed_per_minute),
        hub.HubEvents.Failed_per_minute.unit
      ),

    ], 20, 7, 0
  )
)
