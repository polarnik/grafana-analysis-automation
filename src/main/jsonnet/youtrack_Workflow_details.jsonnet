local g = import 'g.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.promql.thanos.libsonnet';
local annotations = import './annotations.libsonnet';

annotations
+ g.dashboard.new('YouTrack Workflow Details (' + std.extVar("EXT_SOURCE_TYPE") + ')')
+ g.dashboard.withDescription(|||
  Dashboard with details about some YouTrack Workflow
|||)
+ g.dashboard.withUid('yt_workflow_details_' + std.extVar("EXT_SOURCE_TYPE"))
+ g.dashboard.withTags([
  'YouTrack Server',
  'YouTrack Workflows'
])
+ panels.links(['YouTrack Server', 'YouTrack Workflows'])
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.datasource,
  variables.offset,
  variables.instance,
  variables.app_start,
  variables.workflow_group,
  variables.workflow_script,
])
+ g.dashboard.withPanels(
  g.util.grid.wrapPanels(
    [
      // Version
      row.new('Version'),
      panels.texts.version,
      panels.timeseries.version('Version', queries.version),

    ], 20, 7, 0
  )
)