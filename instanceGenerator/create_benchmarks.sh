#!/bin/bash

x=3
y=3
z=1
seed=1000
instr_count=4
instr_min=50
instr_max=250
comm_delay=2
map_min=2
map_max=4
cost_min=20
cost_max=50
pow_min=20
pow_max=50
ipc_min=1
ipc_max=4
epi_min=2
epi_max=5

#pattern="2,2,3,4"
GenDir=/mnt/c/Users/kn165/Uni/Projekte/asp-dse/instanceGenerator
DestDir=/mnt/c/Users/kn165/Uni/Projekte/asp-dse/instanceGenerator/benchmarks_format_2021_11
Graph="/mnt/c/Users/kn165/Uni/Workspace/QT/Graph/build/bin/Graph"

#$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir

pattern="10,10"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="10,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,10"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,4"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="6,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="6,8"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="8,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="8,8"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir

pattern="3,4,7,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="3,5,3,5"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,5,5,7"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="5,6,3,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="7,5,5,8"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="7,6,9,7"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
z=2
pattern="2,3,2,5,6,5"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="3,4,0,7,5,12"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="3,5,2,5,5,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,5,2,8,4,10"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="6,8,5,9,10,5"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="7,6,4,9,7,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="7,9,6,6,3,2"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="8,7,7,9,10,8"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
z=3	
pattern="10,8,7,5,1,4,6,8"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="1,3,2,3,3,4,4,5"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="3,4,1,4,5,3,7,4"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="3,7,3,5,4,9,8,7"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,10,5,2,6,5,2,7"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,3,7,9,7,10,9,12"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="4,6,2,4,3,7,8,6"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
pattern="5,4,3,3,4,5,5,7"
$Graph -platform offscreen --generate $x $y $z $seed $comm_delay $map_min $map_max $pow_min $pow_max $cost_min $cost_max $instr_count $instr_min $instr_max $ipc_min $ipc_max $epi_min $epi_max $pattern $GenDir $DestDir
