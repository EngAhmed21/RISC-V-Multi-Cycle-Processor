module RISC_tb ();
    reg clk, rstn;
    wire [31:0] test;

    TOP_MODULE uut (.clk(clk), .rstn(rstn), .test(test));

    localparam CLK_PERIOD = 2;
    always 
        #(CLK_PERIOD / 2)  clk = ~clk;

    initial begin
        clk = 1;    rstn = 0;

        $readmemh("Test_Program2.dat", uut.DATA_MEM.D_MEM, 256, 272);

        @(negedge clk)  rstn = 1;

        repeat (10000)  @(negedge clk);
        $stop;
    end
endmodule
