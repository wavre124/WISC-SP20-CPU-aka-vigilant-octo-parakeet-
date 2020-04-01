/*
   CS/ECE 552 Spring '20

   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the
                     processor.
*/
module memory (address, write_data, Mem_en, Mem_write, Mem_read, clk, rst, PC_src, data_read, halt);

    // TODO: Your code here
    input halt;
    input [15:0] address, write_data;
    input Mem_en, Mem_write, Mem_read, clk, rst;
    input [1:0] PC_src;
    output [15:0] data_read;
    wire createdump;
    wire Mem_en_h;
    assign  Mem_en_h = ~halt & Mem_en;

    assign createdump = (PC_src == 0) ? 1'b1 : 1'b0; //createdump should be a 1 when it is halt instruction PC_src = 00 when halt instruction

    memory2c data_memory (.data_out(data_read), .data_in(write_data), .addr(address), .enable(Mem_en_h), .wr(Mem_write), .createdump(createdump), .clk(clk), .rst(rst));

endmodule
