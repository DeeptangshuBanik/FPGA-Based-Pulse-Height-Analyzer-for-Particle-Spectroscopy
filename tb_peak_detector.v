`timescale 1ns / 1ps

module tb_peak_detector();
    reg clk = 0, reset = 0;
    reg [13:0] data_in = 0;
    reg [13:0] threshold = 500;
    wire [13:0] peak_value;
    wire write_en;

    peak_detector uut (
        .clk(clk), .reset(reset), .data_in(data_in),
        .threshold(threshold), .peak_value(peak_value), .write_en(write_en)
    );

    always #4 clk = ~clk;

    initial begin
        reset = 1; #20; reset = 0; #20;
        
        // Simulate a particle pulse reaching a peak of 1500
        data_in = 200; #10;  
        data_in = 800; #10;  // Threshold crossed: Enter HUNT
        data_in = 1500; #10; // Peak reached
        data_in = 1200; #10; // Falling edge
        data_in = 300; #10;  // Below threshold: Trigger SAVE
        
        #50; $stop;
    end
endmodule
