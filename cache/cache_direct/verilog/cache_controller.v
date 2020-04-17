module cache_controller(addr, clk, rst, read, write, hit, dirty, valid, stall_mem,
                        err, busy, enable, mem_wr, mem_rd, comp, c_write,
                        valid_in, mem_cache_wr, done, stall_cache, mem_address, cache_offset,
                        cache_tag_out, cache_tag_in, miss, curr_state);

input [15:0] addr;
input clk, rst;
input read, write;
input hit, dirty, valid, stall_mem;
input err;
input [3:0] busy;
input [4:0] cache_tag_in;

output reg [15:0] mem_address;
output reg [2:0] cache_offset;
output reg [4:0] cache_tag_out;
output reg enable, mem_wr, mem_rd, comp;
output reg c_write, valid_in, mem_cache_wr, done;
output reg stall_cache, miss;

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

// state machine flop
dff state_flop[4:0](.q(curr_state), .d(next_state), .clk(clk), .rst(rst));

// next state logic for every state
wire [4:0] idle_next_state;
wire [4:0] comp_read_next_state;
wire [4:0] comp_write_next_state;
wire [4:0] cache_read_next_state;
wire [4:0] write_stall_next_state;
wire [4:0] wb_stall_next_state;
wire [4:0] mem_read_next_state;

assign idle_next_state = write ? COMP_WRITE :
                         read  ? COMP_READ : IDLE;

// second case in this statement might be redudant
// stinky code written by me :(
assign comp_read_next_state = (hit & valid) ? DONE_STATE_HIT :
                              (~dirty) ? MEM_READ_ONE :
                              (dirty & valid) ? MEM_WRITE_BACK_WORD_ZERO : MEM_READ_ONE;

assign comp_write_next_state = (hit & valid) ? DONE_STATE_HIT : CACHE_READ;

assign cache_read_next_state = (dirty & valid) ? MEM_WRITE_BACK_WORD_ZERO : MEM_READ_ONE;

assign wb_stall_next_state = (~busy) ? MEM_READ_ONE : WB_STALL;

assign mem_read_next_state = (write) ? CACHE_WRITE : MEM_READ_CR;

