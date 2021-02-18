// `define STA_WIDTH  127
`timescale 1ns/100ps

module addr_trans (
input                 i_clk             ,
input                 i_rst             ,
input       [7:0]     i_data            ,//
input                 i_sop             ,//
input                 i_eop             ,//
output      [7:0]     sum
);
reg [7:0] poly = 8'h07;
reg [7:0]  sum;
reg [14:0] data;//≤π¡„
reg [15:0] cnt = 0;
wire shift_stop =  cnt == 16'd8 ;
reg  shift_stop_1d;
always@(posedge i_clk or posedge i_rst) shift_stop_1d <= shift_stop;

always@(posedge i_clk or posedge i_rst)  begin
    if(i_rst) cnt  <= #1 16'b0; 
    else if(i_sop) cnt <= #1 16'b0;//∏≥≥ı÷µ
    else if(shift_stop) cnt <= #1 cnt;//Õ£÷π
    else cnt <= #1 cnt +1'b1;
end

always@(posedge i_clk or posedge i_rst)  begin
    if(i_rst) data  <= #1 15'b0; 
    else if(i_sop) data <= #1 {i_data,7'b0};//∏≥≥ı÷µ
    else if(shift_stop) data <= #1 15'b0;//Õ£÷π
    else data <= #1 {sum[7:0],data[5:0],1'b0};
end
always@(*)  begin
    sum <= #1 data[14:7] ^ poly;
end

// i_sop
// cnt <= #1 16'b0    data  sum













