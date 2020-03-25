//Assembly file created by David Waltz and Kshitij Wavre
lbi r1, 16   
lbi r0, 1   //loading in values   
nop         //inserting a nop to use mem-ex forwarding and not ex-ex  
add r2, r0, r1 //uses mem to ex because the lbi for R0 is in mem/wb stage and this instruction is in id/ex stage so it can be forwarded 
ld r3, r1, 0     //loading in random value at memory location 0x10  
add r4, r1, r3 //uses mem to ex forwarding because ld instructions mem read is 1 as well as its regwrite is 1, it should also stall for one cycle in decode
halt



