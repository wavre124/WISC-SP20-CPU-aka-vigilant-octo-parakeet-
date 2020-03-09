/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (clk, EPC_reg ,rst, b_j_pc, curr_pc, PC_src, Mem_en, excp, instruction);
  // TODO: Your code here
  input wire [1:0] PC_src;
  input wire Mem_en, clk, rst, excp;
  input wire [15:0] b_j_pc, curr_pc, EPC_reg; //pcs being fed in from the branch address, jump address, and current pc for holds and normal instructions
  wire [15:0] exception_pc 
  output wire [15:0] incremented_pc;

  wire [15:0] pc; //will be fed into our instruction memory
  output wire [15:0]instruction; instruction received from instruction memory
  
  
  cla_16b adder (.A(curr_pc), .B(16'b0000_0000_0000_0010), .C_in(1'b0), .S(incremented_pc), .C_out());

  
  //16 bit 2-1 mux for choosing 2 for exception handler or EPC after we return from the instruction
  mux2_1_N pc_mux1(.InA(EPC_reg), .InB(16'b0000_0000_0000_0010), .S(excp), .Out(exception_pc));
  
  
  //00 is for current pc i.e. HALT
  //01 is for incremented PC for a normal non jumping non branching instruction
  //10 is for branch_address
  //11 is for exception or EPC
  mux4_1_16b pc_mux2(.InA(curr_pc), .InB(incremented_pc), .InC(b_j_pc), .InD(exception_pc), .S(PC_src), .Out(pc));
 


  memory2c instruction_memory(.data_out(instruction), data_in(16'b0000_0000_0000_0000), addr(pc), enable(Mem_en), wr(1'b0), createdump(1'b0), .clk(clk), .rst(rst));
 

 
 
 
 
 
 
 
  
   

  
  
  

   
   
endmodule
