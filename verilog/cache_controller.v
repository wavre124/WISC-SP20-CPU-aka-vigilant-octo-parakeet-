module cache_controller(clk, rst, read, write, c_hit_0, c_hit_1,
                        c_dirty_0, c_dirty_1, c_valid_0, c_valid_1,
                        c_tag_0, c_tag_1, busy, addr,
                        c_enable_0, c_enable_1, mem_rd, mem_wr,
                        c_comp_0, c_comp_1, c_write_0, c_write_1,
                        valid_in_0, valid_in_1, mem_cache_wr, done, curr_state,
                        mem_address, c_offset_0, c_offset_1, c_tag_out_0, c_tag_out_1, way, stall, miss);

// controller inputs
input clk, rst;
input read, write;
input c_hit_1, c_hit_0;
input c_dirty_0, c_dirty_1;
input c_valid_0, c_valid_1;
input [4:0] c_tag_0, c_tag_1;
input [3:0] busy;
input [15:0] addr;

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
output reg way, stall, miss;

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
assign valid_vic_check = (~read & ~write) ? victim : ~victim;

wire way_assign;
wire way_check;
wire wb_check;
wire [4:0] way_tag;
wire [4:0] idle_next_state;
wire [4:0] comp_read_next_state;
wire [4:0] comp_write_next_state;
wire [4:0] cache_read_next_state;
wire [4:0] mem_read_next_state;

assign way_check = (curr_state == COMP_READ) | (curr_state == COMP_WRITE);
assign wb_check = (way & c_dirty_1 & c_valid_1) | (~way & c_dirty_0 & c_valid_0);
assign way_tag = (way) ? c_tag_1 : c_tag_0;

assign way_assign = way_check & (c_hit_1 & c_valid_1) ? 1'b1 :
                    way_check & (c_hit_0 & c_valid_0) ? 1'b0 :
                    way_check & (~c_valid_1 & c_valid_0) ? 1'b1 :
                    way_check & (c_valid_1 & ~c_valid_0) ? 1'b0 :
                    way_check & (~c_valid_1 & ~c_valid_0) ? 1'b0 :
                    way_check & (c_valid_1 & c_valid_0) ? valid_vic_check : way_assign;

assign idle_next_state = write ? COMP_WRITE :
                         read  ? COMP_READ : IDLE;

assign comp_read_next_state = (c_hit_1 & c_valid_1) ? DONE_STATE_HIT :
                              (c_hit_0 & c_valid_0) ? DONE_STATE_HIT :
                              (wb_check)            ? MEM_WRITE_BACK_WORD_ZERO : MEM_READ_ONE;

assign comp_write_next_state = (c_hit_1 & c_valid_1) ? DONE_STATE_HIT :
                               (c_hit_0 & c_valid_0) ? DONE_STATE_HIT : CACHE_READ;

assign cache_read_next_state = (wb_check) ? MEM_WRITE_BACK_WORD_ZERO : MEM_READ_ONE;
assign mem_read_next_state = (write) ? CACHE_WRITE : MEM_READ_CR;

