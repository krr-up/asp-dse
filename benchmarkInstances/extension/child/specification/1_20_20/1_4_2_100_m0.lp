application(a1).
task(t13xa1,a1).
task(t14xa1,a1).
task(t15xa1,a1).
task(t16,a1).
task(t17xa1,a1).
task(t18xa1,a1).
task(t19xa1,a1).
task(t20xa1,a1).
task(t22xa1,a1).
task(t23xa1,a1).
task(t24xa1,a1).
task(t2xa1,a1).
task(t3xa1,a1).
task(t5xa1,a1).
task(t9xa1,a1).
comm(c13x15xa1,a1).
comm(c14x17xa1,a1).
comm(c15,a1).
comm(c15x14xa1,a1).
comm(c16,a1).
comm(c17,a1).
comm(c17x19xa1,a1).
comm(c17x20xa1,a1).
comm(c18x3xa1,a1).
comm(c19x18xa1,a1).
comm(c20x18xa1,a1).
comm(c23x22xa1,a1).
comm(c24x22xa1,a1).
comm(c3x2xa1,a1).
comm(c5x9xa1,a1).
comm(c9x13xa1,a1).
read(t15xa1,c13x15xa1).
read(t17xa1,c14x17xa1).
read(t23xa1,c15).
read(t14xa1,c15x14xa1).
read(t24xa1,c16).
read(t16,c17).
read(t19xa1,c17x19xa1).
read(t20xa1,c17x20xa1).
read(t3xa1,c18x3xa1).
read(t18xa1,c19x18xa1).
read(t18xa1,c20x18xa1).
read(t22xa1,c23x22xa1).
read(t22xa1,c24x22xa1).
read(t2xa1,c3x2xa1).
read(t9xa1,c5x9xa1).
read(t13xa1,c9x13xa1).
send(t13xa1,c13x15xa1).
send(t14xa1,c14x17xa1).
send(t2xa1,c15).
send(t15xa1,c15x14xa1).
send(t2xa1,c16).
send(t22xa1,c17).
send(t17xa1,c17x19xa1).
send(t17xa1,c17x20xa1).
send(t18xa1,c18x3xa1).
send(t19xa1,c19x18xa1).
send(t20xa1,c20x18xa1).
send(t23xa1,c23x22xa1).
send(t24xa1,c24x22xa1).
send(t3xa1,c3x2xa1).
send(t5xa1,c5x9xa1).
send(t9xa1,c9x13xa1).
processor(p1,1,1,1).
resourceCost(p1,46).
staticPower(p1,25).
processor(p10,1,3,2).
resourceCost(p10,30).
staticPower(p10,30).
processor(p2,2,1,1).
resourceCost(p2,43).
staticPower(p2,26).
processor(p3,3,1,1).
resourceCost(p3,22).
staticPower(p3,46).
processor(p4,1,2,1).
resourceCost(p4,39).
staticPower(p4,40).
processor(p5,2,2,1).
resourceCost(p5,41).
staticPower(p5,46).
processor(p6,3,2,1).
resourceCost(p6,24).
staticPower(p6,27).
processor(p7,1,3,1).
resourceCost(p7,50).
staticPower(p7,31).
processor(p8,2,3,1).
resourceCost(p8,38).
staticPower(p8,50).
processor(p9,3,3,1).
resourceCost(p9,12).
staticPower(p9,19).
router(r1,1,1,1).
resourceCost(r1,33).
staticPower(r1,43).
router(r10,1,3,2).
resourceCost(r10,30).
staticPower(r10,30).
router(r2,2,1,1).
resourceCost(r2,43).
staticPower(r2,49).
router(r3,3,1,1).
resourceCost(r3,32).
staticPower(r3,29).
router(r4,1,2,1).
resourceCost(r4,21).
staticPower(r4,36).
router(r5,2,2,1).
resourceCost(r5,46).
staticPower(r5,36).
router(r6,3,2,1).
resourceCost(r6,26).
staticPower(r6,41).
router(r7,1,3,1).
resourceCost(r7,30).
staticPower(r7,45).
router(r8,2,3,1).
resourceCost(r8,42).
staticPower(r8,42).
router(r9,3,3,1).
resourceCost(r9,20).
staticPower(r9,26).
link(l43,p10,r10).
link(l44,r10,p10).
link(l45,r10,r7).
link(l46,r7,r10).
link(lp1xr1,p1,r1).
link(lp2xr2,p2,r2).
link(lp3xr3,p3,r3).
link(lp4xr4,p4,r4).
link(lp5xr5,p5,r5).
link(lp6xr6,p6,r6).
link(lp7xr7,p7,r7).
link(lp8xr8,p8,r8).
link(lp9xr9,p9,r9).
link(lr1xp1,r1,p1).
link(lr1xr2,r1,r2).
link(lr1xr4,r1,r4).
link(lr2xp2,r2,p2).
link(lr2xr1,r2,r1).
link(lr2xr3,r2,r3).
link(lr2xr5,r2,r5).
link(lr3xp3,r3,p3).
link(lr3xr2,r3,r2).
link(lr3xr6,r3,r6).
link(lr4xp4,r4,p4).
link(lr4xr1,r4,r1).
link(lr4xr5,r4,r5).
link(lr4xr7,r4,r7).
link(lr5xp5,r5,p5).
link(lr5xr2,r5,r2).
link(lr5xr4,r5,r4).
link(lr5xr6,r5,r6).
link(lr5xr8,r5,r8).
link(lr6xp6,r6,p6).
link(lr6xr3,r6,r3).
link(lr6xr5,r6,r5).
link(lr6xr9,r6,r9).
link(lr7xp7,r7,p7).
link(lr7xr4,r7,r4).
link(lr7xr8,r7,r8).
link(lr8xp8,r8,p8).
link(lr8xr5,r8,r5).
link(lr8xr7,r8,r7).
link(lr8xr9,r8,r9).
link(lr9xp9,r9,p9).
link(lr9xr6,r9,r6).
link(lr9xr8,r9,r8).
map(mt0xa1xp10,t3xa1,p10).
executionTime(mt0xa1xp10,100).
dynamicEnergy(mt0xa1xp10,1000).
map(mt0xa1xp5,t16,p5).
executionTime(mt0xa1xp5,100).
dynamicEnergy(mt0xa1xp5,1000).
map(mt0xa1xp7,t16,p7).
executionTime(mt0xa1xp7,100).
dynamicEnergy(mt0xa1xp7,1000).
map(mt13xa1xp1,t13xa1,p1).
executionTime(mt13xa1xp1,290).
dynamicEnergy(mt13xa1xp1,580).
map(mt13xa1xp3,t13xa1,p3).
executionTime(mt13xa1xp3,131).
dynamicEnergy(mt13xa1xp3,814).
map(mt13xa1xp7,t13xa1,p7).
executionTime(mt13xa1xp7,290).
dynamicEnergy(mt13xa1xp7,1372).
map(mt14xa1xp4,t14xa1,p4).
executionTime(mt14xa1xp4,91).
dynamicEnergy(mt14xa1xp4,1221).
map(mt14xa1xp7,t14xa1,p7).
executionTime(mt14xa1xp7,277).
dynamicEnergy(mt14xa1xp7,1475).
map(mt15xa1xp7,t15xa1,p7).
executionTime(mt15xa1xp7,292).
dynamicEnergy(mt15xa1xp7,1254).
map(mt15xa1xp9,t15xa1,p9).
executionTime(mt15xa1xp9,131).
dynamicEnergy(mt15xa1xp9,996).
map(mt17xa1xp4,t17xa1,p4).
executionTime(mt17xa1xp4,118).
dynamicEnergy(mt17xa1xp4,1656).
map(mt17xa1xp6,t17xa1,p6).
executionTime(mt17xa1xp6,296).
dynamicEnergy(mt17xa1xp6,1419).
map(mt17xa1xp7,t17xa1,p7).
executionTime(mt17xa1xp7,295).
dynamicEnergy(mt17xa1xp7,1654).
map(mt17xa1xp8,t17xa1,p8).
executionTime(mt17xa1xp8,196).
dynamicEnergy(mt17xa1xp8,946).
map(mt18xa1xp5,t18xa1,p5).
executionTime(mt18xa1xp5,449).
dynamicEnergy(mt18xa1xp5,2035).
map(mt18xa1xp7,t18xa1,p7).
executionTime(mt18xa1xp7,269).
dynamicEnergy(mt18xa1xp7,1318).
map(mt19xa1xp2,t19xa1,p2).
executionTime(mt19xa1xp2,210).
dynamicEnergy(mt19xa1xp2,1249).
map(mt19xa1xp3,t19xa1,p3).
executionTime(mt19xa1xp3,243).
dynamicEnergy(mt19xa1xp3,1335).
map(mt19xa1xp9,t19xa1,p9).
executionTime(mt19xa1xp9,154).
dynamicEnergy(mt19xa1xp9,1132).
map(mt20xa1xp4,t20xa1,p4).
executionTime(mt20xa1xp4,76).
dynamicEnergy(mt20xa1xp4,1008).
map(mt20xa1xp6,t20xa1,p6).
executionTime(mt20xa1xp6,148).
dynamicEnergy(mt20xa1xp6,912).
map(mt20xa1xp7,t20xa1,p7).
executionTime(mt20xa1xp7,232).
dynamicEnergy(mt20xa1xp7,1232).
map(mt20xa1xp8,t20xa1,p8).
executionTime(mt20xa1xp8,117).
dynamicEnergy(mt20xa1xp8,608).
map(mt22xa1xp1,t22xa1,p1).
executionTime(mt22xa1xp1,416).
dynamicEnergy(mt22xa1xp1,1019).
map(mt22xa1xp5,t22xa1,p5).
executionTime(mt22xa1xp5,291).
dynamicEnergy(mt22xa1xp5,1477).
map(mt23xa1xp4,t23xa1,p4).
executionTime(mt23xa1xp4,50).
dynamicEnergy(mt23xa1xp4,804).
map(mt23xa1xp5,t23xa1,p5).
executionTime(mt23xa1xp5,201).
dynamicEnergy(mt23xa1xp5,1005).
map(mt23xa1xp7,t23xa1,p7).
executionTime(mt23xa1xp7,50).
dynamicEnergy(mt23xa1xp7,402).
map(mt24xa1xp4,t24xa1,p4).
executionTime(mt24xa1xp4,71).
dynamicEnergy(mt24xa1xp4,679).
map(mt24xa1xp6,t24xa1,p6).
executionTime(mt24xa1xp6,95).
dynamicEnergy(mt24xa1xp6,647).
map(mt24xa1xp8,t24xa1,p8).
executionTime(mt24xa1xp8,106).
dynamicEnergy(mt24xa1xp8,504).
map(mt2xa1xp3,t2xa1,p3).
executionTime(mt2xa1xp3,199).
dynamicEnergy(mt2xa1xp3,1124).
map(mt2xa1xp7,t2xa1,p7).
executionTime(mt2xa1xp7,328).
dynamicEnergy(mt2xa1xp7,1484).
map(mt2xa1xp9,t2xa1,p9).
executionTime(mt2xa1xp9,135).
dynamicEnergy(mt2xa1xp9,968).
map(mt3xa1xp1,t3xa1,p1).
executionTime(mt3xa1xp1,339).
dynamicEnergy(mt3xa1xp1,875).
map(mt3xa1xp2,t3xa1,p2).
executionTime(mt3xa1xp2,129).
dynamicEnergy(mt3xa1xp2,1056).
map(mt3xa1xp3,t3xa1,p3).
executionTime(mt3xa1xp3,210).
dynamicEnergy(mt3xa1xp3,1578).
map(mt3xa1xp9,t3xa1,p9).
executionTime(mt3xa1xp9,261).
dynamicEnergy(mt3xa1xp9,1278).
map(mt5xa1xp4,t5xa1,p4).
executionTime(mt5xa1xp4,40).
dynamicEnergy(mt5xa1xp4,652).
map(mt5xa1xp5,t5xa1,p5).
executionTime(mt5xa1xp5,163).
dynamicEnergy(mt5xa1xp5,815).
map(mt5xa1xp7,t5xa1,p7).
executionTime(mt5xa1xp7,40).
dynamicEnergy(mt5xa1xp7,326).
map(mt5xa1xp8,t5xa1,p8).
executionTime(mt5xa1xp8,81).
dynamicEnergy(mt5xa1xp8,326).
map(mt9xa1xp6,t9xa1,p6).
executionTime(mt9xa1xp6,296).
dynamicEnergy(mt9xa1xp6,1230).
map(mt9xa1xp8,t9xa1,p8).
executionTime(mt9xa1xp8,198).
dynamicEnergy(mt9xa1xp8,874).
period(2631).
routingDelay(2).
routingEnergy(23).
