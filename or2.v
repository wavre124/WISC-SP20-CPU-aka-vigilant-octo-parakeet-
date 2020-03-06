module or2 (in1,in2,out);
    input in1,in2;
    output out;

    wire out_inv;

    nor2 or_one(.in1(in1), .in2(in2), .out(out_inv));
    not1 inv_one(.in1(out_inv), .out(out));

endmodule
