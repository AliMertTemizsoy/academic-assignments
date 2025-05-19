// Register file module for our first RISC-V processor
// This module implements a 32 x 32-bit register file with synchronous write and asynchronous read capabilities

module register_file(
    input clk, // Clock signal
    input reset, // Reset signal
    input reg_write, // Register write enable signal
    input [4:0] read_reg1, read_reg2, write_reg, // 5-bit register addresses (0-31)
    // Read register addresses (read_reg1 and read_reg2) and write register address (write_reg)

    input [31:0] write_data, // Data to be written to the register file
    output [31:0] read_data1, read_data2 // Read data outputs (read_data1 and read_data2)
);
    
    reg [31:0] registers [0:31]; // 32 x 32-bit register file (array of registers)
    integer i; // Loop variable for initialization
    
    // Write logic (synchronous)
    always @(posedge clk) begin
        if (reset) begin // If reset is high, initialize all registers to zero
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (reg_write && write_reg != 0) begin // If reg_write is high and write_reg is not zero
            registers[write_reg] <= write_data; // Write data to the specified register
        end
    end
    
    // Read logic (asynchronous)

    // We ensure that the read register is not zero (register 0) by returning 0 if it is
    // This is because register 0 is hardwired to zero in RISC-V architecture

    // Read data from the first register (read_reg1)
    assign read_data1 = (read_reg1 == 0) ? 32'b0 : registers[read_reg1]; 

    // Read data from the second register (read_reg2)
    assign read_data2 = (read_reg2 == 0) ? 32'b0 : registers[read_reg2];
    
endmodule