// 默认空闲大于1个。
// 数据字节：8bit（默认）5、6、7、8
// 是否有校验：无（默认）
// 是否有停止位：无（默认）
// 波特率9600 bit/s  4800、9600、115200、
// 11 0 xxxx_xxxx x 1 循环 
// 看门狗
`timescale 1ns/100ps
`define SIM 0
module uart_tx (
input                 i_clkx16          ,
input                 i_rst             ,

input                 i_exist_oddcheck  ,//存在奇校验
input                 i_exist_evencheck ,//存在偶校验
input                 i_exist_stop      ,//存在1bit停止位
input       [3:0]     i_bitnum          ,//数据的个数5-8

input       [7:0]     i_data            ,
input                 i_data_valid      ,//脉冲

output                o_tx               //发送管脚
);
`ifndef SIM
parameter IDLE = 3'd0,START = 3'd1,TXDATA = 3'd2, CHECK = 3'd3,STOP = 3'd4;
reg [2:0] cur_sta,next_sta;
`else 
parameter IDLE = "IDLE",START = "START",TXDATA = "TXDATA", CHECK = "CHECK",STOP = "STOP";
reg [79:0] cur_sta,next_sta;
`endif
reg exist_oddcheck   ;
reg exist_evencheck  ;
reg exist_stop       ;
reg [3:0] bitnum     ;

wire data_valid      = i_data_valid         ;
reg [7:0] data;
reg [3:0] cnt;//每个bit 16个周期的计数器
reg [3:0] cnt_bit;//发送数据bit个数的计数器

reg  data_valid_1d;
wire data_valid_1p,IDLE2START;
wire START2TXDATA,TXDATA2CHECK,TXDATA2STOP,TXDATA2IDLE ;
wire CHECK2STOP,CHECK2IDLE,STOP2IDLE;
wire cnt_bit_inc;//脉冲
wire txdata_last;//TXDATA状态的最后一拍，下一拍就要跳转状态。
wire cnt_wait;//在IDLE状态下cnt不计数，减少功耗
always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) cur_sta  <= #1 3'b0; else cur_sta <= #1 next_sta;end

always@(*)  begin
    case(cur_sta)
    IDLE:  next_sta = IDLE2START ? START:IDLE;
    START: next_sta = START2TXDATA?TXDATA:START;
    TXDATA: //不用case似乎更加清晰一点
        if(TXDATA2CHECK)     next_sta = CHECK;
        else if(TXDATA2STOP) next_sta = STOP;
        else if(TXDATA2IDLE) next_sta = IDLE;
        else next_sta = TXDATA;
    CHECK: next_sta = CHECK2STOP?STOP:CHECK2IDLE?IDLE:CHECK;
    STOP:  next_sta  = STOP2IDLE?IDLE:STOP;
    default:next_sta = IDLE;
    endcase
end
assign  IDLE2START    = (cur_sta== IDLE ) & data_valid_1p;//IDLE状态有上升沿就跳转到START。
assign  START2TXDATA  = (cur_sta== START) & (cnt==4'hF);//保持16个周期就跳转。
assign  CHECK2STOP    = (cur_sta== CHECK) & (cnt==4'hF)&(exist_stop);//保持16个周期就跳转。
assign  CHECK2IDLE    = (cur_sta== CHECK) & (cnt==4'hF)&(~exist_stop);//保持16个周期就跳转。
assign  STOP2IDLE     = (cur_sta== STOP ) & (cnt==4'hF);//保持16个周期就跳转。

assign  TXDATA2CHECK  = txdata_last &(exist_oddcheck|exist_evencheck);
assign  TXDATA2STOP   = txdata_last &(~exist_oddcheck)&(~exist_evencheck)&exist_stop;
assign  TXDATA2IDLE   = txdata_last &(~exist_oddcheck)&(~exist_evencheck)&(~exist_stop);

assign  txdata_last  = (cur_sta== TXDATA) & (cnt==4'hF)& (cnt_bit==bitnum);
assign  cnt_bit_inc  = (cur_sta== TXDATA) & (cnt==4'hF);
assign  cnt_wait     = (cur_sta== IDLE) ;
always@(posedge i_clkx16 or posedge i_rst)  begin
    if(i_rst) cnt_bit  <= #1 4'b0; 
    else if(START2TXDATA) cnt_bit <= #1 4'b1;
    else if(cnt_bit_inc)  cnt_bit <= #1 cnt_bit + 1'b1;
end
always@(posedge i_clkx16 or posedge i_rst)  begin
    if(i_rst) cnt  <= #1 4'b0; 
    else if(IDLE2START) cnt <= #1 4'b0;
    else if(cnt_wait) cnt <= #1 4'b0;
    else cnt <= #1 cnt + 1'b1;//隐含了计数到4'hF 自动翻转这一条件
end






always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) data_valid_1d  <= #1 1'b0; else data_valid_1d <= #1 data_valid;end
assign data_valid_1p = data_valid & (~data_valid_1d);
always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) data   <= #1 8'b0; else if(data_valid_1p) data <= #1 i_data;end
         
always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) exist_oddcheck    <= #1 1'b0; else if(data_valid_1p) exist_oddcheck  <= #1 i_exist_oddcheck ;end
always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) exist_evencheck   <= #1 1'b0; else if(data_valid_1p) exist_evencheck <= #1 i_exist_evencheck;end
always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) exist_stop        <= #1 1'b0; else if(data_valid_1p) exist_stop      <= #1 i_exist_stop     ;end
always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) bitnum            <= #1 4'b0; else if(data_valid_1p) bitnum          <= #1 i_bitnum;         end



endmodule


