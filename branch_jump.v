module branch_jump(rs, PC, imm, displacement, branch, jump, branch_jump_op, branch_PC, jump_PC);

parameter N = 16;

input [N-1:0] rs;
input [N-1:0] PC;
input [N-1:0] imm;
input [N-1:0] displacement;
input branch, jump;
input [2:0] branch_jump_op;

output [N-1:0] branch_PC;
output [N-1:0] jump_PC;

localparam BEQZ = 3'b000;
localparam BNEZ = 3'b001;
localparam BLTZ = 3'b010;
localparam BGEZ = 3'b011;
localparam J_DIS = 3'b100;
localparam JR = 3'b101;
localparam JAL = 3'b110;
localparam JALR = 3'b111;




endmodule
