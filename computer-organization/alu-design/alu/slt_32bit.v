// 32-bit Set Less Than (SLT) Module
// This module compares two 32-bit inputs and produces a result indicating if the first input is less than the second input

module slt_32bit(
    input msb_a,          // Most significant bit of the first input
    input msb_b,          // Most significant bit of the second input
    input sum_msb,        // Sum of the two inputs (most significant bit)
    input ctrl0,          // ALU Control 0 
    input ctrl1,          // ALU Control 1
    output overflow,      // Overflow   
    output slt_result     // Result of the SLT operation
);
    wire xnor_3_out;      // XNOR operation on the most significant bits and control bit
    wire xor1_out;        // XOR operation between msb_a and sum_msb
    wire not_ctrl1;       // NOT operation on ctrl1
    wire and_3_out;       // AND operation on xnor_3_out, xor1_out, and not_ctrl1

    assign xnor_3_out = ~(msb_a ^ msb_b ^ ctrl0); 
    assign xor1_out = msb_a ^sum_msb; 
    assign not_ctrl1 = ~ctrl1; 
    assign and_3_out = xnor_3_out & xor1_out & not_ctrl1;
    assign overflow = and_3_out;

    assign slt_result = and_3_out ^ sum_msb; // Result of the SLT operation
endmodule