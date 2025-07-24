local g = import 'g.libsonnet';
local uid = import 'uid.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.promql.thanos.libsonnet';
local annotations = import './annotations.libsonnet';

annotations
+ g.dashboard.new('YouTrack Workflow Details')
+ g.dashboard.withDescription(|||
  Dashboard with details about some YouTrack Workflow
|||)
+ g.dashboard.withUid('yt_workflow_details_' + uid.uid)
+ g.dashboard.withTags([
  'YouTrack Server' + ' ' + uid.uid,
  'YouTrack Workflows' + ' ' + uid.uid,
])
+ panels.links(['YouTrack Server' + ' ' + uid.uid, 'YouTrack Workflows' + ' ' + uid.uid])
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
