module control(inst, ALU_op, PC_src, Dst_reg, ALU_src
               Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg
               InvR1, InvR2, Sign, Cin);

input [15:0] inst;

output [3:0] ALU_op;
output [1:0] PC_src, Dst_reg, ALU_src;
output Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg;
output InvR1, InvR2, Sign, Cin;

reg [3:0] alu_op;
reg [1:0] pc_src, dst_reg, alu_src;
reg ext_sign, reg_write, jump, branch, mem_read, mem_write, jal, mem_reg;

always @* case(inst[15:11])

  



endcase

endmodule
