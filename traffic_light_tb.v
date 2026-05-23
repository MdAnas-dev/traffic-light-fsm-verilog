`define TRUE  1'b1
`define FALSE 1'b0

module cat_tb;

    wire [1:0] MAIN_SIG;
    wire [1:0] CNTRY_SIG;
    reg  CAR_ON_CNTRY_RD;
    reg  CLOCK, CLEAR;

    // Instantiate DUT
    cat DUT (
        .hwy   (MAIN_SIG),
        .cntry (CNTRY_SIG),
        .X     (CAR_ON_CNTRY_RD),
        .clock (CLOCK),
        .clear (CLEAR)
    );

    // Signal monitor
    initial
        $monitor($time, " Main=%b Country=%b Car=%b",
                 MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

    // Clock: 10 ns period
    initial begin
        CLOCK = `FALSE;
        forever #5 CLOCK = ~CLOCK;
    end

    // Reset
    initial begin
        CLEAR = `TRUE;
        repeat(5) @(negedge CLOCK);
        CLEAR = `FALSE;
    end

    // Stimulus: three car-arrival events
    initial begin
        CAR_ON_CNTRY_RD = `FALSE;

        repeat(20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
        repeat(10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;

        repeat(20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
        repeat(10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;

        repeat(20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
        repeat(10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;

        repeat(10) @(negedge CLOCK);
        $stop;
    end

endmodule
