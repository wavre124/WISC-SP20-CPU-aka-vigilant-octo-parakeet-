// asm file created by Kshitij Wavre and David Waltz
// this will test a predict taken policy for branches
// values get loaded in
lbi r2, 25
lbi r3, 15
// these nops wait for r3 and r2 to get written to
nop
nop
nop
sub r4, r3, r2
// these nops wait for r4 to get written to
nop
nop
nop
bltz r4, .p2label
// nop here so nothing is loaded in pipeline
nop
// this add instr should never execute if predict
// taken is implemented
add r5, r2, r3
.p2label
halt
