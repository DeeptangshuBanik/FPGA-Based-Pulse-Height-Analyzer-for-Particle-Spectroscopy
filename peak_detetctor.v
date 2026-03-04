`timescale 1ns / 1ps

module peak_detector(
    input clk,
    input reset,
    input [13:0] data_in,
    input [13:0] threshold,
    output reg [13:0] peak_value,
    output reg write_en
);

    // Standard Verilog state definitions
    parameter IDLE = 2'b00;
    parameter HUNT = 2'b01;
    parameter SAVE = 2'b10;
    
    reg [1:0] state;
    reg [13:0] current_max;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            write_en <= 0;
            current_max <= 0;
            peak_value <= 0;
        end else begin
            case (state)
                IDLE: begin
                    write_en <= 0;
                    if (data_in > threshold) begin
                        current_max <= data_in;
                        state <= HUNT;
                    end
                end

                HUNT: begin
                    if (data_in > current_max) begin
                        current_max <= data_in;
                    end 
                    
                    if (data_in < threshold) begin
                        state <= SAVE;
                    end
                end

                SAVE: begin
                    peak_value <= current_max;
                    write_en <= 1; 
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
