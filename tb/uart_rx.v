// Ĭ�Ͽ��д���1����
// �����ֽڣ�8bit��Ĭ�ϣ�5��6��7��8
// �Ƿ���У�飺�ޣ�Ĭ�ϣ�
// �Ƿ���ֹͣλ���ޣ�Ĭ�ϣ�
// ������9600 bit/s  4800��9600��115200��
// 11 0 xxxx_xxxx x 1 ѭ�� 
// ���Ź�
`timescale 1ns/100ps

module uart_rx (
input                 i_clkx16          ,
input                 i_rst             ,
input                 i_rx              ,//���չܽ�
input                 i_exist_oddcheck  ,//������У��
input                 i_exist_evencheck ,//����żУ��
input                 i_exist_stop      ,//����1bitֹͣλ
input       [3:0]     i_bitnum          ,//���ݵĸ���5-8

output      [7:0]     o_data            ,
output                o_data_valid
);

parameter IDLE = 3'd0,START = 3'd1,RDATA = 3'd2, CHECK = 3'd3,STOP = 3'd4;

wire rx              = i_rx                 ;
wire exist_oddcheck  = i_exist_oddcheck     ;
wire exist_evencheck = i_exist_evencheck    ;
wire exist_stop      = i_exist_stop         ;
wire bitnum          = i_bitnum             ;
reg [2:0] cur_sta,next_sta;
reg rx_1d;
wire rx_n1p,IDLE2START;

always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) cur_sta  <= #1 3'b0; else cur_sta <= #1 next_sta;end

always@(*)  begin
    case(cur_sta)
    IDLE:  next_sta = IDLE2START ? START:IDLE;
    START: next_sta = next_sta;
    RDATA: next_sta = next_sta;
    CHECK: next_sta = next_sta;
    STOP: next_sta = next_sta;
    default:next_sta = next_sta;
    endcase
end


assign  IDLE2START  = (cur_sta== IDLE) & rx_n1p;//IDLE״̬���½��ؾ���ת��START��

// always@(posedge i_clkx16 or posedge i_rst)  begin
    // if(i_rst) data  <= #1 15'b0; 
    // else if(i_sop) data <= #1 {i_data,7'b0};//����ֵ
    // else if(shift_stop) data <= #1 15'b0;//ֹͣ
    // else data <= #1 {sum[7:0],data[5:0],1'b0};
// end






always@(posedge i_clkx16 or posedge i_rst)  begin if(i_rst) rx_1d  <= #1 1'b0; else rx_1d <= #1 rx;end
assign rx_n1p = rx_1d & (~rx);

endmodule


