/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (clk, EPC_reg ,rst, b_j_pc, curr_pc, PC_src, mem_enable, excp, instruction);
  // TODO: Your code here
  input wire [1:0] PC_src;
  input wire mem_enable, clk, rst, excp;
  input wire [15:0] b_j_pc, curr_pc, EPC_reg; //pcs being fed in from the branch address, jump address, and current pc for holds and normal instructions
  wire [15:0] exception_pc, incremented_pc;
  wire createdump; 
  wire [15:0] pc; //will be fed into our instruction memory
  output wire [15:0]instruction; instruction received from instruction memory
  
  
  assign incremented_pc = curr_pc + 2'b10; //incrementing pc to next instruction
  
  //16 bit 2-1 mux for choosing 2 for exception handler or EPC after we return from the instruction
  mux2_1_N pc_mux1(.InA(EPC_reg), .InB(16'b0000_0000_0000_0010), .S(excp), .Out(exception_pc));
  
  
  //00 is for current pc i.e. HALT
  //01 is for incremented PC for a normal non jumping non branching instruction
  //10 is for branch_address
  //11 is for exception or EPC
  mux4_1_16b pc_mux2(.InA(curr_pc), .InB(incremented_pc), .InC(b_j_pc), .InD(exception_pc), .S(PS_src), .Out(pc));
  assign createdump = (PC_src == 0) ? 1'b1 : 1'b0; //createdump should be a 1 when it is halt instruction


  memory2c instruction_memory(.data_out(instruction), data_in(16'b0000_0000_0000_0000), addr(pc), enable(mem_enable), wr(1'b0), createdump(createdump), .clk(clk), .rst(rst));


 
 
 
 
 
 
 
  
   

  
  
  

   
   
endmodule
