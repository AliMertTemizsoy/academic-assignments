// Testbenbch for the second datapath module

module datapath_tb_b;
    reg clk, rst; // Clock and reset signals
    reg [2:0] alu_control; // ALU control signal
    reg [1:0] addr1, addr2, addr3; // Register addresses
    reg wr; // Write enable signal
    wire [31:0] alu_result; // ALU result
    wire overflow, carry; // Overflow and carry flags
    
    // We are using i to iterate through the registers
    integer i;
    
    // Instantiate the datapath module
    datapath dut(
        .clk(clk), // Clock signal
        .rst(rst), // Reset signal
        .alu_control(alu_control), // ALU control signal
        .addr1(addr1), // Address for the first register
        .addr2(addr2), // Address for the second register
        .addr3(addr3), // Address for the third register
        .wr(wr), // Write enable signal
        .alu_result(alu_result), // ALU result
        .overflow(overflow), // Overflow flag
        .carry(carry) // Carry flag
    );
    
    // Generate clock signal
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("datapath_b.vcd");
        $dumpvars(0, datapath_tb_b);
        
        // Initialize signals
        clk = 0; // Initialize clock to 0
        rst = 0; // Initialize reset to 0
        alu_control = 3'b000; // Initialize ALU control signal to 0
        addr1 = 2'b00; // Initialize address 1 to 0
        addr2 = 2'b00; // Initialize address 2 to 0
        addr3 = 2'b00; // Initialize address 3 to 0
        wr = 0; // Initialize write enable signal to 0
        
        #10;
        
        $display("\n======== BASLANGIC YAZMAC DEGERLERI ========");
        for(i = 0; i < 4; i = i + 1) begin
            #2 $display("Register R%0d = 0x%8h", i, dut.rf.register[i]); // Display initial register values
        end
        $display("==========================================\n");
        
        // Test case 1: R1 <- R0 XOR R0 (= 0)
        $display("Test Case 1: R1 <- R0 XOR R0");
        addr1 = 2'b00; // Address for R0
        addr2 = 2'b00; // Address for R0 (XOR with itself)
        addr3 = 2'b01; // Address for R1 (destination register)
        alu_control = 3'b011; // XOR operation
        wr = 1; // Enable write to register
        #10;
        wr = 0; // Disable write to register
        $display("1. Komut: R1 <- R0 XOR R0 = 0x%8h\n", dut.rf.register[1]); // Display result
        
        // Test case 2: R0 <- R2 (-1)
        $display("Test Case 2: R0 <- R2 (-1)");
        addr1 = 2'b10; // Address for R2 (which is -1)
        addr2 = 2'b01; // This doesn't matter for this operation
        addr3 = 2'b00; // Address for R0 (destination register)
        alu_control = 3'b000; // ADD operation but we're essentially copying R2
        wr = 1; // Enable write to register
        #10; 
        wr = 0; // Disable write to register
        $display("2. Komut: R0 <- R2 (-1) = 0x%8h\n", dut.rf.register[0]);
        
        // Test case 3: R2 <- R1 - R3
        $display("Test Case 3: R2 <- R1 - R3");
        addr1 = 2'b01; // Address for R1 (which is 0)
        addr2 = 2'b11; // Address for R3 (which is 1)
        addr3 = 2'b10; // Address for R2 (destination register)
        alu_control = 3'b001; // SUB operation
        wr = 1; // Enable write to register
        #10;
        wr = 0; // Disable write to register
        $display("3. Komut: R2 <- R1 - R3 = 0x%8h\n", dut.rf.register[2]);
        
        // Test case 4: R3 <- R0 + R3
        $display("Test Case 4: R3 <- R0 + R3");
        addr1 = 2'b00; // Address for R0 (which is -1)
        addr2 = 2'b11; // Address for R3 (which is 1)
        addr3 = 2'b11; // Address for R3 (destination register)
        alu_control = 3'b000; // ADD operation
        wr = 1; // Enable write to register
        #10;
        wr = 0; // Disable write to register
        $display("4. Komut: R3 <- R0 + R3 = 0x%8h", dut.rf.register[3]);
        
        $display("\n======== SON YAZMAC DEGERLERI ========");
        for(i = 0; i < 4; i = i + 1) begin
            #2 $display("Register R%0d = 0x%8h", i, dut.rf.register[i]); // Display final register values
        end
        $display("======================================\n");
        
        // Finish the simulation after a delay
        #10 $finish;
    end
endmodule

// Compile and run the testbench using the following commands:
// iverilog -o datapath_tb_b datapath.v regfile.v alu.v and_32bit.v fulladder_32bit.v mux_2x1_32bit.v mux_5x1_32bit.v slt_32bit.v xor_32bit.v zeroextender_32bit.v datapath_tb_b.v
// vvp datapath_tb_b
// gtkwave