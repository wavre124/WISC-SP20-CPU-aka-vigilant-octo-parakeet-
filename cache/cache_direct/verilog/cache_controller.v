module cache_controller(addr, clk, rst, read, write, hit, dirty, valid, stall_mem,
                        err, busy, enable, mem_wr, mem_rd, comp, c_write,
                        valid_in, mem_cache_wr, done, stall_cache, mem_address, cache_offset,
                        cache_tag_out, cache_tag_in);

input [15:0] addr;
input clk, rst;
input read, write;
input hit, dirty, valid, stall_mem;
input err;
input [3:0] busy;
input [7:0] cache_tag_in;

output reg [15:0] mem_address;
output reg [2:0] cache_offset;
output reg [7:0] cache_tag;
output reg enable, mem_wr, mem_rd, comp;
output reg c_write, valid_in, mem_cache_wr, done;
output reg stall_cache;

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
localparam STALL = 5'b01010;
localparam MEM_READ_ONE = 5'b01011;
localparam MEM_READ_TWO = 5'b01100;
localparam MEM_READ_THREE = 5'b01101;
localparam MEM_READ_FOUR = 5'b01110;
localparam MEM_READ_FIVE = 5'b01111;
localparam MEM_READ_SIX = 5'b10000;
localparam DONE_STATE = 5'b10001;

// wires and regs for state machine
wire [3:0] curr_state;
reg [3:0] next_state;

// state machine flop
dff state_flop[3:0](.q(curr_state), .d(next_state), .clk(clk), .rst(rst));

// next state logic for every state
wire [4:0] idle_next_state;
wire [4:0] comp_read_next_state;
wire [4:0] comp_write_next_state;
wire [4:0] cache_read_next_state;

assign idle_next_state = write ? COMP_WRITE :
                         read  ? COMP_READ : IDLE;

assign comp_read_next_state = (hit & valid) ? DONE_STATE :
                              (~hit & ~valid) | (hit & ~valid) | (~hit & ~dirty) ? MEM_READ :
                              (dirty & ~hit & valid) ? MEM_WRITE_BACK : COMP_READ;

assign comp_write_next_state = (hit & valid) ? DONE_STATE :
                               (hit & ~valid) ? MEM_READ_ONE :
                               (~hit & valid) ? CACHE_READ :
                               (~hit & ~valid) ? MEM_WRITE : COMP_WRITE;

assign cache_read_next_state = (dirty) ?  : MEM_WRITE_BACK_WORD_ZERO : MEM_WRITE;

// assign state outputs for each state
always@* case(curr_state):

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
                             cache_offset = addr[2:0];
                             cache_tag = addr[10:3];
                             mem_address = addr;
                             next_state = idle_next_state;
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
                             cache_tag = addr[10:3];
                             mem_address = addr;
                             next_state = comp_read_next_state;
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
                             cache_tag = addr[10:3];
                             mem_address = addr;
                             next_state = comp_write_next_state;
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
                             cache_tag = addr[10:3];
                             mem_address = addr;
                             next_state = cache_read_next_state;
                             end
  CACHE_WRITE:               begin

                             end
  MEM_WRITE:                 begin
                              enable = 1'b1;
                              mem_wr = 1'b1;
                              mem_rd = 1'b0;
                              comp = 1'b0;
                              c_write = 1'b0;
                              valid_in = 1'b0;
                              mem_cache_wr = 1'b0;
                              done = 1'b0;
                              stall_cache = 1'b1;
                              cache_offset = addr[2:0];
                              cache_tag = addr[10:3];
                              mem_address = addr;
                              next_state = DONE_STATE;
                             end
  MEM_WRITE_BACK_WORD_ZERO:  begin


                             end
  MEM_WRITE_BACK_WORD_ONE:   begin

                             end
  MEM_WRITE_BACK_WORD_TWO:   begin

                             end
  MEM_WRITE_BACK_WORD_THREE: begin


                             end
  STALL:                     begin


                             end

  MEM_READ_ONE:              begin

                             end

  MEM_READ_TWO:              begin

                             end
  MEM_READ_THREE:            begin

                             end
  MEM_READ_FOUR:             begin

                             end
  MEM_READ_FIVE:             begin

                             end
  MEM_READ_SIX:              begin

                             end
  DONE_STATE:                begin
                              
                             end
  default:                   begin

                             end
 endcase

endmodule
