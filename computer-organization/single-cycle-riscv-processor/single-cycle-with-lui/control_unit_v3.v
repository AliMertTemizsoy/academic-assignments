// Control Unit for our third RISC-V Processor
// This module generates control signals for the processor based on the opcode and funct3/funct7 fields

module control_unit_v3(
    input [6:0] opcode, // 7-bit opcode input
    input [2:0] funct3, // 3-bit funct3 field
    input funct7_5, // 1-bit funct7 field (bit 5)
    input zero, // Zero flag from ALU
    input reset, // Reset signal
    output reg reg_write, // Register write enable signal
    output reg [2:0] imm_src, // Immediate source selector (000: I-type, 001: S-type, 010: B-type, 011: J-type, 100: U-type)  
    output reg alu_src, // ALU source selector (0: use register, 1: use immediate)
    output reg mem_write, // Memory write enable signal
    output reg result_src, // Result source selector (0: ALU result, 1: memory data)
    output reg pc_src, // PC source selector (0: next instruction, 1: branch/jump target)
    output reg [2:0] alu_control, // ALU control signal to select the operation // 3-bit ALU control signal (000: ADD, 001: SUB, 010: AND, 011: OR, 100: XOR, 101: SLT, 110: SLL)
    output reg jump, // Jump control signal (0: no jump, 1: jump)
    output reg lui_src // LUI source selector (0: use register, 1: use immediate)
);
    // Internal control signals
    wire [1:0] alu_op; // ALU operation code (00: add, 01: sub, 10: R-type, 11: J-type)
    wire branch; // Branch control signal (0: no branch, 1: branch)
    // Internal control signals for main decoder
    wire reg_write_internal, alu_src_internal, mem_write_internal, result_src_internal, jump_internal, lui_src_internal;
    wire [2:0] imm_src_internal;  // Immediate source selector (000: I-type, 001: S-type, 010: B-type, 011: J-type, 100: U-type) 
    wire [2:0] alu_control_internal; // ALU control signal to select the operation // 3-bit ALU control signal (000: ADD, 001: SUB, 010: AND, 011: OR, 100: XOR, 101: SLT, 110: SLL)
    wire [1:0] alu_op_internal; // ALU operation code (00: add, 01: sub, 10: R-type, 11: J-type)
    wire branch_internal; // Branch control signal (0: no branch, 1: branch)
    
    // Initial values for control signals
    initial begin
        reg_write = 1'b0;
        imm_src = 3'b000;  
        alu_src = 1'b0;
        mem_write = 1'b0;
        result_src = 1'b0;
        pc_src = 1'b0;
        alu_control = 3'b000;
        jump = 1'b0;
        lui_src = 1'b0;
    end
    
    // Instantiate main decoder
    main_decoder_v3 md(
        .opcode(opcode),
        .reset(reset),
        .reg_write(reg_write_internal),
        .imm_src(imm_src_internal),
        .alu_src(alu_src_internal),
        .mem_write(mem_write_internal),
        .result_src(result_src_internal),
        .branch(branch_internal),
        .alu_op(alu_op_internal),
        .jump(jump_internal),
        .lui_src(lui_src_internal)
    );
    
    // Instantiate ALU decoder
    alu_decoder_v2 ad(
        .alu_op(alu_op_internal),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .alu_control(alu_control_internal)
    );
    
    
    always @(*) begin
        if (reset) begin // If reset is high, set all control signals to default values
            reg_write = 1'b0;
            imm_src = 3'b000;  
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0;
            pc_src = 1'b0;
            alu_control = 3'b000;
            jump = 1'b0;
            lui_src = 1'b0;
        end
        else begin
            reg_write = reg_write_internal; // Register write enable signal
            imm_src = imm_src_internal; // Immediate source selector
            alu_src = alu_src_internal; // ALU source selector
            mem_write = mem_write_internal; // Memory write enable signal
            result_src = result_src_internal; // Result source selector
            pc_src = (branch_internal & zero) | jump_internal; // PC source selector (branch or jump)
            alu_control = alu_control_internal; // ALU control signal
            jump = jump_internal; // Jump control signal
            lui_src = lui_src_internal; // LUI source selector (0: use register, 1: use immediate)
        end
    end
endmodule