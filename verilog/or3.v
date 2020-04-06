module or3 (in1,in2,in3,out);
    input in1,in2,in3;
    output out;

    wire int_sig;

    or2 or_one(.in1(in1), .in2(in2), .out(int_sig));
    or2 or_two(.in1(int_sig), .in2(in3), .out(out));

endmodule