// assign state outputs for each state
always@* case(curr_state)

  IDLE:                      begin
                             enable = 1'b0;
                             mem_wr = 1'b0;
                             mem_rd = 1'b0;
                             comp = 1'b0;
                             c_write = 1'b0;
                             valid_in = 1'b0;
                             mem_cache_wr = 1'b0;
                             done = 1'b0;
                             stall_cache = 1'b0;
                             cache_offset = 3'b0;
                             cache_tag_out = 5'b0;
                             mem_address = 16'b0;
                             next_state = idle_next_state;
                             miss = 1'b0;
                             end
  COMP_READ:                 begin
                             enable = 1'b1;
                             mem_wr = 1'b0;
                             mem_rd = 1'b0;
                             comp = 1'b1;
                             c_write = 1'b0;
                             valid_in = 1'b0;
                             mem_cache_wr = 1'b0;
                             done = 1'b0;
                             stall_cache = 1'b1;
                             cache_offset = addr[2:0];
                             cache_tag_out = addr[15:11];
                             mem_address = addr;
                             next_state = comp_read_next_state;
                             miss = 1'b0;
                             end
  COMP_WRITE:                begin
                             enable = 1'b1;
                             mem_wr = 1'b0;
                             mem_rd = 1'b0;
                             comp = 1'b1;
                             c_write = 1'b1;
                             valid_in = 1'b0;
                             mem_cache_wr = 1'b0;
                             done = 1'b0;
                             stall_cache = 1'b1;
                             cache_offset = addr[2:0];
                             cache_tag_out = addr[15:11];
                             mem_address = addr;
                             next_state = comp_write_next_state;
                             miss = 1'b0;
                             end
  CACHE_READ:                begin
                             enable = 1'b1;
                             mem_wr = 1'b0;
                             mem_rd = 1'b0;
                             comp = 1'b0;
                             c_write = 1'b0;
                             valid_in = 1'b0;
                             mem_cache_wr = 1'b0;
                             done = 1'b0;
                             stall_cache = 1'b1;
                             cache_offset = addr[2:0];
                             cache_tag_out = addr[15:11];
                             mem_address = addr;
                             next_state = cache_read_next_state;
                             miss = 1'b1;
                             end
  CACHE_WRITE:               begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b1;
                              c_write = 1'b1;
                              valid_in = 1'b1;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = addr[15:0];
                              next_state = DONE_STATE;
                              miss = 1'b1;
                             end
  MEM_WRITE_BACK_WORD_ZERO:  begin
                              enable = 1'b1;
                              mem_wr = 1'b1;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b0, 1'b0, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = {cache_tag_in, addr[10:3], cache_offset};
                              next_state = MEM_WRITE_BACK_WORD_ONE;
                              miss = 1'b1;
                             end
  MEM_WRITE_BACK_WORD_ONE:   begin
                              enable = 1'b1;
                              mem_wr = 1'b1;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b0, 1'b1, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = {cache_tag_in, addr[10:3], cache_offset};
                              next_state = MEM_WRITE_BACK_WORD_TWO;
                              miss = 1'b1;
                             end
  MEM_WRITE_BACK_WORD_TWO:   begin
                              enable = 1'b1;
                              mem_wr = 1'b1;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b1, 1'b0, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = {cache_tag_in, addr[10:3], cache_offset};
                              next_state = MEM_WRITE_BACK_WORD_THREE;
                              miss = 1'b1;
                             end
  MEM_WRITE_BACK_WORD_THREE: begin
                              enable = 1'b1;
                              mem_wr = 1'b1;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b1, 1'b1, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = {cache_tag_in, addr[10:3], cache_offset};
                              next_state = WB_STALL;
                              miss = 1'b1;
                             end
  WB_STALL:                  begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = addr;
                              next_state = wb_stall_next_state;
                              miss = 1'b1;
                             end
  MEM_READ_ONE:              begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b1;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = {addr[15:3], 1'b0, 1'b0, addr[0]};
                              next_state = MEM_READ_TWO;
                              miss = 1'b1;
                             end
  MEM_READ_TWO:              begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b1;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = {addr[15:3], 1'b0, 1'b1, addr[0]};
                              next_state = MEM_READ_THREE;
                              miss = 1'b1;
                             end
  MEM_READ_THREE:            begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b1;
                              comp = 1'b0;
                              c_write = 1'b1;
                              valid_in = 1'b1;
                              mem_cache_wr = 1'b1;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b0, 1'b0, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = {addr[15:3], 1'b1, 1'b0, addr[0]};
                              next_state = MEM_READ_FOUR;
                              miss = 1'b1;
                             end
  MEM_READ_FOUR:             begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b1;
                              comp = 1'b0;
                              c_write = 1'b1;
                              valid_in = 1'b1;
                              mem_cache_wr = 1'b1;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b0, 1'b1, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = {addr[15:3], 1'b1, 1'b1, addr[0]};
                              next_state = MEM_READ_FIVE;
                              miss = 1'b1;
                             end
  MEM_READ_FIVE:             begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b1;
                              valid_in = 1'b1;
                              mem_cache_wr = 1'b1;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b1, 1'b0, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = addr[15:0];
                              next_state = MEM_READ_SIX;
                              miss = 1'b1;
                             end
  MEM_READ_SIX:              begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b1;
                              valid_in = 1'b1;
                              mem_cache_wr = 1'b1;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = {1'b1, 1'b1, addr[0]};
                              cache_tag_out = addr[15:11];
                              mem_address = addr[15:0];
                              next_state = mem_read_next_state;
                              miss = 1'b1;
                             end
  MEM_READ_CR:               begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = addr[15:0];
                              next_state = DONE_STATE;
                              miss = 1'b1;
                             end
  DONE_STATE:                begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b1;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = addr;
                              next_state = IDLE;
                              miss = 1'b1;
                             end
  DONE_STATE_HIT:            begin
                              enable = 1'b1;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b1;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = addr;
                              next_state = IDLE;
                              miss = 1'b0;
                             end
  default:                   begin
                              enable = 1'b0;
                              mem_wr = 1'b0;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b0;
                              cache_offset = addr[2:0];
                              cache_tag_out = addr[15:11];
                              mem_address = addr;
                              next_state = IDLE;
                              miss = 1'b0;
                             end
 endcase
endmodule
