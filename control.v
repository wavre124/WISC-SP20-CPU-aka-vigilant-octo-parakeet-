module control(inst, ALU_op, PC_src, Dst_reg, ALU_src
               Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg
               InvR1, InvR2, Sign, Cin);

input [15:0] inst;

output reg [3:0] ALU_op;
output reg [2:0] branch_jump_op;
output reg [1:0] PC_src, Dst_reg, ALU_src;
output reg Ext_sign, Reg_write, Jump, Branch, Mem_read, Mem_write, JAL, Mem_reg, Mem_en;
output reg Excp;
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

localparam ADD = 2'b00;
localparam SUB = 2'b01;
localparam XOR = 2'b10;
localparam ANDN = 2'b11;

wire [3:0] b_alu_op;
wire [3:0] s_alu_op;
wire b_alu_invA, b_alu_invB, b_alu_Cin;

assign b_alu_op = (inst[1:0] == ADD) ?  4'b0100 :
                  (inst[1:0] == SUB) ?  4'b1001 :
                  (inst[1:0] == XOR) ?  4'b0111 :
                  (inst[1:0] == ANDN) ? 4'b0101 : 4'b0000;

assign b_alu_invA = (inst[1:0] == ADD) ?  1'b0 :
                    (inst[1:0] == SUB) ?  1'b1 :
                    (inst[1:0] == XOR) ?  1'b0 :
                    (inst[1:0] == ANDN) ? 1'b0 : 1'b0 ;

assign b_alu_invB = (inst[1:0] == ADD) ? 1'b0  :
                    (inst[1:0] == SUB) ?  1'b0 :
                    (inst[1:0] == XOR) ?  1'b0 :
                    (inst[1:0] == ANDN) ? 1'b1 : 1'b0;

assign b_alu_Cin = (inst[1:0] == ADD) ?  1'b0 :
                   (inst[1:0] == SUB) ?  1'b1 :
                   (inst[1:0] == XOR) ?  1'b0 :
                   (inst[1:0] == ANDN) ? 1'b0 : 1'b0;

