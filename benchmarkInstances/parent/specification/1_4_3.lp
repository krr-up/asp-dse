application(a1).
routingDelay(2).
routingEnergy(50).
resourceCost(r1,43).
resourceCost(r2,49).
resourceCost(r3,29).
resourceCost(r4,36).
resourceCost(r5,36).
resourceCost(r6,41).
resourceCost(r7,45).
resourceCost(r8,42).
resourceCost(r9,26).
resourceCost(p1,25).
resourceCost(p2,26).
resourceCost(p3,46).
resourceCost(p4,40).
resourceCost(p5,46).
resourceCost(p6,27).
resourceCost(p7,31).
resourceCost(p8,50).
resourceCost(p9,39).
staticPower(r1,45).
staticPower(r2,22).
staticPower(r3,39).
staticPower(r4,44).
staticPower(r5,43).
staticPower(r6,37).
staticPower(r7,33).
staticPower(r8,25).
staticPower(r9,45).
staticPower(p1,33).
staticPower(p2,23).
staticPower(p3,36).
staticPower(p4,32).
staticPower(p5,42).
staticPower(p6,38).
staticPower(p7,33).
staticPower(p8,32).
staticPower(p9,23).
link(lr1xp1,r1,p1).
link(lr2xp2,r2,p2).
link(lr3xp3,r3,p3).
link(lr4xp4,r4,p4).
link(lr5xp5,r5,p5).
link(lr6xp6,r6,p6).
link(lr7xp7,r7,p7).
link(lr8xp8,r8,p8).
link(lr9xp9,r9,p9).
link(lr1xr2,r1,r2).
link(lr2xr3,r2,r3).
link(lr4xr5,r4,r5).
link(lr5xr6,r5,r6).
link(lr7xr8,r7,r8).
link(lr8xr9,r8,r9).
link(lr1xr4,r1,r4).
link(lr2xr5,r2,r5).
link(lr3xr6,r3,r6).
link(lr4xr7,r4,r7).
link(lr5xr8,r5,r8).
link(lr6xr9,r6,r9).
link(lr9xr6,r9,r6).
link(lr8xr5,r8,r5).
link(lr7xr4,r7,r4).
link(lr6xr3,r6,r3).
link(lr5xr2,r5,r2).
link(lr4xr1,r4,r1).
link(lr9xr8,r9,r8).
link(lr8xr7,r8,r7).
link(lr6xr5,r6,r5).
link(lr5xr4,r5,r4).
link(lr3xr2,r3,r2).
link(lr2xr1,r2,r1).
link(lp9xr9,p9,r9).
link(lp8xr8,p8,r8).
link(lp7xr7,p7,r7).
link(lp6xr6,p6,r6).
link(lp5xr5,p5,r5).
link(lp4xr4,p4,r4).
link(lp3xr3,p3,r3).
link(lp2xr2,p2,r2).
link(lp1xr1,p1,r1).
processor(p1,1,1,1).
processor(p2,2,1,1).
processor(p3,3,1,1).
processor(p4,1,2,1).
processor(p5,2,2,1).
processor(p6,3,2,1).
processor(p7,1,3,1).
processor(p8,2,3,1).
processor(p9,3,3,1).
router(r1,1,1,1).
router(r2,2,1,1).
router(r3,3,1,1).
router(r4,1,2,1).
router(r5,2,2,1).
router(r6,3,2,1).
router(r7,1,3,1).
router(r8,2,3,1).
router(r9,3,3,1).
task(t21xa1,a1).
task(t5xa1,a1).
task(t9xa1,a1).
task(t13xa1,a1).
task(t19xa1,a1).
task(t27xa1,a1).
task(t3xa1,a1).
task(t7xa1,a1).
task(t11xa1,a1).
task(t15xa1,a1).
task(t20xa1,a1).
task(t24xa1,a1).
task(t28xa1,a1).
task(t18xa1,a1).
task(t2xa1,a1).
task(t6xa1,a1).
task(t10xa1,a1).
task(t14xa1,a1).
comm(c5x7xa1,a1).
comm(c9x11xa1,a1).
comm(c13x15xa1,a1).
comm(c21x24xa1,a1).
comm(c19x18xa1,a1).
comm(c3x2xa1,a1).
comm(c7x6xa1,a1).
comm(c11x10xa1,a1).
comm(c15x14xa1,a1).
comm(c20x18xa1,a1).
comm(c14x5xa1,a1).
comm(c24x5xa1,a1).
comm(c27x9xa1,a1).
comm(c28x9xa1,a1).
comm(c21x13xa1,a1).
comm(c2x27xa1,a1).
comm(c2x28xa1,a1).
comm(c6x3xa1,a1).
comm(c10x19xa1,a1).
comm(c10x20xa1,a1).
read(t7xa1,c5x7xa1).
read(t11xa1,c9x11xa1).
read(t15xa1,c13x15xa1).
read(t24xa1,c21x24xa1).
read(t18xa1,c19x18xa1).
read(t2xa1,c3x2xa1).
read(t6xa1,c7x6xa1).
read(t10xa1,c11x10xa1).
read(t14xa1,c15x14xa1).
read(t18xa1,c20x18xa1).
read(t5xa1,c14x5xa1).
read(t5xa1,c24x5xa1).
read(t9xa1,c27x9xa1).
read(t9xa1,c28x9xa1).
read(t13xa1,c21x13xa1).
read(t27xa1,c2x27xa1).
read(t28xa1,c2x28xa1).
read(t3xa1,c6x3xa1).
read(t19xa1,c10x19xa1).
read(t20xa1,c10x20xa1).
send(t5xa1,c5x7xa1).
send(t9xa1,c9x11xa1).
send(t13xa1,c13x15xa1).
send(t21xa1,c21x24xa1).
send(t19xa1,c19x18xa1).
send(t3xa1,c3x2xa1).
send(t7xa1,c7x6xa1).
send(t11xa1,c11x10xa1).
send(t15xa1,c15x14xa1).
send(t20xa1,c20x18xa1).
send(t14xa1,c14x5xa1).
send(t24xa1,c24x5xa1).
send(t27xa1,c27x9xa1).
send(t28xa1,c28x9xa1).
send(t21xa1,c21x13xa1).
send(t2xa1,c2x27xa1).
send(t2xa1,c2x28xa1).
send(t6xa1,c6x3xa1).
send(t10xa1,c10x19xa1).
send(t10xa1,c10x20xa1).
map(mt21xa1xp5,t21xa1,p5).
dynamicEnergy(mt21xa1xp5,2046).
map(mt21xa1xp9,t21xa1,p9).
dynamicEnergy(mt21xa1xp9,1940).
map(mt5xa1xp1,t5xa1,p1).
dynamicEnergy(mt5xa1xp1,1060).
map(mt5xa1xp4,t5xa1,p4).
dynamicEnergy(mt5xa1xp4,484).
map(mt5xa1xp9,t5xa1,p9).
dynamicEnergy(mt5xa1xp9,843).
map(mt9xa1xp3,t9xa1,p3).
dynamicEnergy(mt9xa1xp3,152).
map(mt9xa1xp6,t9xa1,p6).
dynamicEnergy(mt9xa1xp6,114).
map(mt13xa1xp1,t13xa1,p1).
dynamicEnergy(mt13xa1xp1,840).
map(mt13xa1xp6,t13xa1,p6).
dynamicEnergy(mt13xa1xp6,630).
map(mt13xa1xp8,t13xa1,p8).
dynamicEnergy(mt13xa1xp8,1050).
map(mt13xa1xp9,t13xa1,p9).
dynamicEnergy(mt13xa1xp9,630).
map(mt19xa1xp1,t19xa1,p1).
dynamicEnergy(mt19xa1xp1,2318).
map(mt19xa1xp7,t19xa1,p7).
dynamicEnergy(mt19xa1xp7,2121).
map(mt27xa1xp1,t27xa1,p1).
dynamicEnergy(mt27xa1xp1,303).
map(mt27xa1xp3,t27xa1,p3).
dynamicEnergy(mt27xa1xp3,404).
map(mt27xa1xp4,t27xa1,p4).
dynamicEnergy(mt27xa1xp4,303).
map(mt27xa1xp7,t27xa1,p7).
dynamicEnergy(mt27xa1xp7,303).
map(mt3xa1xp3,t3xa1,p3).
dynamicEnergy(mt3xa1xp3,232).
map(mt3xa1xp4,t3xa1,p4).
dynamicEnergy(mt3xa1xp4,174).
map(mt3xa1xp7,t3xa1,p7).
dynamicEnergy(mt3xa1xp7,174).
map(mt7xa1xp1,t7xa1,p1).
dynamicEnergy(mt7xa1xp1,1808).
map(mt7xa1xp7,t7xa1,p7).
dynamicEnergy(mt7xa1xp7,1621).
map(mt11xa1xp6,t11xa1,p6).
dynamicEnergy(mt11xa1xp6,1219).
map(mt11xa1xp8,t11xa1,p8).
dynamicEnergy(mt11xa1xp8,1693).
map(mt15xa1xp3,t15xa1,p3).
dynamicEnergy(mt15xa1xp3,780).
map(mt15xa1xp4,t15xa1,p4).
dynamicEnergy(mt15xa1xp4,585).
map(mt15xa1xp7,t15xa1,p7).
dynamicEnergy(mt15xa1xp7,585).
map(mt20xa1xp1,t20xa1,p1).
dynamicEnergy(mt20xa1xp1,210).
map(mt20xa1xp4,t20xa1,p4).
dynamicEnergy(mt20xa1xp4,84).
map(mt20xa1xp7,t20xa1,p7).
dynamicEnergy(mt20xa1xp7,168).
map(mt24xa1xp5,t24xa1,p5).
dynamicEnergy(mt24xa1xp5,1200).
map(mt24xa1xp6,t24xa1,p6).
dynamicEnergy(mt24xa1xp6,720).
map(mt28xa1xp1,t28xa1,p1).
dynamicEnergy(mt28xa1xp1,624).
map(mt28xa1xp4,t28xa1,p4).
dynamicEnergy(mt28xa1xp4,624).
map(mt28xa1xp7,t28xa1,p7).
dynamicEnergy(mt28xa1xp7,624).
map(mt18xa1xp5,t18xa1,p5).
dynamicEnergy(mt18xa1xp5,1042).
map(mt18xa1xp9,t18xa1,p9).
dynamicEnergy(mt18xa1xp9,992).
map(mt2xa1xp1,t2xa1,p1).
dynamicEnergy(mt2xa1xp1,645).
map(mt2xa1xp3,t2xa1,p3).
dynamicEnergy(mt2xa1xp3,860).
map(mt2xa1xp4,t2xa1,p4).
dynamicEnergy(mt2xa1xp4,645).
map(mt2xa1xp7,t2xa1,p7).
dynamicEnergy(mt2xa1xp7,645).
map(mt6xa1xp4,t6xa1,p4).
dynamicEnergy(mt6xa1xp4,225).
map(mt6xa1xp8,t6xa1,p8).
dynamicEnergy(mt6xa1xp8,300).
map(mt10xa1xp1,t10xa1,p1).
dynamicEnergy(mt10xa1xp1,1922).
map(mt10xa1xp4,t10xa1,p4).
dynamicEnergy(mt10xa1xp4,1313).
map(mt10xa1xp7,t10xa1,p7).
dynamicEnergy(mt10xa1xp7,1719).
map(mt14xa1xp1,t14xa1,p1).
dynamicEnergy(mt14xa1xp1,564).
map(mt14xa1xp4,t14xa1,p4).
dynamicEnergy(mt14xa1xp4,564).
map(mt14xa1xp6,t14xa1,p6).
dynamicEnergy(mt14xa1xp6,752).
map(mt14xa1xp8,t14xa1,p8).
dynamicEnergy(mt14xa1xp8,752).
executionTime(mt21xa1xp5,328).
executionTime(mt21xa1xp9,342).
executionTime(mt5xa1xp1,217).
executionTime(mt5xa1xp4,70).
executionTime(mt5xa1xp9,204).
executionTime(mt9xa1xp3,38).
executionTime(mt9xa1xp6,12).
executionTime(mt13xa1xp1,210).
executionTime(mt13xa1xp6,70).
executionTime(mt13xa1xp8,52).
executionTime(mt13xa1xp9,105).
executionTime(mt19xa1xp1,495).
executionTime(mt19xa1xp7,328).
executionTime(mt27xa1xp1,50).
executionTime(mt27xa1xp3,33).
executionTime(mt27xa1xp4,25).
executionTime(mt27xa1xp7,25).
executionTime(mt3xa1xp3,19).
executionTime(mt3xa1xp4,14).
executionTime(mt3xa1xp7,14).
executionTime(mt7xa1xp1,384).
executionTime(mt7xa1xp7,238).
executionTime(mt11xa1xp6,206).
executionTime(mt11xa1xp8,122).
executionTime(mt15xa1xp3,65).
executionTime(mt15xa1xp4,48).
executionTime(mt15xa1xp7,48).
executionTime(mt20xa1xp1,42).
executionTime(mt20xa1xp4,14).
executionTime(mt20xa1xp7,14).
executionTime(mt24xa1xp5,240).
executionTime(mt24xa1xp6,80).
executionTime(mt28xa1xp1,104).
executionTime(mt28xa1xp4,52).
executionTime(mt28xa1xp7,52).
executionTime(mt18xa1xp5,199).
executionTime(mt18xa1xp9,209).
executionTime(mt2xa1xp1,107).
executionTime(mt2xa1xp3,71).
executionTime(mt2xa1xp4,53).
executionTime(mt2xa1xp7,53).
executionTime(mt6xa1xp4,18).
executionTime(mt6xa1xp8,37).
executionTime(mt10xa1xp1,374).
executionTime(mt10xa1xp4,137).
executionTime(mt10xa1xp7,183).
executionTime(mt14xa1xp1,94).
executionTime(mt14xa1xp4,47).
executionTime(mt14xa1xp6,188).
executionTime(mt14xa1xp8,94).
period(2162).
