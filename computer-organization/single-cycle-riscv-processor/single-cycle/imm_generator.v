// Immediate Generator Module
// This module generates the immediate value based on the instruction and the immediate source type.

module imm_generator(
    input [31:0] instr, // 32-bit instruction input
    input [1:0] imm_src, // 2-bit immediate source selector
    output reg [31:0] imm_ext // 32-bit immediate extended output
);
    always @(*) begin
        case(imm_src)
            2'b00: imm_ext = {{20{instr[31]}}, instr[31:20]}; // I-type immediate                     
            2'b01: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type immediate         
            2'b10: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type immediate 
            2'b11: imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type immediate
            default: imm_ext = 32'b0;
        endcase
    end
endmodule