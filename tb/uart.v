// `define STA_WIDTH  127
`timescale 1ns/100ps
//自环//外环//定时发送
module uart ();

reg clk = 0,clkx16 = 0;
always clk = #80 ~clk;
always clkx16 = #5 ~clkx16;

reg rst = 1;
initial begin rst = 1;  #60;  rst = 0; end

reg exist_oddcheck  =1'b1;
reg exist_evencheck =1'b0;
reg exist_stop      =1'b1;     
reg [3:0] bitnum    =4'd8;         

reg [7:0] txdata = 8'd0;
reg data_valid   = 1'b0;
initial begin
    txdata       = 8'd0;
    data_valid   = 1'b0;
    #200;@(posedge clkx16);#1;
    txdata       = 8'h55;
    data_valid   = 1'b1;
    @(posedge clkx16);#1;
    txdata       = 8'd0;
    data_valid   = 1'b0;
end

wire tx;
uart_tx u0_tx(
.i_clkx16          (clkx16                 ),//input                 i_clkx16          ,
.i_rst             (rst                    ),//input                 i_rst             ,

.i_exist_oddcheck  (exist_oddcheck         ),//input                 i_exist_oddcheck  ,//存在奇校验
.i_exist_evencheck (exist_evencheck        ),//input                 i_exist_evencheck ,//存在偶校验
.i_exist_stop      (exist_stop             ),//input                 i_exist_stop      ,//存在1bit停止位
.i_bitnum          (bitnum                 ),//input       [3:0]     i_bitnum          ,//数据的个数5-8

.i_data            (txdata                 ),//input       [7:0]     i_data            ,
.i_data_valid      (data_valid             ),//input                 i_data_valid      ,//脉冲

.o_tx              (tx                     )//output                o_tx               //发送管脚
);





endmodule









