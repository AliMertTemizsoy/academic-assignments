// Program Counter Module
// This module implements a simple program counter that increments the current instruction address

module program_counter(
    input clk, // Clock signal
    input reset, // Reset signal
    input [31:0] pc_next, // Next program counter value (address of the next instruction)
    output reg [31:0] pc_current // Current program counter value (address of the current instruction)
);
    always @(posedge clk or posedge reset) begin
        if (reset)  // If reset is high, set the program counter to 0
            pc_current <= 32'b0; 
        else
            pc_current <= pc_next; // Otherwise, update the program counter to the next value
    end
endmodule