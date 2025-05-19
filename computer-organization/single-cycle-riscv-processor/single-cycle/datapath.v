// Datapath module for a RISC-V processor
// This module connects various components of the processor including the program counter, ALU, register file, and memory
// It implements the main data path for executing instructions

module datapath(
    input clk, reset, // Clock and reset signals
    input reg_write, // Register write enable signal
    input alu_src, // ALU source selector (0: use register, 1: use immediate)
    input mem_write, // Memory write enable signal
    input result_src, // Result source selector (0: ALU result, 1: memory data)
    input pc_src, // PC source selector (0: next instruction, 1: branch/jump target)
    input jump, // Jump control signal (0: no jump, 1: jump)
    input [2:0] alu_control, // ALU control signal to select the operation
    input [1:0] imm_src, // Immediate source selector (00: I-type, 01: S-type, 10: B-type, 11: J-type)
    output zero, // Zero flag from ALU
    output [31:0] pc_current, // Current program counter value
    input [31:0] instr, // Instruction input
    output [31:0] alu_result, // ALU result output
    output [31:0] write_data, // Data to be written to memory or register
    input [31:0] read_data // Data read from memory
);
    // Internal wires
    wire [31:0] pc_next, pc_plus4, pc_target; // Next PC, PC+4, and branch target address
    wire [31:0] imm_ext; // Extended immediate value
    wire [31:0] src_a, src_b; // ALU source operands
    wire [31:0] result; // Result from ALU or memory
    wire [4:0] write_reg; // Register to write to (rd)
    
    // Program Counter
    program_counter pc(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );
    
    // PC+4 adder
    fulladder_32bit pc_plus4_adder(
        .a(pc_current),
        .b(32'd4),
        .cin(1'b0),
        .sum(pc_plus4),
        .cout() // Unused
    );
    
    // Branch target adder
    fulladder_32bit pc_target_adder(
        .a(pc_current),
        .b(imm_ext),
        .cin(1'b0),
        .sum(pc_target),
        .cout() // Unused
    );
    
    // PC source mux
    // Select between PC+4 and branch target address based on branch condition
    assign pc_next = pc_src ? pc_target : pc_plus4;
    
    // Register file
    register_file rf(
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(instr[19:15]),  // rs1
        .read_reg2(instr[24:20]),  // rs2
        .write_reg(instr[11:7]),   // rd
        .write_data(result),
        .read_data1(src_a),        // read data from rs1
        .read_data2(write_data)    // read data from rs2
    );
    
    // Immediate extension
    imm_generator imm_generator(
        .instr(instr),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );
    
    // ALU source mux
    // Select between register value and immediate value based on ALU source selector
    assign src_b = alu_src ? imm_ext : write_data;
    
    // ALU
    alu_mips main_alu(
        .src_a(src_a),
        .src_b(src_b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );
    
    // Result source mux
    // Select between ALU result and memory data based on result source selector
    // If jump is asserted, use PC+4 as the result
    // This is to handle jump instructions where the result is the next instruction address
    // Otherwise, select between ALU result and memory data
    // The result is used to write back to the register file or memory
    assign result = (jump) ? pc_plus4 : (result_src ? read_data : alu_result);
    
endmodule