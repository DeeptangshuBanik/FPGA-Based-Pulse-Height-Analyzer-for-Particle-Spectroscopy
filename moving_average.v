module moving_average(
    input clk,
    input [13:0] adc_data_in,
    output reg [13:0] filtered_data
);
    reg [13:0] pipe [3:0];
    reg [15:0] sum;

    always @(posedge clk) begin
        pipe[0] <= adc_data_in;
        pipe[1] <= pipe[0];
        pipe[2] <= pipe[1];
        pipe[3] <= pipe[2];
        // Simple average: (P0+P1+P2+P3) / 4
        sum <= pipe[0] + pipe[1] + pipe[2] + pipe[3];
        filtered_data <= sum >> 2; 
    end
endmodule
