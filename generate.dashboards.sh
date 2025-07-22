#!/bin/zsh

BASE=$(pwd)
WORKDIR=$BASE/target/jsonnet
JSONNET=sjsonnet.jar

jb install github.com/grafana/grafonnet/gen/grafonnet-v11.4.0@main


if [ ! -f $WORKDIR ]; then
  mkdir -p $WORKDIR
fi

if [ ! -f $WORKDIR/$JSONNET ]; then
  echo "💤 Download sjsonnet"
  curl --output $WORKDIR/$JSONNET \
  -L https://github.com/databricks/sjsonnet/releases/download/0.5.3/sjsonnet-0.5.3.jar
  echo "✅  Download sjsonnet complete"

  chmod +x $WORKDIR/$JSONNET
fi

compile_a_dashboard () {

array_source_type=( thanos_qf vm_promql)
diff_array=(current_prev current_several_prevs z_score)
theme_array=(blue_white_red rainbow white_rainbow)

for EXT_SOURCE_TYPE in "${array_source_type[@]}"
do
  for EXT_DIFF_TYPE in "${diff_array[@]}"
  do
    for EXT_THEME in "${theme_array[@]}"
    do
      echo "💤 $EXT_SOURCE_TYPE/$EXT_DIFF_TYPE/$EXT_THEME/$1"
          "$WORKDIR/$JSONNET" \
            --strict   \
            --fatal-warnings --throw-error-for-invalid-sets \
            --indent 4 \
            --ext-str EXT_SOURCE_TYPE=$EXT_SOURCE_TYPE \
            --ext-str EXT_DIFF_TYPE=$EXT_DIFF_TYPE \
            --ext-str EXT_THEME=$EXT_THEME \
            -J vendor  \
            --reverse-jpaths-priority \
            --create-output-dirs \
            --output-file "$2/$EXT_SOURCE_TYPE/$EXT_DIFF_TYPE/$EXT_THEME/$1.json" \
            "$BASE/src/main/jsonnet/$1.jsonnet"
      echo "✅  $EXT_SOURCE_TYPE/$EXT_DIFF_TYPE/$EXT_THEME/$1"
    done
  done
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
