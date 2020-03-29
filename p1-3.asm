// asm file created by Kshitij Wavre and David Waltz
// this asm file will test MEM-MEM forwarding
// loading 5 into r1
lbi r1, 5
// value from mem will be loaded into r5
nop
ld r5, r1, 10
// value from r5 will be loaded into mem
// this ld followed by a st should use MEM-MEM forwarding
st r5, r1, 20
halt
