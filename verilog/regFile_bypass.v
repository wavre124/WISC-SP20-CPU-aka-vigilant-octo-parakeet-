/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #2

   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
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

   wire [15:0] read1_bypass, read2_bypass;
   wire [15:0] read1Data_inner, read2Data_inner;

   regFile reg_block(.read1Data(read1Data_inner), .read2Data(read2Data_inner), .err(err), .clk(clk), .rst(rst),
                     .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel),
                     .writeData(writeData), .writeEn(writeEn));

   assign read1_bypass = (writeRegSel == read1RegSel) ? writeData : read1Data_inner;
   assign read2_bypass = (writeRegSel == read2RegSel) ? writeData : read2Data_inner;

   assign read1Data = (writeEn) ? read1_bypass : read1Data_inner;
   assign read2Data = (writeEn) ? read2_bypass : read2Data_inner;

endmodule
