// This is a testbench for the ALU module.

module alu_tb;
    reg [31:0] a, b;         // Input operands
    reg [2:0] alu_control;   // ALU control signal
    wire [31:0] result;      // ALU result
    wire overflow;           // Overflow flag
    wire carry;              // Carry flag

    // Instantiate the ALU module
    alu uut(
        .a(a), // Input operand a
        .b(b), // Input operand b
        .alu_control(alu_control), // ALU control signal
        .result(result), // ALU result
        .overflow(overflow), // Overflow flag
        .carry(carry) // Carry flag
    );
    
    initial begin
        
        $dumpfile("alu.vcd");  
        $dumpvars(0, alu_tb); 

        a = 0; // Initialize input operands
        b = 0; // Initialize input operands
        alu_control = 0; // Initialize ALU control signal
        
        // Wait for the global reset
        #10;
        
        // Test case 1: Addition (alu_control = 000)
        a = 32'd10;
        b = 32'd5;
        alu_control = 3'b000;
        #10;
        $display("Addition:      %d + %d = %d,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        
        // Test case 2: Subtraction (alu_control = 001)
        a = 32'd10;
        b = 32'd5;
        alu_control = 3'b001;
        #10;
        $display("Subtraction:   %d - %d = %d,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        
        // Test case 3: AND operation (alu_control = 010)
        a = 32'hF0F0;
        b = 32'hFF00;
        alu_control = 3'b010;
        #10;
        $display("AND:           0x%h & 0x%h = 0x%h,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        
        // Test case 4: XOR operation (alu_control = 011)
        a = 32'hF0F0;
        b = 32'hFF00;
        alu_control = 3'b011;
        #10;
        $display("XOR:           0x%h ^ 0x%h = 0x%h,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        
        // Test case 5: Set Less Than (alu_control = 101)
        a = 32'd5;
        b = 32'd10;
        alu_control = 3'b101;
        #10;
        $display("SLT:           %d < %d = %d,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        
        // Test case 6: Overflow test
        a = 32'h7FFFFFFF; // Maximum positive 32-bit signed integer
        b = 32'd1;
        alu_control = 3'b000; // Addition to cause overflow
        #10;
        $display("Overflow test: 0x%h + 0x%h = 0x%h,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);

        // Test case 7: Overflow test for subtraction
        a = 32'h80000000; // Minimum negative 32-bit signed integer
        b = 32'd1;
        alu_control = 3'b001; // Subtraction to cause overflow
        #10;
        $display("Overflow test (sub): 0x%h - 0x%h = 0x%h,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        
        // Test case 8: SLT with equal numbers
        a = 32'd10;
        b = 32'd10;
        alu_control = 3'b101;
        #10;
        $display("SLT (equal):   %d < %d = %d,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);

        // Test case 9: SLT with negative number
        a = 32'hFFFFFFFB; // -5
        b = 32'd10;
        alu_control = 3'b101;
        #10;
        // The reason for using $signed is to interpret the numbers as signed integers
        $display("SLT (negative): %d < %d = %d,\tOverflow: %b, Carry: %b", $signed(a), b, result, overflow, carry); 

        // Test case 10: Carry test for addition
        a = 32'hFFFFFFFF;
        b = 32'd1;
        alu_control = 3'b000;
        #10;
        $display("Carry test: 0x%h + 0x%h = 0x%h,\tOverflow: %b, Carry: %b", a, b, result, overflow, carry);
        // End simulation
        
        #10;
        $finish;
    end
endmodule

// Compile and run the testbench using the following commands:
// iverilog -o alu_tb alu.v alu_tb.v fulladder_32bit.v and_32bit.v xor_32bit.v slt_32bit.v mux_2x1_32bit.v mux_5x1_32bit.v zeroextender_32bit.v
// vvp alu_tb
// gtkwave