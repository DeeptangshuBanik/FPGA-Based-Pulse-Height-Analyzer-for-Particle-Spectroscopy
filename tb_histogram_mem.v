`timescale 1ns / 1ps

module tb_histogram_mem();
    reg clk = 0, we = 0;
    reg [13:0] addr = 0;
    wire [31:0] count_out;

    histogram_mem uut (
        .clk(clk), .addr(addr), .we(we), .count_out(count_out)
    );

    always #4 clk = ~clk;

    initial begin
        // Hit address 1000 twice
        addr = 1000; we = 1; #8; we = 0; #16;
        addr = 1000; we = 1; #8; we = 0; #16;
        
        // Hit address 500 once
        addr = 500; we = 1; #8; we = 0;
        
        #100; $stop;
    end
endmodule
