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
    5'b00000 : begin                         end // HALT
    5'b00001 : begin                         end //NOP
    5'b01000 : begin                         end // ADDI
    5'b01001 : begin                         end //SUBI
    5'b01010 : begin                         end //XORI
    5'b01011 : begin                         end //ANDNI
    5'b10100 : begin                         end //ROLI
    5'b10101 : begin                         end //SLLI
    5'b10110 : begin                         end //RORI
    5'b10111 : begin                         end //SRLI
    5'b10000 : begin                         end //ST
    5'b10001 : begin                         end //LD
    5'b10011 : begin                         end //STU
    5'b11001 : begin                         end //BTR implment terninary
    5'b11011 : begin                         end //ADD,SUB,XOR,ANDN implement terniary 
    5'b11010 : begin                         end //ROL,SLL,ROR, SRL implement terniary
    5'b11100 : begin                         end //SEQ
    5'b11101 : begin                         end //SLT
    5'b11110 : begin                         end //SLE
    5'b11111 : begin                         end //SCO
    5'b01100 : begin                         end //BEQZ
    5'b01101 : begin                         end //BNEZ
    5'b01110 : begin                         end //BLTZ
    5'b01111 : begin                         end //BGEZ
    5'b11000 : begin                         end //LBI
    5'b10010 : begin                         end //SLBI
    5'b00100 : begin                         end //J displacement
    5'b00101 : begin                         end //JR 
    5'b00110 : begin                         end // JAL displacement 
    5'b00111 : begin                         end // JALR
    5'b00010 : begin                         end //produce illegalop exception
    5'b00011 : begin                         end // NOP
    default : begin                          end //possibly combine with NOP
endcase
    

    
    
  



endcase

endmodule
