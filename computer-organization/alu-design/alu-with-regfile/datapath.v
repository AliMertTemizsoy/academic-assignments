// This is a simple datapath module that connects the ALU and register file.

module datapath(
    input clk, rst, // Clock and reset signals
    input [2:0] alu_control, // ALU control signal
    input [1:0] addr1, addr2, addr3, // Register addresses
    input wr, // Write enable signal
    output [31:0] alu_result, // ALU result
    output overflow, carry // Overflow and carry flags
    );

    // Register file and ALU signals
    wire [31:0] rd_data1, rd_data2;
    
    // Register file output data
    wire [31:0] alu_out;
    
    // Instantiate the register file
    regfile rf(
        .clk(clk), // Clock signal
        .rst(rst), // Reset signal
        .addr1(addr1), // Address for first read
        .addr2(addr2), // Address for second read
        .addr3(addr3), // Address for write
        .data1(rd_data1), // Data output for first read
        .data2(rd_data2), // Data output for second read
        .data3(alu_out), // Data input for write
        .wr(wr) // Write enable signal
    );
    
    // Instantiate the ALU module
    alu alu_inst(
        .a(rd_data1), // First operand from register file
        .b(rd_data2), // Second operand from register file
        .alu_control(alu_control), // ALU control signal
        .result(alu_out), // ALU result output
        .overflow(overflow), // Overflow flag output
        .carry(carry) // Carry flag output
    );
    
    assign alu_result = alu_out; // Connect ALU result to output
endmodule