// assign state outputs for each state
always@* case(curr_state)

    IDLE:                       begin
                                c_enable_0 = 1'b0;
                                c_enable_1 = 1'b0;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = 16'b0;
                                c_offset_0 = 3'b0;
                                c_offset_1 = 3'b0;
                                c_tag_out_0 = 5'b0;
                                c_tag_out_1 = 5'b0;
                                way = 1'b0;
                                stall = 1'b0;
                                next_victim = victim;
                                next_state = idle_next_state;
                                miss = 1'b0;
                                end
    COMP_READ:                  begin
                                 c_enable_0 = 1'b1;
                                 c_enable_1 = 1'b1;
                                 mem_rd = 1'b0;
                                 mem_wr = 1'b0;
                                 c_comp_0 = 1'b1;
                                 c_comp_1 = 1'b1;
                                 c_write_0 = 1'b0;
                                 c_write_1 = 1'b0;
                                 valid_in_0 = 1'b0;
                                 valid_in_1 = 1'b0;
                                 mem_cache_wr = 1'b0;
                                 done = 1'b0;
                                 mem_address = addr;
                                 c_offset_0 = addr[2:0];
                                 c_offset_1 = addr[2:0];
                                 c_tag_out_0 = addr[15:11];
                                 c_tag_out_1 = addr[15:11];
                                 way = way_assign;
                                 stall = 1'b1;
                                 next_victim = valid_vic_check;
                                 next_state = comp_read_next_state;
                                 miss = 1'b0;
                                end
    COMP_WRITE:                 begin
                                c_enable_0 = 1'b1;
                                c_enable_1 = 1'b1;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b1;
                                c_comp_1 = 1'b1;
                                c_write_0 = 1'b1;
                                c_write_1 = 1'b1;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = valid_vic_check;
                                next_state = comp_write_next_state;
                                miss = 1'b0;
                                end
    CACHE_READ:                begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = cache_read_next_state;
                                miss = 1'b1;
                               end
    CACHE_WRITE:               begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b1;
                                c_comp_1 = 1'b1;
                                c_write_0 = 1'b1;
                                c_write_1 = 1'b1;
                                valid_in_0 = 1'b1;
                                valid_in_1 = 1'b1;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = DONE_STATE;
                                miss = 1'b1;
                               end
    MEM_WRITE_BACK_WORD_ZERO:  begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b1;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                c_offset_0 = {1'b0, 1'b0, addr[0]};
                                c_offset_1 = {1'b0, 1'b0, addr[0]};
                                mem_address = {way_tag, addr[10:3], c_offset_0};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_WRITE_BACK_WORD_ONE;
                                miss = 1'b1;
                               end
    MEM_WRITE_BACK_WORD_ONE:   begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b1;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                c_offset_0 = {1'b0, 1'b1, addr[0]};
                                c_offset_1 = {1'b0, 1'b1, addr[0]};
                                mem_address = {way_tag, addr[10:3], c_offset_0};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_WRITE_BACK_WORD_TWO;
                                miss = 1'b1;
                               end
    MEM_WRITE_BACK_WORD_TWO:   begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b1;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                c_offset_0 = {1'b1, 1'b0, addr[0]};
                                c_offset_1 = {1'b1, 1'b0, addr[0]};
                                mem_address = {way_tag, addr[10:3], c_offset_0};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_WRITE_BACK_WORD_THREE;
                                miss = 1'b1;
                               end
    MEM_WRITE_BACK_WORD_THREE: begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b1;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                c_offset_0 = {1'b1, 1'b1, addr[0]};
                                c_offset_1 = {1'b1, 1'b1, addr[0]};
                                mem_address = {way_tag, addr[10:3], c_offset_0};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_READ_ONE;
                                miss = 1'b1;
                               end
    MEM_READ_ONE:              begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b1;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = {addr[15:3], 1'b0, 1'b0, addr[0]};
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_READ_TWO;
                                miss = 1'b1;
                               end
    MEM_READ_TWO:              begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b1;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = {addr[15:3], 1'b0, 1'b1, addr[0]};
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_READ_THREE;
                                miss = 1'b1;
                               end
    MEM_READ_THREE:            begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b1;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b1;
                                c_write_1 = 1'b1;
                                valid_in_0 = 1'b1;
                                valid_in_1 = 1'b1;
                                mem_cache_wr = 1'b1;
                                done = 1'b0;
                                mem_address = {addr[15:3], 1'b1, 1'b0, addr[0]};
                                c_offset_0 = {1'b0, 1'b0, addr[0]};
                                c_offset_1 = {1'b0, 1'b0, addr[0]};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_READ_FOUR;
                                miss = 1'b1;
                               end
    MEM_READ_FOUR:             begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b1;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b1;
                                c_write_1 = 1'b1;
                                valid_in_0 = 1'b1;
                                valid_in_1 = 1'b1;
                                mem_cache_wr = 1'b1;
                                done = 1'b0;
                                mem_address = {addr[15:3], 1'b1, 1'b1, addr[0]};
                                c_offset_0 = {1'b0, 1'b1, addr[0]};
                                c_offset_1 = {1'b0, 1'b1, addr[0]};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_READ_FIVE;
                                miss = 1'b1;
                               end
    MEM_READ_FIVE:             begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b1;
                                c_write_1 = 1'b1;
                                valid_in_0 = 1'b1;
                                valid_in_1 = 1'b1;
                                mem_cache_wr = 1'b1;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = {1'b1, 1'b0, addr[0]};
                                c_offset_1 = {1'b1, 1'b0, addr[0]};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = MEM_READ_SIX;
                                miss = 1'b1;
                               end
    MEM_READ_SIX:              begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b1;
                                c_write_1 = 1'b1;
                                valid_in_0 = 1'b1;
                                valid_in_1 = 1'b1;
                                mem_cache_wr = 1'b1;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = {1'b1, 1'b1, addr[0]};
                                c_offset_1 = {1'b1, 1'b1, addr[0]};
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = mem_read_next_state;
                                miss = 1'b1;
                               end
    MEM_READ_CR:               begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = DONE_STATE;
                                miss = 1'b1;
                               end
    DONE_STATE:                begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b1;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = IDLE;
                                miss = 1'b1;
                               end
    DONE_STATE_HIT:            begin
                                c_enable_0 = ~way;
                                c_enable_1 = way;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b1;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = way_assign;
                                stall = 1'b1;
                                next_victim = victim;
                                next_state = IDLE;
                                miss = 1'b0;
                               end
    default:                   begin
                                c_enable_0 = 1'b0;
                                c_enable_1 = 1'b0;
                                mem_rd = 1'b0;
                                mem_wr = 1'b0;
                                c_comp_0 = 1'b0;
                                c_comp_1 = 1'b0;
                                c_write_0 = 1'b0;
                                c_write_1 = 1'b0;
                                valid_in_0 = 1'b0;
                                valid_in_1 = 1'b0;
                                mem_cache_wr = 1'b0;
                                done = 1'b0;
                                mem_address = addr;
                                c_offset_0 = addr[2:0];
                                c_offset_1 = addr[2:0];
                                c_tag_out_0 = addr[15:11];
                                c_tag_out_1 = addr[15:11];
                                way = 1'b0;
                                stall = 1'b0;
                                next_victim = victim;
                                next_state = IDLE;
                                miss = 1'b0;
                               end

endcase

endmodule
