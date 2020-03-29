/*
   CS/ECE 552 Spring '20

   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (data_1, data_2, data_2_o, signed_immediate, ALU_src, ALU_op, data_out, RD, RS, opcode, RS_o, RD_o, opcode_o);

  // TODO: Your code here
  input [15:0] data_1, data_2, signed_immediate;
  input [3:0] ALU_op;
  input ALU_src;
  input [2:0] RD;
  input [2:0] RS;
  input [5:0} opcode;
  output [2:0] RD_o;
  output [2:0] RS_o;
  output [5:0] opcode_o;
  output [15:0] data_out;
  output [15:0] data_2_o;
  wire [15:0] reg_2;
  assign data_2_o = data_2;
  assign RD= RD_o;
  assign RS= RS_o;
  assign opcode_o = opcode;
  //00 is for RT
  //01 is for signed immediate passed in from decode stage
  mux2_1_N mux1 (.InA(data_2), .InB(signed_immediate), .S(ALU_src), .Out(reg_2));

  alu alu1 (.InA(data_1), .InB(reg_2), .Op(ALU_op), .Out(data_out), .Zero(), .Ofl());

endmodule
