/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1

    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module shifter (In, Cnt, Op, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   input [O-1:0]   Op;
   output [N-1:0]  Out;

   /* YOUR CODE HERE */

   wire [N-1:0] l_rotate_wire;
   wire [N-1:0] l_shift_log_wire;
   wire [N-1:0] r_rotate_wire;
   wire [N-1:0] r_shift_log_wire;

   r_shift_log right_shift_logical(.In(In), .Cnt(Cnt), .Out(r_shift_log_wire));
   r_rotate r_rotate_mod(.In(In), .Cnt(Cnt), .Out(r_rotate_wire));
   l_shift_log left_shift_logical(.In(In), .Cnt(Cnt), .Out(l_shift_log_wire));
   l_rotate l_rotate_mod(.In(In), .Cnt(Cnt), .Out(l_rotate_wire));

   mux4_1_16b by_sixteen(.InA(l_rotate_wire), .InB(l_shift_log_wire), .InC(r_rotate_wire), .InD(r_shift_log_wire), .S(Op), .Out(Out));

endmodule
