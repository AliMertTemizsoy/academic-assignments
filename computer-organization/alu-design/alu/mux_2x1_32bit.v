// 2x1 Multiplexer for 32-bit inputs

module mux_2x1_32bit(
    input [31:0] a, // First 32-bit input
    input [31:0] b, // Second 32-bit input
    input select, // Select line to choose between the two inputs
    output [31:0] out // 32-bit output for the selected input
);
    assign out = (select) ? b : a; // If select is 1, output b; otherwise, output a
endmodule