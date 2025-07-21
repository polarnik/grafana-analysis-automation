{
    min_interval: '30s',
    variable: if(std.extVar("EXT_SOURCE_TYPE") == "vm_promql") then "$__interval" else "$__rate_interval",
}