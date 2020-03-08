module control(inst, ALU_op, PC_src, Dst_reg, ALU_src
               Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg
               InvR1, InvR2, Sign, Cin);

input [15:0] inst;

output reg [3:0] ALU_op;
output reg [1:0] PC_src, Dst_reg, ALU_src;
output reg Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg;
output reg InvR1, InvR2, Sign, Cin;

localparam HALT = 5'b00000;
localparam NOP = 5'b00001;
localparam ADDI = 5'b01000;
localparam SUBI = 5'b01001;
localparam XORI = 5'b01010;
localparam ANDNI = 5'b01011;
localparam ROLI = 5'b10100;
localparam SLLI = 5'b10101;
localparam RORI = 5'b10110;
localparam SRLI = 5'b10111;
localparam ST = 5'b10000;
localparam LD = 5'b10001;
localparam STU = 5'b10011;
localparam BTR = 5'b11001;
localparam B_ALU = 5'b11011;
localparam S_ALU = 5'b11010;
localparam SEQ = 5'b11100;
localparam SLT = 5'b11101;
localparam SLE = 5'b11110;
localparam SCO = 5'b11111;
localparam BEQZ = 5'b01100;
localparam BNEZ = 5'b01101;
localparam BLTZ = 5'b01110;
localparam BGEZ = 5'b01111;
localparam LBI = 5'b11000;
localparam SLBI = 5'b10010;
localparam J_DIS = 5'b00100;
localparam JR = 5'b00101;
localparam JAL = 5'b00110;
localparam JALR = 5'b00111;
localparam ILL_OP = 5'b00010;
localparam RTI = 5'b00011;

// PC_source works this way
// 00 - reads old PC
// 01 - reads incremented PC
// 10 - reads branch address
// 11 - reads jump address

// DST_reg works this way
// 00 - read from Inst[4:2]
// 01 - read from Inst[7:5]
// 10 - read from Inst[10:8]
// 11 - read from R7

// ALU_src works this way
// 00 - data[15:0] from register
// 01 - immediate
// 10 - fixed 2
// 11 - unknown (maybe something we are missing)

// Ext_sign
// 0 - zero extend
// 1 - sign extend

// Mem_reg
// 0 - ALU output
// 1 - mem output

// set all control signal blocks
always @* case(inst[15:11])
    HALT : begin
           ALU_op = 4'b0000;
           PC_src = 2'b00;
           Dst_reg = 2'b00;
           ALU_src = 2'b00;
           Ext_sign = 0;
           Reg_write = 0;
           Jump = 0;
           Branch = 0;
           Mem_read = 0;
           Mem_write = 0;
           JAL = 0;
           Mem_reg = 0;
           InvR1 = 0;
           InvR2 = 0;
           Sign = 0;
           Cin = 0;
           end // HALT
    NOP : begin
          ALU_op = 4'b0000;
          PC_src = 2'b01;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 0;
          Reg_write = 0;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          end //NOP
    ADDI : begin
           ALU_op = 4'b0100;
           PC_src = 2'b01;
           Dst_reg = 2'b01;
           ALU_src = 2'b01;
           Ext_sign = 1;
           Reg_write = 1;
           Jump = 0;
           Branch = 0;
           Mem_read = 0;
           Mem_write = 0;
           JAL = 0;
           Mem_reg = 0;
           InvR1 = 0;
           InvR2 = 0;
           Sign = 1;
           Cin = 0;
           end // ADDI
    SUBI : begin
          ALU_op = 4'b1001;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 1;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 1;
          InvR2 = 0;
          Sign = 1;
          Cin = 1;
           end //SUBI
    XORI : begin
          ALU_op = 4'b0111;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
           end //XORI
    ANDNI : begin
          ALU_op = 4'b0101;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 1;
          Sign = 0;
          Cin = 0;
            end //ANDNI
    ROLI : begin
          ALU_op = 4'b0000;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
           end //ROLI
    SLLI : begin
          ALU_op = 4'b0001;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
           end //SLLI
    RORI : begin
          ALU_op = 4'b0010;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
           end //RORI
    SRLI : begin
          ALU_op = 4'b0011;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
           end //SRLI
    ST : begin
          ALU_op = 4'b0100;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 1;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 1;
          Cin = 0;
         end //ST
    LD : begin
          ALU_op = 4'b0100;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 1;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 1;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 1;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 1;
          Cin = 0;
         end //LD
    STU : begin
          ALU_op = 4'b0100;
          PC_src = 2'b01;
          Dst_reg = 2'b01;
          ALU_src = 2'b01;
          Ext_sign = 1;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 1;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 1;
          Cin = 0;
          end //STU
    BTR : begin
          ALU_op = 4'b1110;
          PC_src = 2'b01;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 0;
          Reg_write = 1;
          Jump = 0;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          end //BTR
    B_ALU : begin
            
            end //ADD,SUB,XOR,ANDN implement terniary
    S_ALU : begin
            end //ROL,SLL,ROR, SRL implement terniary
    SEQ : begin
          end //SEQ
    SLT : begin
          end //SLT
    SLE : begin
          end //SLE
    SCO : begin
          end //SCO
    BEQZ : begin
           end //BEQZ
    BNEZ : begin
           end //BNEZ
    BLTZ : begin
           end //BLTZ
    BGEZ : begin
           end //BGEZ
    LBI : begin
          end //LBI
    SLBI : begin
           end //SLBI
    J_DIS : begin
            end //J displacement
    JR : begin
         end //JR
    JAL : begin
          end // JAL displacement
    JALR : begin
           end // JALR
    ILL_OP : begin
             end //produce illegalop exception
    RTI : begin
          end // NOP
    default : begin
              end //possibly combine with NOP
endcase

// set op code for ALU_op

endmodule
