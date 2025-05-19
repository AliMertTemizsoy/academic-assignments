// Immediate Generator Module (With 3-bit Selector)

module imm_generator_v3(
    input [31:0] instr, // 32-bit instruction input
    input [2:0] imm_src,    // 3-bit immediate source selector
    output reg [31:0] imm_ext // 32-bit immediate extended output
);
    always @(*) begin
        case(imm_src)
            3'b000: imm_ext = {{20{instr[31]}}, instr[31:20]};                       // I-type
            3'b001: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};          // S-type
            3'b010: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            3'b011: imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type
            3'b100: imm_ext = {instr[31:12], 12'b0};                                 // U-type (LUI)
            default: imm_ext = 32'b0;
        endcase
    end
endmodule