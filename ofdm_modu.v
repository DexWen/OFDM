`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:18 09/23/2007 
// Design Name: 
// Module Name:    ofdm_modu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ofdm_modem(clk, reset, x_send, x_rec, y_out, , mdm, y_index);
input clk;
input reset;
//������32���أ���16�������鲿����16������ʵ��
input [31:0] x_send;
input [31:0] x_rec;
output [31:0] y_out;
output [7:0] y_index; //������ݵ��±�
output mdm; //��־����ǵ����źŻ��ǽ���ź�,
//1��ʾ�����źţ�0��ʾ����ź�

wire inv_we = 1;
wire [31:0] xn;
wire [49:0] xk;

reg [7:0] cnt;
reg  flag;
wire fwd_inv;

//�������ơ���������Ŀ����ź�
always @(posedge clk) begin
   if(!reset) begin
	   cnt <= 0;
		flag <= 0;
	end
	   cnt <= cnt + 1;
		if(cnt == 0) 
		   flag <= !flag;
		else
		   flag <= flag;
end

assign fwd_inv = reset ? flag : 0;
//�ڱ�־Ϊ1ʱ��FFT�����OFDM�źŵĵ���
assign xn[15:0] = flag ? x_send[15:0] : x_rec[15:0];
assign xn[31:16] = flag ? x_send[31:16] : x_rec[31:16];
//���ڼ���FFT��Ҫ�������ݺ���ɵ�����������N������ڣ�
//����������ͺ������������෴��
assign mdm = !flag;
assign y_out[15:0] = xk[24:9];
assign y_out[31:16] = xk[49:34];

//����IPcore
ofdm_fft ofdm_fft(
  .fwd_inv_we(inv_we),.start(reset), .fwd_inv(fwd_inv), 
  .clk(clk), .xn_re(xn[15:0]), .xn_im(xn[31:16]),
  .xk_re(xk[24:0]), .xk_im(xk[49:25]), .xk_index(y_index));

endmodule
