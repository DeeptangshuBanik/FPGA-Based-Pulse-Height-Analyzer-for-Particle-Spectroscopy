`timescale 1ns / 1ps

module tb_moving_average();
    reg clk;
    reg [13:0] adc_in;
    wire [13:0] filtered_out;

    // Instantiate the Filter
    moving_average uut (
        .clk(clk),
        .adc_data_in(adc_in),
        .filtered_data(filtered_out)
    );

    // 125 MHz clock (8ns period)
    initial clk = 0;
    always #4 clk = ~clk; 

    initial begin
        adc_in = 0;
        #40;
        
        // Input a constant signal
        adc_in = 2000;
        #100;
        
        // Simulate a noise spike
        adc_in = 9000;
        #8; 
        adc_in = 2000;
        
        #200;
        $stop;
    end
endmodule
