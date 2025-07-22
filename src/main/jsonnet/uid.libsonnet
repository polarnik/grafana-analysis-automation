local get_EXT_SOURCE_TYPE() =
    if (std.extVar("EXT_SOURCE_TYPE") == "vm_promql") then
        "vm"
    else if (std.extVar("EXT_SOURCE_TYPE") == "thanos_qf") then
        "thanos"
    else
        "prom"
    ;

local get_EXT_THEME() =
    if (std.extVar("EXT_THEME") == "blue_white_red") then
        "1"
    else if (std.extVar("EXT_THEME") == "rainbow") then
        "2"
    else if (std.extVar("EXT_THEME") == "white_rainbow") then
        "3"
    else
        "0"
    ;


local get_EXT_DIFF_TYPE() =
    if (std.extVar("EXT_DIFF_TYPE") == "current_prev") then
        "1"
    else if (std.extVar("EXT_DIFF_TYPE") == "current_several_prevs") then
        "2"
    else if (std.extVar("EXT_DIFF_TYPE") == "z_score") then
        "3"
    else
        "0"
    ;
{
    "uid": get_EXT_SOURCE_TYPE() + get_EXT_THEME() + get_EXT_DIFF_TYPE()
}