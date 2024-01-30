module D_FF #(parameter SIZE = 32) (
    input clk, rstn, en,
    input [SIZE-1:0] D,
    output reg [SIZE-1:0] Q
);
    always @(posedge clk, negedge rstn) begin
        if (!rstn)
            Q <= 0;
        else if (en)
            Q <= D;
    end
endmodule