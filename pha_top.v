`timescale 1ns / 1ps

module pha_top(
    input clk,               // 125 MHz clock from Red Pitaya ADC
    input reset,             // Global reset
    input [13:0] adc_in,     // Raw 14-bit data from the ADC
    input [13:0] threshold,  // Energy threshold for peak detection
    output [31:0] hist_data  // Final count output
);

    // Internal Wires to connect the blocks
    wire [13:0] filtered_signal;
    wire [13:0] detected_peak;
    wire        write_enable;

    // 1. Signal Conditioning 
    moving_average filter_inst (
        .clk(clk),
        .adc_data_in(adc_in),
        .filtered_data(filtered_signal)
    );

    // 2. Peak Detection
    peak_detector detector_inst (
        .clk(clk),
        .reset(reset),
        .data_in(filtered_signal),
        .threshold(threshold),
        .peak_value(detected_peak),
        .write_en(write_enable)
    );

    // 3. Histogram Memory
    histogram_mem memory_inst (
        .clk(clk),
        .addr(detected_peak),
        .we(write_enable),
        .count_out(hist_data)
    );

endmodule
