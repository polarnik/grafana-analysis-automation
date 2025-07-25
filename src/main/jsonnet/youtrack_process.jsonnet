local g = import 'g.libsonnet';
local uid = import 'uid.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.promql.thanos.libsonnet';
local annotations = import './annotations.libsonnet';

annotations
+ g.dashboard.new('YouTrack Process')
+ g.dashboard.withDescription(|||
  Dashboard for YouTrack based processes
|||)
+ g.dashboard.withUid('yt_process_' + uid.uid)
+ g.dashboard.withTags([
  'YouTrack Server' + ' ' + uid.uid,
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

      // CPU
      row.new('🧮 CPU'),
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🧮 CPU %', queries.diff_over_time(queries.process.cpu)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🧮 CPU %', queries.start_prev_current_diff(queries.process.cpu), queries.process.cpu.unit
      ),

      panels.combo.stat.a_bigger_value_is_a_problem(
        '🧮 CPU Cores', queries.diff_over_time(queries.process.cpu_cores)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🧮 CPU Cores', queries.start_prev_current_diff(queries.process.cpu_cores), queries.process.cpu_cores.unit
      ),

      // Memory
      row.new('🖼 Memory'),
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🖼 Resident Memory', queries.diff_over_time(queries.process.resident_memory)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🖼 Resident Memory', queries.start_prev_current_diff(queries.process.resident_memory), queries.process.resident_memory.unit
      ),

      panels.combo.stat.a_bigger_value_is_a_problem(
        '🖼 Virtual Memory', queries.diff_over_time(queries.process.virtual_memory)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🖼 Virtual Memory', queries.start_prev_current_diff(queries.process.virtual_memory), queries.process.virtual_memory.unit
      ),

      //File Descriptors
      row.new('🗂 File Descriptors'),
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🗂 FDS', queries.diff_over_time(queries.process.open_fds)
      ),
      panels.combo.timeSeries.current_vs_prev(
        '🗂 FDS', queries.start_prev_current_diff(queries.process.open_fds), queries.process.open_fds.unit
      ),
    ], 20, 7, 0
  )
)
