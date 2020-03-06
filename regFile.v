/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #1

   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock.
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */

   localparam reg_zero = 3'b000;
   localparam reg_one = 3'b001;
   localparam reg_two = 3'b010;
   localparam reg_three = 3'b011;
   localparam reg_four = 3'b100;
   localparam reg_five = 3'b101;
   localparam reg_six = 3'b110;
   localparam reg_seven = 3'b111;

   wire [15:0] read_r0, read_r1, read_r2, read_r3, read_r4, read_r5, read_r6, read_r7;

   reg [15:0] read1Data_reg, read2Data_reg;

   reg_8_16b reg_block(.clk(clk), .rst(rst), .writeEn(writeEn), .writeData(writeData), .w_select(writeRegSel),
                      .r0_out(read_r0), .r1_out(read_r1), .r2_out(read_r2), .r3_out(read_r3),
                      .r4_out(read_r4), .r5_out(read_r5), .r6_out(read_r6), .r7_out(read_r7));

   always @* case(read1RegSel)
      reg_zero: begin
                read1Data_reg = read_r0;
                end
      reg_one: begin
               read1Data_reg = read_r1;
               end
      reg_two: begin
               read1Data_reg = read_r2;
               end
      reg_three: begin
               read1Data_reg = read_r3;
               end
      reg_four: begin
                read1Data_reg = read_r4;
                end
      reg_five: begin
                read1Data_reg = read_r5;
                end
      reg_six:  begin
                read1Data_reg = read_r6;
                end
      reg_seven: begin
                read1Data_reg = read_r7;
                end
      default: begin
                read1Data_reg = 16'b0;
               end
   endcase

   always @* case(read2RegSel)
      reg_zero: begin
                read2Data_reg = read_r0;
                end
      reg_one: begin
               read2Data_reg = read_r1;
               end
      reg_two: begin
               read2Data_reg = read_r2;
               end
      reg_three: begin
               read2Data_reg = read_r3;
               end
      reg_four: begin
                read2Data_reg = read_r4;
                end
      reg_five: begin
                read2Data_reg = read_r5;
                end
      reg_six:  begin
                read2Data_reg = read_r6;
                end
      reg_seven: begin
                read2Data_reg = read_r7;
                end
      default: begin
                read2Data_reg = 16'b0;
               end
   endcase

   assign read2Data = read2Data_reg;
   assign read1Data = read1Data_reg;

endmodule
