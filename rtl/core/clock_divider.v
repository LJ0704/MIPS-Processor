module clock_divider #(parameter DIV = 25_000_000)(
    input  wire clk_in,
    input  wire reset,
    output reg  clk_out
);
    reg [24:0] count;

    always @(posedge clk_in) begin
        if (reset) begin
            count   <= 0;
            clk_out <= 0;
        end else if (count == DIV - 1) begin
            count   <= 0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1;
        end
    end
endmodule