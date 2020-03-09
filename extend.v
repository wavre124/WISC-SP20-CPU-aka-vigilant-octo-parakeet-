module extend(inst, ext_sign, ext_op, ext_imm);

parameter N = 16;

input [N-1:0] inst;
input ext_sign;
input [1:0] ext_op;

output reg[N-1:0] ext_imm;

localparam sm_imm = 2'b00;
localparam lg_imm = 2'b01;
localparam dis_imm = 2'b10;

wire [N-1:0] small_imm;
wire [N-1:0] big_imm;
wire [N-1:0] displacement;

assign small_imm = (ext_sign)      ?  {11{inst[4]}, inst[4:0]}  : {11{1'b0}, inst[4:0]};
assign big_imm = (ext_sign)        ?  {8{inst[7]}, inst[7:0]}  : {8{1'b0}, inst[7:0]};
assign displacement = (ext_sign)   ?  {5{inst[10]}, inst[10:0]}  : {5{1'b0}, inst[10:0]};

always@* case(ext_op)
    sm_imm: begin
            ext_imm = small_imm;
            end
    lg_imm: begin
            ext_imm = big_imm;
            end
    dis_imm: begin
            ext_imm = dis_imm;
             end
    default: begin
            ext_imm = small_imm;
             end
endcase

endmodule
