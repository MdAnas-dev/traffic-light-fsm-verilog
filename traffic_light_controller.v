`define TRUE  1'b1
`define FALSE 1'b0
`define Y2RDELAY 3
`define R2GDELAY 2

module cat(
    output reg [1:0] hwy,
    output reg [1:0] cntry,
    input X,
    input clock,
    input clear
);
    parameter RED    = 2'd0;
    parameter YELLOW = 2'd1;
    parameter GREEN  = 2'd2;

    parameter s0 = 3'd0, // Highway Green, Country Red
              s1 = 3'd1, // Highway Yellow, Country Red
              s2 = 3'd2, // All Red (safety buffer)
              s3 = 3'd3, // Highway Red, Country Green
              s4 = 3'd4; // Highway Red, Country Yellow

    reg [2:0] state, next_state;
    reg [1:0] timer;

    // Sequential logic: state register and timer
    always @(posedge clock) begin
        if (clear) begin
            state <= s0;
            timer <= 0;
        end else begin
            state <= next_state;
            if (next_state != state) begin
                case(next_state)
                    s1: timer <= `Y2RDELAY;
                    s2: timer <= `R2GDELAY;
                    s4: timer <= `Y2RDELAY;
                    default: timer <= 0;
                endcase
            end else if (timer > 0) begin
                timer <= timer - 1;
            end
        end
    end

    // Combinational logic: next-state
    always @(*) begin
        next_state = state;
        case(state)
            s0: next_state = X ? s1 : s0;
            s1: next_state = (timer == 1) ? s2 : s1;
            s2: next_state = (timer == 1) ? s3 : s2;
            s3: next_state = X ? s3 : s4;
            s4: next_state = (timer == 1) ? s0 : s4;
            default: next_state = s0;
        endcase
    end

    // Combinational logic: output
    always @(*) begin
        hwy   = GREEN;
        cntry = RED;
        case(state)
            s0: ; // defaults
            s1: hwy = YELLOW;
            s2: hwy = RED;
            s3: begin hwy = RED; cntry = GREEN; end
            s4: begin hwy = RED; cntry = YELLOW; end
            default: begin hwy = RED; cntry = RED; end
        endcase
    end

endmodule
