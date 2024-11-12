/*
    数字环境光传感器:ALS
    距离传感器:PS
    红外LED:IR
    
    [内部寄存器地址] (有效位) 含义
    [00H] (2:0) 写入111代表启用ALS+PS+IR的单次模式
    [0AH] (7)   读出0代表IR&PS的数据有效 1无效
    [0AH] (1:0) 读出IR有效数据位[1:0]
    [0BH] (7:0) 读出IR有效数据位[7:0]
    [0CH] (7:0) 读出ALS有效数据位[7:0]
    [0DH] (7:0) 读出ALS有效数据位[15:8]
    [0EH] (7)   读出0代表物体远离 读出1代表物体靠近
    [0EH] (6)   读出0代表PS&IR有效 1代表无效
    [0EH] (3:0) 读出PS有效数据位[3:0]
    [0FH] (7)   读出0代表物体远离 读出1代表物体靠近
    [0FH] (6)   读出0代表PS&IR有效 1代表无效
    [0FH] (5:0) 读出PS有效数据位[5:0]
    。
    本程式将PS数据与ALS数据读出，
    PS为10位数据：PS数据的[3:0]储存在0E地址的[3:0]，PS数据的[9:4]储存在0F地址的[5:0]
    ALS为16位数据：ALS数据的[7:0]储存在0C地址的[7:0]，ALS数据的[15:8]储存在0D地址的[7:0]
    
    
    操作过程：初始化(0~2) -> 读PS(3~8) -> 读ALS(9~14) -> 读PS(3~8)...
*/
module ap3216c(
    
    input                 clk        ,    
    input                 rst_n      ,    

    
    output   reg          read1_write0  ,           // IIC读写控制
    output   reg          i2c_exec   ,              // IIC使能
    output   reg  [15:0]  iic_inner_reg_addr   ,    // AP3216C内部寄存器地址
    output   reg  [ 7:0]  i2c_data_w ,              // I2C写8bit数据
    input         [ 7:0]  i2c_data_r ,              // I2C读8bit数据
    input                 i2c_done   ,              // IIC一次操作完成标志

    
    output   reg  [15:0]  als_data   ,    // ALS的数据
    output   reg  [ 9:0]  ps_data         // PS的数据
);

//parameter define
parameter      TIME_PS   = 14'd12_500  ;  // PS转换时间为12.5ms(clk = 1MHz)
parameter      TIME_ALS  = 17'd100_000 ;  // ALS转换时间为100ms(clk = 1MHz)
parameter      TIME_REST =  8'd2       ;  // 停止后重新开始的时间间隔控制

//reg define
reg   [ 3:0]   flow_cnt   ;               // 状态流控制
reg   [18:0]   wait_cnt   ;               // 计数等待
reg   [15:0]   als_data_t ;               // ALS的临时数据
reg            als_done   ;               // 环境光照强度值采集完成信号
reg   [ 9:0]   ps_data_t  ;               // PS的临时数据





