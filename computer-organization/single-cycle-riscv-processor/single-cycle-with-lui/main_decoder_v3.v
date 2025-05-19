// Main Decoder for third RISC-V Processor

module main_decoder_v3(
    input [6:0] opcode, // 7-bit opcode input
    input reset, // Reset signal
    output reg reg_write, // Register write enable signal
    output reg [2:0] imm_src, // Immediate source selector (000: I-type, 001: S-type, 010: B-type, 011: J-type, 100: U-type)  
    output reg alu_src, // ALU source selector (0: use register, 1: use immediate)
    output reg mem_write, // Memory write enable signal
    output reg result_src, // Result source selector (0: ALU result, 1: memory data)
    output reg branch, // Branch control signal (0: no branch, 1: branch)
    output reg [1:0] alu_op, // ALU operation code (00: add, 01: sub, 10: R-type, 11: J-type)
    output reg jump, // Jump control signal (0: no jump, 1: jump)
    output reg lui_src // LUI source selector (0: no LUI, 1: LUI) 
);

    always @(*) begin
        if (reset) begin // If reset is high, set all control signals to default values
            reg_write = 1'b0;
            imm_src = 3'b000;  
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b00;
            jump = 1'b0;
            lui_src = 1'b0;
        end
        else begin
            case(opcode)
                7'b0110011: begin // R-type (add, sub, slt, or, and, sll)
                    reg_write = 1'b1; // Enable register write
                    imm_src = 3'bxxx; // No immediate value needed for R-type  
                    alu_src = 1'b0; // Use register value for ALU operation
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'b0; // Use ALU result
                    branch = 1'b0; // No branch operation
                    alu_op = 2'b10; // ALU operation is determined by funct3 and funct7 fields
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b0; // No LUI operation
                end
                7'b0000011: begin // I-type (lw)
                    reg_write = 1'b1; // Enable register write
                    imm_src = 3'b000; // Immediate value is from the instruction (I-type)  
                    alu_src = 1'b1; // Use immediate value for ALU operation
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'b1; // Use memory data as result
                    branch = 1'b0; // No branch operation
                    alu_op = 2'b00; // ALU operation is addition (for address calculation)
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b0; // No LUI operation
                end
                7'b0100011: begin // S-type (sw)
                    reg_write = 1'b0; // No register write operation
                    imm_src = 3'b001; // Immediate value is from the instruction (S-type)  
                    alu_src = 1'b1; // Use immediate value for ALU operation
                    mem_write = 1'b1; // Enable memory write operation
                    result_src = 1'bx; // Don't care for result source
                    branch = 1'b0; // No branch operation
                    alu_op = 2'b00; // ALU operation is addition (for address calculation)
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b0; // No LUI operation
                end
                7'b1100011: begin // B-type (beq)
                    reg_write = 1'b0; // No register write operation
                    imm_src = 3'b010; // Immediate value is from the instruction (B-type)  
                    alu_src = 1'b0; // Use register value for ALU operation
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'bx; // Don't care for result source
                    branch = 1'b1; // Enable branch operation
                    alu_op = 2'b01; // ALU operation is subtraction (for branch comparison)
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b0; // No LUI operation
                end
                7'b0010011: begin // I-type ALU (addi, slti, ori, andi)
                    reg_write = 1'b1; // Enable register write
                    imm_src = 3'b000; // Immediate value is from the instruction (I-type) 
                    alu_src = 1'b1; // Use immediate value for ALU operation
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'b0; // Use ALU result 
                    branch = 1'b0; // No branch operation
                    alu_op = 2'b10; // ALU operation is determined by funct3 field
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b0; // No LUI operation
                end
                7'b1101111: begin // J-type (jal)
                    reg_write = 1'b1; // Enable register write
                    imm_src = 3'b011; // Immediate value is from the instruction (J-type)
                    alu_src = 1'bx;   // Don't care for ALU source
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'b0; // Use ALU result (PC+4) as result
                    branch = 1'b0; // No branch operation
                    alu_op = 2'bxx; // Don't care for ALU operation
                    jump = 1'b1; // Enable jump operation
                    lui_src = 1'b0; // No LUI operation
                end
                7'b0110111: begin // U-type (lui)
                    reg_write = 1'b1; // Enable register write
                    imm_src = 3'b100; // Immediate value is from the instruction (U-type)  
                    alu_src = 1'bx; // Don't care for ALU source  
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'bx; // Don't care for result source
                    branch = 1'b0; // No branch operation
                    alu_op = 2'b00; // ALU operation is addition (for address calculation)
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b1; // LUI active
                end
                7'b0010111: begin // U-type (auipc)
                    reg_write = 1'b1; // Enable register write
                    imm_src = 3'b100; // Immediate value is from the instruction (U-type)
                    alu_src = 1'bx; // Don't care for ALU source
                    mem_write = 1'b0; // No memory write operation
                    result_src = 1'bx; // Don't care for result source
                    branch = 1'b0; // No branch operation
                    alu_op = 2'b00; // Don't care for ALU operation
                    jump = 1'b0; // No jump operation
                    lui_src = 1'b1; // LUI active
                end
                default: begin // Default case for unsupported opcodes
                    reg_write = 1'b0;
                    imm_src = 3'b000;  
                    alu_src = 1'b0;
                    mem_write = 1'b0;
                    result_src = 1'b0;
                    branch = 1'b0;
                    alu_op = 2'b00;
                    jump = 1'b0;
                    lui_src = 1'b0;
                end
            endcase
        end
    end
endmodule