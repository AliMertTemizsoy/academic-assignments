// ALU Decoder for our first RISC-V Processor
// This module decodes the ALU operation based on the ALU op code, signal and funct3/funct7 fields 

module alu_decoder(
    input [1:0] alu_op, // ALU operation code      
    input [2:0] funct3,  // Function code 3 bits      
    input funct7_5, // Function code 7 bits (bit 5)          
    output reg [2:0] alu_control  // ALU control signal to select the operation
);

    always @(*) begin
        case(alu_op) // ALU operation code
            2'b00: alu_control = 3'b000;  // ALU operation is addition (used for load/store instructions)
            2'b01: alu_control = 3'b001;  // ALU operation is subtraction (used for branch instructions)
            2'b10: case({funct7_5, funct3})  // ALU operation is determined by funct3 and funct7_5
                4'b0000: alu_control = 3'b000;  // ALU operation is addition (used for R-type instructions)
                4'b1000: alu_control = 3'b001;  // ALU operation is subtraction (used for R-type instructions)
                4'b0111: alu_control = 3'b010;  // ALU operation is AND (used for R-type instructions)
                4'b0110: alu_control = 3'b011;  // ALU operation is OR (used for R-type instructions)
                4'b0010: alu_control = 3'b101;  // ALU operation is set less than (used for R-type instructions)
                default: alu_control = 3'bxxx;  // Default case (should not occur)
            endcase
            default: alu_control = 3'bxxx; // Dont care for other cases
        endcase
    end
endmodule