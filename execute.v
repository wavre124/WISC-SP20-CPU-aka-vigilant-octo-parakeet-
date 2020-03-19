/*
   CS/ECE 552 Spring '20

   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (data_1, data_2, signed_immediate, ALU_src, ALU_op, data_out);

  // TODO: Your code here
  input [15:0] data_1, data_2, signed_immediate;
  input [3:0] ALU_op;
  input ALU_src;
  output [15:0] data_out;
  wire [15:0] reg_2;
  //00 is for RT
  //01 is for signed immediate passed in from decode stage
  mux2_1_N mux1 (.InA(data_2), .InB(signed_immediate), .S(ALU_src), .Out(reg_2));

  alu alu1 (.InA(data_1), .InB(reg_2), .Op(ALU_op), .Out(data_out), .Zero(), .Ofl());

endmodule
