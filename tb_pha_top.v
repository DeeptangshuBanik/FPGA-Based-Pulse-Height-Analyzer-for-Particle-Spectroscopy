`timescale 1ns / 1ps

module tb_pha_top();

    // 1. Simulation Signals
    reg clk;
    reg reset;
    reg [13:0] adc_in;
    reg [13:0] threshold;
    wire [31:0] hist_data;

    // 2. Instantiate the Full System (PHA Top)
    pha_top uut (
        .clk(clk),
        .reset(reset),
        .adc_in(adc_in),
        .threshold(threshold),
        .hist_data(hist_data)
    );

    // 3. Clock Generation (125 MHz = 8ns period)
    initial clk = 0;
    always #4 clk = ~clk;

    // 4. Simulating a Particle Pulse
    task simulate_pulse(input [13:0] peak_energy);
        integer i;
        begin
            // Rising Edge (Simulating charge collection)
            for (i = 0; i < 5; i = i + 1) begin
                adc_in = (peak_energy / 5) * i;
                #8;
            end
            // Falling Edge (Simulating RC decay)
            for (i = 5; i > 0; i = i - 1) begin
                adc_in = (peak_energy / 5) * i;
                #8;
            end
            adc_in = 0;
            #80; 
        end
    endtask

    // 5. Test Procedure
    initial begin
        reset = 1;
        adc_in = 0;
        threshold = 500; 
        #40;
        reset = 0;
        #40;

        // Simulate Particle Hit 1: Energy 1500
        simulate_pulse(1500);

        // Simulate Particle Hit 2: Energy 3000
        simulate_pulse(3000);

        #200;
        $display("Simulation Finished. Check Histogram for Energy Bins 1500 and 3000.");
        $stop;
    end

endmodule
