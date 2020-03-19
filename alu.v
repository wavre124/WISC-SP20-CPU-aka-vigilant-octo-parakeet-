/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 2

    A 16-bit ALU module.  It is designed to choose
    the correct operation to perform on 2 16-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the 16-bit result
    of the operation, as well as output a Zero bit and an Overflow
    (OFL) bit.
*/
module alu (InA, InB, Op, Out, Zero, Ofl);

   // declare constant for size of inputs, outputs (N),
   // and operations (O)
   parameter    N = 16;
   parameter    O = 4;

   input [N-1:0] InA;
   input [N-1:0] InB;
   input [O-1:0] Op;
   output [N-1:0] Out;
   output         Ofl;
   output         Zero;

   /* YOUR CODE HERE */

   wire         Cin;
   wire         invA;
   wire         invB;
   wire         sign;

   localparam rot_left = 4'b0000;
   localparam l_shift = 4'b0001;
   localparam rot_right = 4'b0010;
   localparam r_shift = 4'b0011;
   localparam add_op = 4'b0100;
   localparam and_op = 4'b0101;
   localparam or_op = 4'b0110;
   localparam xor_op = 4'b0111;
   localparam slbi_op = 4'b1000;
   localparam sub_op = 4'b1001;
   localparam seq_op = 4'b1010;
   localparam slt_op = 4'b1011;
   localparam sle_op = 4'b1100;
   localparam sco_op = 4'b1101;
   localparam btr_op = 4'b1110;
   localparam lbi_op = 4'b1111;

   wire [N-1:0] alu_A, alu_B;
   wire [N-1:0] shift_out;
   wire [N-1:0] adder_out;
   wire C_out;
   reg [N-1:0] alu_out;
   reg Cin_reg;
   reg invA_reg;
   reg invB_reg;
   reg sign_reg;
   wire [N-1:0] seq_result;
   wire [N-1:0] slt_result;
   wire [N-1:0] sle_result;
   wire [N-1:0] sco_result;
   wire [N-1:0] btr_result;

   assign Cin = Cin_reg;
   assign invA = invA_reg;
   assign invB = invB_reg;
   assign sign = sign_reg;

   assign alu_A = (invA) ? ~InA : InA;
   assign alu_B = (invB) ? ~InB : InB;

   assign seq_result = ~|adder_out;
   assign slt_result = (adder_out[15] & ~Ofl) | (~adder_out[15] & Ofl);
   assign sle_result = (~|adder_out) | ((adder_out[15] & ~Ofl) | (~adder_out[15] & Ofl));
   assign sco_result = C_out;

   shifter shift_mod(.In(alu_A), .Cnt(alu_B[3:0]), .Op(Op[1:0]), .Out(shift_out));
   cla_16b adder(.A(alu_A), .B(alu_B), .C_in(Cin), .S(adder_out), .C_out(C_out), .Overflow(Ofl));
   btr btr_res(.InA(alu_A), .Out(btr_result));

   always @* case(Op)

      rot_left: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = shift_out;
              end
      l_shift: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = shift_out;
              end
      rot_right: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = shift_out;
              end
      r_shift: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = shift_out;
              end
      add_op: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 1;
                Cin_reg = 0;
                alu_out = adder_out;
              end
      and_op: begin
                invA_reg = 0;
                invB_reg = 1;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = alu_A & alu_B;
              end
      or_op: begin
                alu_out = alu_A | alu_B;
              end
      xor_op: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = alu_A ^ alu_B;
              end
      sub_op: begin
                invA_reg = 1;
                invB_reg = 0;
                sign_reg = 1;
                Cin_reg = 1;
                alu_out = adder_out;
              end
      seq_op: begin
                invA_reg = 0;
                invB_reg = 1;
                sign_reg = 1;
                Cin_reg = 1;
                alu_out = seq_result;
              end
      slt_op: begin
                invA_reg = 0;
                invB_reg = 1;
                sign_reg = 1;
                Cin_reg = 1;
                alu_out = slt_result;
              end
      sle_op: begin
                invA_reg = 0;
                invB_reg = 1;
                sign_reg = 1;
                Cin_reg = 1;
                alu_out = sle_result;
              end
      sco_op: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 1;
                Cin_reg = 0;
                alu_out = sco_result;
              end
      btr_op: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = btr_result;
              end
      lbi_op: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = alu_B;
              end
      slbi_op: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = (alu_A << 8) | alu_B;
              end
      default: begin
                invA_reg = 0;
                invB_reg = 0;
                sign_reg = 0;
                Cin_reg = 0;
                alu_out = 16'b0;
               end

   endcase

   assign Zero = ~|alu_out;
   assign Out = alu_out;

endmodule
