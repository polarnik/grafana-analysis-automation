#!/bin/zsh

BASE=$(pwd)
WORKDIR=$BASE/target/jsonnet
JSONNET=sjsonnet.jar

jb install github.com/grafana/grafonnet/gen/grafonnet-v11.6.3@main


if [ ! -f $WORKDIR ]; then
  mkdir -p $WORKDIR
fi

jb install github.com/grafana/grafonnet/gen/grafonnet-v11.6.3@main

if [ ! -f $WORKDIR/$JSONNET ]; then
  echo "💤 Download sjsonnet"
  curl --output $WORKDIR/$JSONNET \
  -L https://github.com/databricks/sjsonnet/releases/download/0.4.14/sjsonnet-0.4.14.jar
  echo "✅  Download sjsonnet complete"

  chmod +x $WORKDIR/$JSONNET
fi

compile_a_dashboard () {

array=( thanos_qf vm_promql)

for EXT_SOURCE_TYPE in "${array[@]}"
do
  echo "💤 $1.$EXT_SOURCE_TYPE"
      "$WORKDIR/$JSONNET" \
        --strict --strict-import-syntax \
        --fatal-warnings --throw-error-for-invalid-sets \
        --indent 4 \
        --ext-str EXT_SOURCE_TYPE=$EXT_SOURCE_TYPE \
        --no-duplicate-keys-in-comprehension \
        -J "$WORKDIR/vendor"  \
        --output-file "$2/$1.$EXT_SOURCE_TYPE.json" \
        "$BASE/src/main/jsonnet/$1.jsonnet"
  echo "✅  $1.$EXT_SOURCE_TYPE"
done
}


OUTPUTFOLDER=$BASE/configs/grafana/provisioning/dashboards/youtrack


compile_a_dashboard youtrack_HubIntegration $OUTPUTFOLDER
compile_a_dashboard youtrack_process $OUTPUTFOLDER
compile_a_dashboard youtrack_Workflow_details $OUTPUTFOLDER
compile_a_dashboard youtrack_Workflows $OUTPUTFOLDER
compile_a_dashboard youtrack_XodusStorage_CachedJobs $OUTPUTFOLDER
compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued $OUTPUTFOLDER
compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute $OUTPUTFOLDER
compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute_Started $OUTPUTFOLDER
compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute_Started_Interrupted $OUTPUTFOLDER
compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute_Started_Retried $OUTPUTFOLDER
