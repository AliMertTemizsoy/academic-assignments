// 5-to-1 multiplexer for 32-bit inputs

module mux_5x1_32bit(
    input [31:0] add_result, // Addition result
    input [31:0] sub_result, // Subtraction result
    input [31:0] and_result, // AND result
    input [31:0] xor_result, // XOR result
    input [31:0] slt_result, // Set Less Than result
    input [2:0] select, // 3-bit select line to choose the output
    output reg [31:0] result // 32-bit output for the selected result
);

    always @(*) begin // Always block to evaluate the output based on the select line
        case(select)
            3'b000: result = add_result;  // Add
            3'b001: result = sub_result;  // Subtract
            3'b010: result = and_result;  // AND
            3'b011: result = xor_result;  // XOR
            3'b101: result = slt_result;  // SLT
            default: result = 32'b0;      // Default case to avoid latches
        endcase
    end

endmodule