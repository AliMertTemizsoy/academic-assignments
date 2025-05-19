// RISC-V Processor Module
// This module implements our first RISC-V processor

module riscv_processor(
    input clk, reset, // Clock and reset signals
    output [31:0] pc_current, // Current program counter value (address of the current instruction)
    input [31:0] instr, // Instruction input (from memory)
    output mem_write, // Memory write enable signal
    output [31:0] alu_result, write_data, // ALU result and data to be written to memory or register
    input [31:0] read_data // Data read from memory
);
    // Internal wires

    // Control signals
    wire reg_write, alu_src, result_src, pc_src, zero, jump;
    
    wire [1:0] imm_src; // Immediate source selector (00: I-type, 01: S-type, 10: B-type, 11: J-type)

    wire [2:0] alu_control; // ALU control signal to select the operation
    
    // Instantiate the control unit
    control_unit cu(
        .opcode(instr[6:0]), // 7-bit opcode from instruction
        .funct3(instr[14:12]), // 3-bit funct3 field from instruction
        .funct7_5(instr[30]), // 1-bit funct7 field (bit 5) from instruction
        .zero(zero), // Zero flag from ALU
        .reg_write(reg_write), // Register write enable signal
        .imm_src(imm_src), // Immediate source selector (00: I-type, 01: S-type, 10: B-type, 11: J-type)
        .alu_src(alu_src), // ALU source selector (0: use register, 1: use immediate)
        .mem_write(mem_write), // Memory write enable signal
        .result_src(result_src), // Result source selector (0: ALU result, 1: memory data)
        .pc_src(pc_src), // PC source selector (0: next instruction, 1: branch/jump target)
        .alu_control(alu_control), // ALU control signal to select the operation
        .jump(jump) // Jump control signal (0: no jump, 1: jump)
    ); 
    
    // Instantiate the datapath
    datapath dp(
        .clk(clk), // Clock signal
        .reset(reset), // Reset signal
        .reg_write(reg_write), // Register write enable signal 
        .alu_src(alu_src), // ALU source selector (0: use register, 1: use immediate)
        .mem_write(mem_write), // Memory write enable signal
        .result_src(result_src), // Result source selector (0: ALU result, 1: memory data)
        .pc_src(pc_src), // PC source selector (0: next instruction, 1: branch/jump target)
        .jump(jump), // Jump control signal (0: no jump, 1: jump)
        .alu_control(alu_control), // ALU control signal to select the operation
        .imm_src(imm_src), // Immediate source selector (00: I-type, 01: S-type, 10: B-type, 11: J-type)
        .zero(zero), // Zero flag from ALU
        .pc_current(pc_current), // Current program counter value
        .instr(instr), // Instruction input
        .alu_result(alu_result), // ALU result output
        .write_data(write_data), // Data to be written to memory or register
        .read_data(read_data) // Data read from memory
    );
    
endmodule