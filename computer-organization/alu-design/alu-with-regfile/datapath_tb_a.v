// Testbench for the first datapath module

module datapath_tb_a;
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
        $dumpfile("datapath_a.vcd");
        $dumpvars(0, datapath_tb_a);
        
        // Initialize signals
        clk = 0; // Initialize clock to 0
        rst = 0;  // Initialize reset to 0 
        alu_control = 3'b000; // Initialize ALU control signal to 0
        addr1 = 2'b00; // Initialize address 1 to 0
        addr2 = 2'b00; // Initialize address 2 to 0
        addr3 = 2'b00; // Initialize address 3 to 0
        wr = 0; // Initialize write enable signal to 0
        
        // Wait for the global reset
        #10;
        
        $display("\n======== BASLANGIC YAZMAC DEGERLERI ========");
        for(i = 0; i < 4; i = i + 1) begin
            #2 $display("Register R%0d = 0x%8h", i, dut.rf.register[i]); // Display initial register values
        end
        $display("==========================================\n");
        
        // Test case 1: Addition operation
        addr1 = 2'b01; // Address for R1  
        addr2 = 2'b10; // Address for R2
        addr3 = 2'b00; // Address for R0
        alu_control = 3'b000; // ALU control signal for addition
        wr = 1;  // Initialize write enable signal to 1
        #10;  
        $display("1. Komut: R0 <- R1 + R2      = 0x%8h", alu_result);
        
        // Test case 2: AND operation
        addr1 = 2'b10;  // Address for R2
        addr2 = 2'b11;  // Address for R3
        addr3 = 2'b01;  // Address for R1
        alu_control = 3'b010;  // ALU control signal for AND operation
        wr = 1;  // Initialize write enable signal to 1
        #10;  
        $display("2. Komut: R1 <- R2 AND R3    = 0x%8h", alu_result);
        
        // Test case 3: XOR operation
        addr1 = 2'b10;  // Address for R2
        addr2 = 2'b00;  // Address for R0
        addr3 = 2'b11;  // Address for R3
        alu_control = 3'b011;  // ALU control signal for XOR operation
        wr = 1;  // Initialize write enable signal to 1
        #10;  
        $display("3. Komut: R3 <- R2 XOR R0    = 0x%8h", alu_result);
        
        // Test case 4: Subtraction operation
        addr1 = 2'b01;  // Address for R1
        addr2 = 2'b11;  // Address for R3
        addr3 = 2'b10;  // Address for R2
        alu_control = 3'b001;  // ALU control signal for subtraction
        wr = 1;  // Initialize write enable signal to 1
        #10;  
        $display("4. Komut: R2 <- R1 - R3      = 0x%8h", alu_result);
        
        #10 wr = 0;  
        $display("\n======== SON YAZMAC DEGERLERI ========");
        for(i = 0; i < 4; i = i + 1) begin
            addr1 = i; // Set address 1 to i
            #2 $display("Register R%0d = 0x%8h", i, dut.rf.register[i]); // Display final register values
        end
        $display("======================================\n");
        
        // End the simulation after a delay
        #10 $finish;
    end
endmodule

// Compile and run the testbench using the following commands:
// iverilog -o datapath_tb_a datapath.v regfile.v alu.v and_32bit.v fulladder_32bit.v mux_2x1_32bit.v mux_5x1_32bit.v slt_32bit.v xor_32bit.v zeroextender_32bit.v datapath_tb_a.v
// vvp datapath_tb_a
// gtkwave