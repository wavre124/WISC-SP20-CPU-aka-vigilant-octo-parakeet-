module branch_jump(rs, PC, imm, displacement, branch_jump_op, b_j_PC, reg_data);

parameter N = 16;

input [N-1:0] rs;
input [N-1:0] PC;
input [N-1:0] imm;
input [N-1:0] displacement;
input [2:0] branch_jump_op;

output reg [N-1:0] b_j_PC;
output [N-1:0] reg_data;

localparam BEQZ = 3'b000;
localparam BNEZ = 3'b001;
localparam BLTZ = 3'b010;
localparam BGEZ = 3'b011;
localparam J_DIS = 3'b100;
localparam JR = 3'b101;
localparam JAL = 3'b110;
localparam JALR = 3'b111;

wire C_out;
wire [N-1:0] alu_A, alu_B;
wire [N-1:0] added_PC_res;

assign alu_A = (branch_jump_op == JR) ? rs : (branch_jump_op == JALR) ? rs : PC;
assign alu_B = (branch_jump_op == J_DIS) ? displacement : (branch_jump_op == JAL) ? displacement : imm;

cla_16b adder(.A(alu_A), .B(alu_B), .C_in(1'b0), .S(added_PC_res), .C_out(C_out), .Overflow());

wire [N-1:0] beqz_res, bnez_res, bltz_res, bgez_res;

assign beqz_res = !(|rs) ? added_PC_res : PC;
assign bnez_res = (|rs) ? added_PC_res : PC;
assign bltz_res = (rs[15]) ? added_PC_res : PC;
assign bgez_res = ((~rs[15]) | !(|rs)) ? added_PC_res : PC;

always @* case(branch_jump_op)

  BEQZ: begin
        b_j_PC = beqz_res;
        end
  BNEZ: begin
        b_j_PC = bnez_res;
        end
  BLTZ: begin
        b_j_PC = bltz_res;
        end
  BGEZ: begin
        b_j_PC = bgez_res;
        end
  J_DIS: begin
        b_j_PC = added_PC_res;
        end
  JR: begin
        b_j_PC = added_PC_res;
      end
  JAL: begin
        b_j_PC = added_PC_res;
       end
  JALR: begin
        b_j_PC = added_PC_res;
        end
  default: begin
        b_j_PC = PC;
        end

endcase

assign reg_data = PC;

endmodule