assign s_alu_op = (inst[1:0] == 2'b00) ? 4'b0000 :
                  (inst[1:0] == 2'b01) ? 4'b0001 :
                  (inst[1:0] == 2'b10) ? 4'b0010 :
                  (inst[1:0] == 2'b11) ? 4'b0011 : 4'b0000;

// PC_source works this way
// 00 - reads old PC
// 01 - reads incremented PC
// 10 - reads branch address or jump addr
// 11 - reads EPC

// DST_reg works this way
// 00 - read from Inst[4:2]
// 01 - read from Inst[7:5]
// 10 - read from Inst[10:8]
// 11 - read from R7

// ALU_src works this way
// 00 - data[15:0] from register rt
// 01 - immediate
// 10 - fixed 2
// 11 - unknown (maybe something we are missing)

// Ext_sign
// 0 - zero extend
// 1 - sign extend

// Mem_reg
// 0 - ALU output
// 1 - mem output

// JAL
// 0 - data[15:0] from register rs
// 1 - current value of PC register

// set all control signal blocks
always @* case(inst[15:11])
    HALT : begin
           ALU_op = 4'b0000;
           branch_jump_op = 3'b000;
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
           Mem_en = 0;
           Excp = 0;
           end // HALT
    NOP : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b000;
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
          Mem_en = 0;
          Excp = 0;
          end //NOP
    ADDI : begin
           ALU_op = 4'b0100;
           branch_jump_op = 3'b000;
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
           Mem_en = 1;
           Excp = 0;
           end // ADDI
    SUBI : begin
          ALU_op = 4'b1001;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
           end //SUBI
    XORI : begin
          ALU_op = 4'b0111;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
           end //XORI
    ANDNI : begin
          ALU_op = 4'b0101;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
            end //ANDNI
    ROLI : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
           end //ROLI
    SLLI : begin
          ALU_op = 4'b0001;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
           end //SLLI
    RORI : begin
          ALU_op = 4'b0010;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
           end //RORI
    SRLI : begin
          ALU_op = 4'b0011;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
           end //SRLI
    ST : begin
          ALU_op = 4'b0100;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
         end //ST
    LD : begin
          ALU_op = 4'b0100;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
         end //LD
    STU : begin
          ALU_op = 4'b0100;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
          end //STU
    BTR : begin
          ALU_op = 4'b1110;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
          end //BTR
    B_ALU : begin
          ALU_op = b_alu_op;
          branch_jump_op = 3'b000;
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
          InvR1 = b_alu_invA;
          InvR2 = b_alu_invB;
          Sign = 1;
          Cin = b_alu_Cin;
          Mem_en = 1;
          Excp = 0;
            end //ADD,SUB,XOR,ANDN implement terniary
    S_ALU : begin
          ALU_op = s_alu_op;
          branch_jump_op = 3'b000;
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
          Mem_en = 1;
          Excp = 0;
            end //ROL,SLL,ROR, SRL implement terniary
    SEQ : begin
          ALU_op = 4'b1010;
          branch_jump_op = 3'b000;
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
          InvR2 = 1;
          Sign = 1;
          Cin = 1;
          Mem_en = 1;
          Excp = 0;
          end //SEQ
    SLT : begin
          ALU_op = 4'b1011;
          branch_jump_op = 3'b000;
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
          InvR1 = 1;
          InvR2 = 0;
          Sign = 1;
          Cin = 1;
          Mem_en = 1;
          Excp = 0;
          end //SLT
    SLE : begin
          ALU_op = 4'b1100;
          branch_jump_op = 3'b000;
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
          InvR1 = 1;
          InvR2 = 0;
          Sign = 1;
          Cin = 1;
          Mem_en = 1;
          Excp = 0;
          end //SLE
    SCO : begin
          ALU_op = 4'b1101;
          branch_jump_op = 3'b000;
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
          Sign = 1;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
          end //SCO
    BEQZ : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b000;
          PC_src = 2'b10;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 0;
          Branch = 1;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
           end //BEQZ
    BNEZ : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b001;
          PC_src = 2'b10;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 0;
          Branch = 1;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
           end //BNEZ
    BLTZ : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b010;
          PC_src = 2'b10;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 0;
          Branch = 1;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
           end //BLTZ
    BGEZ : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b011;
          PC_src = 2'b10;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 0;
          Branch = 1;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
           end //BGEZ
    LBI : begin
          ALU_op = 4'b1111;
          branch_jump_op = 3'b000;
          PC_src = 2'b01;
          Dst_reg = 2'b10;
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
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
          end //LBI
    SLBI : begin
          ALU_op = 4'b1000;
          branch_jump_op = 3'b000;
          PC_src = 2'b01;
          Dst_reg = 2'b10;
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
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
           end //SLBI
    J_DIS : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b100;
          PC_src = 2'b10;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 1;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
            end //J displacement
    JR : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b101;
          PC_src = 2'b10;
          Dst_reg = 2'b00;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 0;
          Jump = 1;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 0;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
         end //JR
    JAL : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b110;
          PC_src = 2'b10;
          Dst_reg = 2'b11;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 1;
          Jump = 1;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 1;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
          end // JAL displacement
    JALR : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b111;
          PC_src = 2'b10;
          Dst_reg = 2'b11;
          ALU_src = 2'b00;
          Ext_sign = 1;
          Reg_write = 1;
          Jump = 1;
          Branch = 0;
          Mem_read = 0;
          Mem_write = 0;
          JAL = 1;
          Mem_reg = 0;
          InvR1 = 0;
          InvR2 = 0;
          Sign = 0;
          Cin = 0;
          Mem_en = 1;
          Excp = 0;
           end // JALR
    ILL_OP : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b000;
          PC_src = 2'b11;
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
          Mem_en = 1;
          Excp = 1;
             end //produce illegalop exception
    RTI : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b000;
          PC_src = 2'b11;
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
          Mem_en = 1;
          Excp = 0;
          end // NOP
    default : begin
          ALU_op = 4'b0000;
          branch_jump_op = 3'b000;
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
          Mem_en = 0;
          Excp = 0;
              end //possibly combine with NOP
endcase

endmodule
