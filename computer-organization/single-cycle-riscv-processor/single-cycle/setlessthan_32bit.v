// 32-bit Set Less Than Module

module setlessthan_32bit(
    input [31:0] a, // 32-bit input a
    input [31:0] b, // 32-bit input b
    output [31:0] result // 32-bit output result (1 if a < b, else 0)
);
    wire [31:0] difference; // Wire to hold the difference of a and b
    wire cout; // Carry out from the subtraction operation
    
    // 32-bit Subtractor Module
    // We will use a 32-bit subtractor to find a - b
    subtractor_32bit sub(
        .a(a), // 32-bit input a
        .b(b), // 32-bit input b
        .difference(difference), // 32-bit output difference (a - b)
        .cout(cout) // Carry out (not used here, but included for completeness)
    );
    
    // The result is 1 if a < b, which is indicated by the sign bit of the difference
    // If the sign bit of the difference is 1, it means a < b
    assign result = {31'b0, difference[31]};
endmodule