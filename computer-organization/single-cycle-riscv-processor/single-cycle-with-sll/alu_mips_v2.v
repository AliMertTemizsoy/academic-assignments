// ALU Module for our second RISC-V Processor
// This module has been modified to include a new operation: SLL (Shift Left Logical).

module alu_mips_v2(
    input [31:0] src_a, src_b, // 32-bit source operands
    input [2:0] alu_control, // ALU control signal to select the operation
    output [31:0] alu_result, // 32-bit ALU result
    output zero // Zero flag to indicate if the result is zero
);
    // ALU operation results
    wire [31:0] add_result, sub_result, and_result, or_result, setlessthan_result, sll_result;

    // Carry out signals for addition and subtraction
    wire add_cout, sub_cout;

    // We instantiate the 32-bit ALU components for different operations
    // Each component is responsible for a specific operation
    
    // Full adder for addition
    fulladder_32bit adder(
        .a(src_a),
        .b(src_b),
        .cin(1'b0),
        .sum(add_result),
        .cout(add_cout)
    );
    
    // Subtractor using 2's complement method
    subtractor_32bit subtractor(
        .a(src_a),
        .b(src_b),
        .difference(sub_result),
        .cout(sub_cout)
    );

    // Bitwise operations
    
    // AND operation
    and_32bit and_op(
        .a(src_a),
        .b(src_b),
        .result(and_result)
    );
    
    // OR operation
    or_32bit or_op(
        .a(src_a),
        .b(src_b),
        .result(or_result)
    );
    
    // Set Less Than operation (slt)
    setlessthan_32bit slt_op(
        .a(src_a),
        .b(src_b),
        .result(setlessthan_result)
    );
    
    // Shift Left Logical operation (sll)
    sll_32bit sll_op(
        .a(src_a),
        .shamt(src_b[4:0]), // Shift amount is taken from the lower 5 bits of src_b
        .result(sll_result)
    );
    
    // Multiplexer to select the result based on ALU control signal
    reg [31:0] result_mux;

    always @(*) begin
        case (alu_control)
            3'b000: result_mux = add_result;  // Add
            3'b001: result_mux = sub_result;  // Subtract
            3'b010: result_mux = and_result;  // And
            3'b011: result_mux = or_result;   // Or
            3'b100: result_mux = sll_result;  // Shift Left Logical
            3'b101: result_mux = setlessthan_result;  // SLT
            default: result_mux = 32'b0;
        endcase
    end
    
    assign alu_result = result_mux; // Assign the selected result to alu_result
    assign zero = (alu_result == 32'b0); // Set zero flag if result is zero
    
endmodule