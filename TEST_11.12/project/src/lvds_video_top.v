//顶层模块集成各个子模块，集成了包含LVDS视频信号发送与接收模块，以及背光灯板驱动等主要模块
module lvds_video_top
(
    input          I_clk       ,  //50MHz      
    input          I_rst_n     ,
    output [3:0]   O_led       , 
    input          I_clkin_p   ,  //LVDS Input
    input          I_clkin_n   ,  //LVDS Input
    input  [3:0]   I_din_p     ,  //LVDS Input
    input  [3:0]   I_din_n     ,  //LVDS Input    
    output         O_clkout_p  ,
    output         O_clkout_n  ,
    output [3:0]   O_dout_p    ,
    output [3:0]   O_dout_n    ,
    //led
    output         LE          ,
    output         DCLK        , //12.5M
    output         SDI         ,
    output         GCLK        ,
    output         scan1       ,
    output         scan2       ,
    output         scan3       , 
    output         scan4       ,

    //连接IIC从器件ap3216c
    output               scl     ,       
    inout                sda            
);


//...
wire           clk       ;                   // 1M时钟“dri_clk”引出

//...
wire           i2c_exec  ;                   // iic使能
wire   [15:0]  iic_inner_reg_addr  ;         // i2c从器件内部寄存器地址
wire           i2c_done  ;                   // i2c操作结束标志
wire           read1_write0 ;                // i2c读写控制
wire   [ 7:0]  i2c_data_r;                   // i2c读出数据
wire   [ 7:0]  i2c_data_w;                   // i2c写入数据

//...
wire   [15:0]  als_data  ;                   // ALS的数据
wire   [ 9:0]  ps_data   ;                   // PS的数据

