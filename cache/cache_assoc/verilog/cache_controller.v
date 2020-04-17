module cache_controller(clk, rst, read, write, c_hit_0, c_hit_1,
                        c_dirty_0, c_dirty_1, c_valid_0, c_valid_1,
                        c_tag_0, c_tag_1, busy,
                        c_enable_0, c_enable_1, mem_rd, mem_wr,
                        c_comp_0, c_comp_1, c_write_0, c_write_1,
                        valid_in_0, valid_in_1, mem_cache_wr, done,
                        mem_address, c_offset_0, c_offset_1, c_tag_out_0, c_tag_out_1, way);

// controller inputs
input clk, rst;
input read, write;
input c_hit_1, c_hit_0;
input c_dirty_0, c_dirty_1;
input c_valid_0, c_valid_1;
input [4:0] c_tag_0, c_tag_1;
input [3:0] busy;

// controller Outputs
output reg c_enable_0, c_enable_1;
output reg mem_rd, mem_wr;
output reg c_comp_0, c_comp_1;
output reg c_write_0, c_write_1;
output reg valid_in_0, valid_in_1;
output reg mem_cache_wr;
output reg done;
output reg [15:0] mem_address;
output reg [2:0] c_offset_0, c_offset_1;
output reg [4:0] c_tag_out_0, c_tag_out_1;
output reg way;

// local params for all states
localparam IDLE = 5'b00000;
localparam COMP_READ = 5'b00001;
localparam COMP_WRITE = 5'b00010;
localparam CACHE_READ = 5'b00011;
localparam CACHE_WRITE = 5'b00100;
localparam MEM_WRITE = 5'b00101;
localparam MEM_WRITE_BACK_WORD_ZERO = 5'b00110;
localparam MEM_WRITE_BACK_WORD_ONE = 5'b00111;
localparam MEM_WRITE_BACK_WORD_TWO = 5'b01000;
localparam MEM_WRITE_BACK_WORD_THREE = 5'b01001;
localparam WB_STALL = 5'b01010;
localparam MEM_READ_ONE = 5'b01011;
localparam MEM_READ_TWO = 5'b01100;
localparam MEM_READ_THREE = 5'b01101;
localparam MEM_READ_FOUR = 5'b01110;
localparam MEM_READ_FIVE = 5'b01111;
localparam MEM_READ_SIX = 5'b10000;
localparam DONE_STATE = 5'b10001;
localparam DONE_STATE_HIT = 5'b10010;
localparam MEM_READ_CR = 5'b10011;

// wires and regs for state machine
output [4:0] curr_state;
reg [4:0] next_state;

// victim way flops
wire victim;
wire valid_vic_check;
reg next_victim;

// state machine flop
dff state_flop[4:0](.q(curr_state), .d(next_state), .clk(clk), .rst(rst));
dff victim_flop(.q(victim), .d(next_victim), .clk(clk), .rst(rst));

// victimway should not be inverted if read and write are both 0
assign valid_vic_check = (~read & ~write) victim : ~victim;



// assign state outputs for each state
always@* case(curr_state)

endcase

endmodule
