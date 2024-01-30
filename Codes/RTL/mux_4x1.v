module mux_4x1 #(parameter SIZE = 32) (
    input [SIZE-1:0] in1, in2, in3, in4,
    input [1:0] sel,
    output reg [SIZE-1:0] out
);
    always @(*) begin
        case (sel)
            2'b00:   out = in1;
            2'b01:   out = in2;
            2'b10:   out = in3;
            2'b11:   out = in4;
            default: out = 0;
        endcase
    end  
endmodule