//I2C通信实例化
i2c_dri(

          //fpga
          .clk(I_clk)        ,      // 输入时钟(clk_freq)
          .rst_n(I_rst_n)      ,    // 复位信号
          
          //addr and data
          .slave_address(7'h1e),                   //从机地址
          .iic_inner_reg_addr(iic_inner_reg_addr), //从机内部寄存器地址，若为8bit形式，直接用低八位
          .i2c_w_data(i2c_data_w),                 //写数据端口
          .i2c_r_data(i2c_data_r),                 //读数据端口
          
          //select mode
          .type16_type8(1'b0),               //从机内部寄存器地址是否属于16bit形式(16-1/8-0)
          .read1_write0(read1_write0),       //读模式或写模式
          
          //i2c interface
          .i2c_exec(i2c_exec)   ,  // IIC使能【1】
          .i2c_done(i2c_done)   ,  // 一次操作完成的标志信号
          .scl(scl)        ,       // SCL输出
          .sda(sda)        ,       // SDA输出

          //user interface
          .dri_clk(clk)           // 低频时钟输出
     );
     
//光传感器实例化
ap3216c u_ap3216c(

    .clk         (clk   ),          
    .rst_n       (I_rst_n ),             

    //iic ctrl
    .read1_write0   (read1_write0 ),           
    .i2c_exec    (i2c_exec  ),           
    .iic_inner_reg_addr    (iic_inner_reg_addr  ),           
    .i2c_data_w  (i2c_data_w),           
    .i2c_data_r  (i2c_data_r),           
    .i2c_done    (i2c_done  ),              

    //data to dig_tube
    .als_data    (als_data  )             
         
);

//======================================================
reg  [31:0] run_cnt;
wire        running;

//--------------------------
wire [7:0]  r_R_0;  // Red,   8-bit data depth
wire [7:0]  r_G_0;  // Green, 8-bit data depth
wire [7:0]  r_B_0;  // Blue,  8-bit data depth
wire        r_Vsync_0;
wire        r_Hsync_0;
wire        r_DE_0   ;

wire 		rx_sclk;

//===================================================
//LED test
always @(posedge I_clk or negedge I_rst_n)//I_clk
begin
    if(!I_rst_n)
        run_cnt <= 32'd0;
    else if(run_cnt >= 32'd50_000_000)
        run_cnt <= 32'd0;
    else
        run_cnt <= run_cnt + 1'b1;
end

assign  running = (run_cnt < 32'd25_000_000) ? 1'b1 : 1'b0;

assign  O_led[0] = 1'b1;
assign  O_led[1] = 1'b1;
assign  O_led[2] = 1'b0;
assign  O_led[3] = running;

//==============================================================
//LVDS Reciver（接收来自HDMI传输的信号，将信号转换成LVDS信号）
LVDS_7to1_RX_Top LVDS_7to1_RX_Top_inst
(
    .I_rst_n        (I_rst_n    ),
    .I_clkin_p      (I_clkin_p  ),    // LVDS clock input pair
    .I_clkin_n      (I_clkin_n  ),    // LVDS clock input pair
    .I_din_p        (I_din_p    ),    // LVDS data input pair 0
    .I_din_n        (I_din_n    ),    // LVDS data input pair 0
    .O_pllphase     (           ),
    .O_pllphase_lock(           ),
    .O_clkpat_lock  (           ),
    .O_pix_clk      (rx_sclk    ),  
    .O_vs           (r_Vsync_0  ),
    .O_hs           (r_Hsync_0  ),
    .O_de           (r_DE_0     ),
    .O_data_r       (r_R_0      ),
    .O_data_g       (r_G_0      ),
    .O_data_b       (r_B_0      )

);

//===================================================================================
//LVDS TX（获得LVDS信号，将信号转换成HDMI视频信号发送到屏幕）
LVDS_7to1_TX_Top LVDS_7to1_TX_Top_inst
(
    .I_rst_n       (I_rst_n     ),
    .I_pix_clk     (rx_sclk     ), //x1                       
    .I_vs          (r_Vsync_0   ), 
    .I_hs          (r_Hsync_0   ),
    .I_de          (r_DE_0      ),
    .I_data_r      (r_R_0       ),
    .I_data_g      (r_G_0       ),
    .I_data_b      (r_B_0       ), 
    .O_clkout_p    (O_clkout_p  ), 
    .O_clkout_n    (O_clkout_n  ),
    .O_dout_p      (O_dout_p    ),    
    .O_dout_n      (O_dout_n    ) 
);

wire clk25M;
wire clk1M;
wire sdbpflag;
wire [9:0]wtaddr;
wire [6:0]cntlatch;
wire frame_flag;
wire latch_flag;
wire [95:0]datain;
wire [15:0]wtdina;
//PLL分频（将系统时钟分频输出为25M与1M）用于背光板360颗灯珠的时序配置
SPI7001_25M_1M_rPLL SPI7001_25M_1M_rPLL_inst(
         .clkout(clk25M), //output clkout
         .clkoutd(clk1M), //output clkoutd
         .clkin(I_clk) //input clkin
);
//ramflag_1是分区背光算法后控制灯板点亮的模块（通过信号sdbpflag、wtaddr、wtdina传入LED驱动芯片接口模块进行后续输出
//其中部署了RGB彩色信号转灰度算法和加权平均算法以实现分区背光控制的功能

ramflag_1 u1(
    .clk(clk25M),
    .rst_n(I_rst_n),
    .I_pix_clk(rx_sclk), 
    .I_de     (r_DE_0),
    .I_vs     (r_Vsync_0   ), 
    .I_hs     (r_Hsync_0   ),
    .r(r_R_0),               
    .g(r_G_0),               
    .b(r_B_0),  
    .als_kk      (als_data),
    .sdbpflag_wire(sdbpflag),//写入一帧起始信号
    .wtdina_wire(wtdina),//写入的灰度值
    .wtaddr_wire(wtaddr)//灯板上灯珠位置对应的地址
);

//以下两个模块用于管理SRAM的读写操作，和通过 SPI 接口发送给LED驱动芯片，实现灯珠的控制。
sram_top_gowin_top u2(
    .clka(clk25M),
    .clkb(clk1M),
    .sdbpflag(sdbpflag),
    .wtaddr(wtaddr),
    .wtdina(wtdina),
    .rst_n(I_rst_n),
    .latch_flag(latch_flag),
    .frame_flag(frame_flag),
    .datain(datain),
    .cntlatch(cntlatch)
);

SPI7001_gowin_top u3(
    .clock(clk25M),
    .clk_1M(clk1M),
    .rst_n(I_rst_n),
    .frame_f(frame_flag),
    .rgb_f(latch_flag),
    .rgb_data(datain),
    .cntlatch(cntlatch),
    .LE(LE),
    .DCLK(DCLK),
    .SDI(SDI),
    .GCLK(GCLK),
    .scan1(scan1),
    .scan2(scan2),
    .scan3(scan3),
    .scan4(scan4),
    .scan1_wire(scan1_wire)
);

endmodule