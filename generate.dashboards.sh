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
  -L https://github.com/databricks/sjsonnet/releases/download/0.4.12/sjsonnet-0.4.12.jar
  echo "✅  Download sjsonnet complete"

  chmod +x $WORKDIR/$JSONNET
fi

compile_a_dashboard () {
  echo "💤 $3/$4/$5/$1"
  jsonnet -J vendor \
  --output-file "$2/$3/$4/$5/$1.json" \
      --ext-str EXT_SOURCE_TYPE=$3 \
      --ext-str EXT_DIFF_TYPE=$4 \
      --ext-str EXT_THEME=$5 \
      --create-output-dirs \
       --max-stack 1024 \
      --max-trace 4000 \
  "$BASE/src/main/jsonnet/$1.jsonnet"

#  java  -jar "$WORKDIR/$JSONNET" \
#    -i jsonnet--strict  \
#    --preserve-order \
#    --fatal-warnings  \
#    --indent 4 \
#    --ext-str EXT_SOURCE_TYPE=$3 \
#    --ext-str EXT_DIFF_TYPE=$4 \
#    --ext-str EXT_THEME=$5 \
#    -J vendor  \
#    --create-output-dirs \
#    --output-file "$2/$3/$4/$5/$1.json" \
#    "$BASE/src/main/jsonnet/$1.jsonnet"
}


OUTPUTFOLDER=$BASE/configs/grafana/provisioning/dashboards/youtrack


array_source_type=( thanos_qf vm_promql)
diff_array=(current_prev current_several_prevs z_score)
diff_array=( current_several_prevs)
theme_array=(blue_white_red rainbow white_rainbow)
theme_array=(blue_white_red rainbow)

for EXT_SOURCE_TYPE in "${array_source_type[@]}"
do
  for EXT_DIFF_TYPE in "${diff_array[@]}"
  do
    for EXT_THEME in "${theme_array[@]}"
    do
      compile_a_dashboard youtrack_HubIntegration $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_process $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_Workflow_details $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_Workflows $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_XodusStorage_CachedJobs $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute_Started $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute_Started_Interrupted $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
      compile_a_dashboard youtrack_XodusStorage_CachedJobs_Queued_Execute_Started_Retried $OUTPUTFOLDER $EXT_SOURCE_TYPE $EXT_DIFF_TYPE $EXT_THEME
    done
  done
done