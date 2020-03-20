//Assembly file created by David Waltz and Kshitij Wavre
//Assembly file used to test ex-ex forwaring and RF bypassing for both Rs and Rt
lbi r0, 1 //value ready to be used after execute stage
nop //inserting no operation so we do not use mem-ex forwarding and instead use RF bypassing
lbi r1, 2 //value ready to be used after execute stage
add r2, r0, r1 // r0(RS) will use RF bypassing and r0(RT) will use ex-ex forwarding, no stalls
sub r3, r2, r0 // r2(RS) will use ex-ex forwarding, r0 has no dependencies
lbi r0, 5 
nop //inserting the nops so the lbi instruction reaches write back stage
nop
rol r4, r1, r0 //r0(RT) will use RF bypassing and r1 has no dependencies 