//配置AP3216C并读取数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        i2c_exec   <=  1'b0;
        iic_inner_reg_addr   <=  8'd0;
        read1_write0  <=  1'b0;
        i2c_data_w <=  8'h0;
        
        flow_cnt   <=  4'd0;
        wait_cnt   <= 18'd0;
        
        ps_data    <= 10'd0;
        ps_data_t  <= 10'd0;
        als_data_t <= 16'd0;
        als_done   <=  1'b0;
        
        
        
    end
    else begin
        i2c_exec <= 1'b0;
        case(flow_cnt)
        
            //【0:等待0.01ms】 ->1
            4'd0: begin
                if(wait_cnt == 18'd100) begin 
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'b1;
                end
                else
                    wait_cnt <= wait_cnt +1'b1;
            end
            
            //【1、向00H写入03H，启用ALS+PS+IR的单次模式】->2
            4'd1: begin
                i2c_exec   <= 1'b1 ;
                read1_write0  <= 1'b0 ;
                iic_inner_reg_addr   <= 8'h00;               
                i2c_data_w <= 8'h03;               
                flow_cnt   <= flow_cnt + 1'b1;
            end
            
            //【2、等待IIC发送完成】->3
            4'd2: begin
                if(i2c_done)
                    flow_cnt <= flow_cnt + 1'b1;
            end
            
            //【3、等待12.5ms，因即将读取PS，手册要求读取PS前准备12.5ms】->4
            4'd3: begin
                if(wait_cnt  == TIME_PS) begin
                    
                    als_done         <= 1'b0; //清除als_done标志
                    
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'd1;
                end
                else
                    wait_cnt <= wait_cnt + 1'b1;
            end
            
            /*【4、对地址0EH做一次读操作】 ->5
                [0EH] (3:0) 读出PS有效数据位[3:0]
            */
            4'd4: begin
                i2c_exec <= 1'b1;
                read1_write0<= 1'b1;
                iic_inner_reg_addr <= 8'h0E;
                flow_cnt <= flow_cnt + 1'b1;
            end
            
            //【5、等待IIC的读操作完成，并处理数据】->6
            4'd5: begin
                if(i2c_done) begin
                    flow_cnt         <= flow_cnt + 1'b1;
                    ps_data_t[3:0]   <= i2c_data_r[3:0];;
                end
            end
            
            //【6、等待一段时间以进行下一次读写】 ->7
            4'd6: begin
                if(wait_cnt == TIME_REST) begin//TIME_REST
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'b1;
                end
                else
                    wait_cnt <= wait_cnt +1'b1;
            end
            
            /*【7、对地址0FH做一次读操作】 ->8
                [0FH] (5:0) 读出PS有效数据位[3:0]
            */
            4'd7: begin
                i2c_exec <= 1'b1;
                read1_write0<= 1'b1;
                iic_inner_reg_addr <= 8'h0F;
                flow_cnt <= flow_cnt + 1'b1;
            end
            
            //【8、等待IIC的读操作完成，并处理数据】->9
            4'd8: begin
                if(i2c_done) begin
                    flow_cnt        <= flow_cnt + 1'b1;
                    ps_data_t[9:4] <= i2c_data_r[5:0];
                end
            end
            //【9、等待100ms，因即将读取ALS，手册要求读取ALS前准备100ms,同时将接收到的PS整理】->10
            4'd9: begin
                if(wait_cnt  ==  TIME_ALS) begin
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'd1;
                     ps_data  <= ps_data_t;
                end
                else
                    wait_cnt <= wait_cnt + 1'b1;
            end
            
            /*【10、对地址0CH做一次读操作】 ->11
                [0CH] (7:0) 读出ALS有效数据位[7:0]
            */
            4'd10: begin
                i2c_exec <= 1'b1;
                read1_write0<= 1'b1;
                iic_inner_reg_addr <= 8'h0C;
                flow_cnt <= flow_cnt + 1'b1;
            end
            
            //【11、等待IIC的读操作完成，并处理数据】->12
            4'd11: begin
                if(i2c_done) begin
                    als_data_t[7:0] <= i2c_data_r;
                    flow_cnt        <= flow_cnt + 1'b1;
                end
            end
            
            //【12、等待一段时间以进行下一次读写】 ->13
            4'd12: begin
                if(wait_cnt == TIME_REST) begin
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'b1;
                end
                else
                    wait_cnt <= wait_cnt +1'b1;
            end
            
            /*【13、对地址0DH做一次读操作】 ->14
                [0DH] (7:0) 读出ALS有效数据位[15:8]
            */
            4'd13: begin
                i2c_exec <= 1'b1;
                read1_write0<= 1'b1;
                iic_inner_reg_addr <= 8'h0D;
                flow_cnt <= flow_cnt + 1'b1;
            end
            
            //【14、等待IIC的读操作完成，并处理数据，输出als_done标志，提供给用于（单位转换）的always块使用】 ->3
            4'd14: begin
                if(i2c_done) begin
                    als_done         <= 1'b1;
                    als_data_t[15:8] <= i2c_data_r;
                    flow_cnt         <= 4'd3;             
                end 
            end
        endcase
    end 
end

//当采集的环境光转换成光照强度(单位:lux)
always @ (*) begin
    if(als_done)
	 als_data = als_data_t * 6'd35 / 7'd100;
end

endmodule
