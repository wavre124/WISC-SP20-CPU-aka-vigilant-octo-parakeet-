//Assembly file created by David Waltz and Kshitij Wavre
//testing predict not taken policy
lbi r1, 2
lbi r0, 1 //loading values
beqz r0, .label1 //should not branch to label 1, EX->ID forwarding for value R0
add r1, r0, r1 //this add instructions will be executed immediately after the beqz with no need for a no op
.label1:
halt
