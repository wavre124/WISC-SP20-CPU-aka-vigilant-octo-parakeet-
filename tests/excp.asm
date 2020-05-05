j .programStart
lbi r7, 186
slbi r7, 221
rti
halt

.programStart:
lbi r2, 5
lbi r1, 6
add r3, r2, r1
siic r4
add r3, r3, r7
halt
