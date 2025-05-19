// Sign-extend module
// This module takes a 16-bit input and extends it to 32 bits by sign-extending

module signext(
    input wire [15:0] a,  // 16-bit input a
    output wire [31:0] y  // 32-bit output y
);
// Sign-extend the 16-bit input to 32 bits
// The most significant bit (MSB) of a is replicated to fill the upper 16 bits of y
// This is done by concatenating 16 copies of the MSB with the original 16 bits of a
// The result is a 32-bit signed integer
// The MSB of a is a[15], so we replicate it 16 times to fill the upper half of y
assign y = {{16{a[15]}}, a};  
endmodule