// Arithmetic Logic Unit (ALU) that works according to the homework requirements.
// This ALU supports addition, subtraction, AND, XOR, and set less than (slt) operations.

module alu(
    input [31:0] a,          // First operand
    input [31:0] b,          // Second operand
    input [2:0] alu_control, // ALU control signal
    
    output [31:0] result,   // ALU result
    output overflow,        // Overflow flag
    output carry            // Carry out flag
);

    // Wire declarations for internal signals
    wire [31:0] add_result, sub_result, and_result, xor_result; // ALU operation results
    wire [31:0] slt_extended; // Extended SLT result
    wire slt_result; // SLT result (1 bit)
    wire msb_a, msb_b, sum_msb; // MSB of operands and result
    wire [31:0] b_inverted; // Inverted b for subtraction
    wire cin_for_sub, cout_add, cout_sub; // Carry out signals for addition and subtraction

    // MSB (Most Significant Bit) of a and b for overflow detection
    assign msb_a = a[31];
    assign msb_b = b[31];
    
    // Full adder for addition
    fulladder_32bit adder(
        .a(a), // First operand
        .b(b), // Second operand
        .cin(1'b0), // Carry-in for addition is 0
        .sum(add_result), // Sum result
        .cout(cout_add) // Carry out for addition
    );
    
    assign b_inverted = ~b; // Inverted b for subtraction
    assign cin_for_sub = 1'b1; // Carry-in for subtraction is 1 (to add 1 after inversion)
    
    // Full adder for subtraction
    fulladder_32bit subtractor(
        .a(a), // First operand
        .b(b_inverted), // Inverted second operand
        .cin(cin_for_sub), // Carry-in for subtraction
        .sum(sub_result), // Subtraction result
        .cout(cout_sub) // Carry out for subtraction
    );
    
    // MSB of the result for overflow detection
    // We check the MSB of the result based on the operation type
    assign sum_msb = (alu_control == 3'b000) ? add_result[31] : sub_result[31];
    
    // AND operation
    and_32bit and_op(
        .a(a), // First operand
        .b(b), // Second operand
        .result(and_result) // AND result
    );
    
    // XOR operation
    xor_32bit xor_op(
        .a(a), // First operand
        .b(b), // Second operand
        .result(xor_result) // XOR result
    );
    
    // SLT (Set if Less Than) operation
    slt_32bit slt_op(
        .msb_a(msb_a), // MSB of first operand
        .msb_b(msb_b), // MSB of second operand
        .sum_msb(sum_msb), // MSB of the addition/subtraction result
        .ctrl0(alu_control[0]), // Control signal for SLT operation
        .ctrl1(alu_control[1]), // Control signal for SLT operation
        .overflow(overflow), // Overflow flag
        .slt_result(slt_result) // SLT result (1 bit)
    );
    
    // Extend SLT result to 32 bits
    zeroextender_32bit slt_extender(
        .i(slt_result), // Input SLT result (1 bit)
        .o(slt_extended) // Output extended SLT result (32 bits)
    );
    
    // Multiplexer to select the final result based on ALU control signal
    mux_5x1_32bit result_mux(
        .add_result(add_result), // Addition result
        .sub_result(sub_result), // Subtraction result
        .and_result(and_result), // AND result
        .xor_result(xor_result), // XOR result
        .slt_result(slt_extended), // Extended SLT result
        .select(alu_control), // ALU control signal to select the operation
        .result(result) // Final ALU result
    );
    
    // Carry out signal assignment based on ALU control signal
    assign carry = (alu_control == 3'b000) ? cout_add : 
                   (alu_control == 3'b001) ? cout_sub : 1'b0;
    
endmodule