//Assembly file created by David Waltz and Kshitij Wavre
//testing predict not taken policy
lbi r1, 2
lbi r0, 1
beqz r0, .label1
add r1, r0, r1
.label1:
halt
