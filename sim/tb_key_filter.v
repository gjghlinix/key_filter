module tb_key_filter();

//参数定义，
parameter 	CNT_1ms  = 20'd19 ,
			CNT_11ms = 20'd69 ,
			CNT_41ms = 20'd149,
			CNT_51ms = 20'd199,
			CNT_60ms = 20'd249;
				
	reg  sys_clock ;
	reg  sys_rst_n ;
	reg  key_in ;
	reg	[21:0]	tb_cnt;
	wire   key_flag;	

initial begin
	sys_clock  = 1'b1;
	sys_rst_n <= 1'b0;
	key_in    <= 1'b0;
	#20
	sys_rst_n <= 1'b1;
end
always #10 sys_clock =~ sys_clock;

//按键抖动过程计数器  tb_cnt
always@(posedge sys_clock or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		tb_cnt <= 22'b0;
	else if(tb_cnt == CNT_60ms)
		tb_cnt <= 22'b0;
	else
		tb_cnt <= tb_cnt + 1'b1;
		
//key_in 按键输入情况（按下为低，未按下为高）
always@(posedge sys_clock or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		key_in <= 1'b1;
	else if(tb_cnt >= CNT_1ms && tb_cnt <= CNT_11ms || 
		tb_cnt >= CNT_41ms && tb_cnt <= CNT_51ms)
		key_in <= {$random} % 2;
	else if(tb_cnt > CNT_11ms && tb_cnt < CNT_41ms)
		key_in <= 1'b0;
	else
		key_in <= 1'b1;



key_filter
#(
	.CNT_MAX(20'd24)
	//CNT_MAX要小于11~41ms
)
key_filter_inst
(
	.sys_clock(sys_clock),
	.sys_rst_n(sys_rst_n),
	.key_in   (key_in),

	.key_flag (key_flag)
);	
endmodule