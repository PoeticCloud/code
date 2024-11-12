 //==============================================================================
//以下是灯珠的控制相关算法，包括灯珠驱动寄存器配置，RGB彩色信息转灰度算法，屏幕像素映射灯珠算法
 module ramflag_1(
    input clk,   // 25Mclk
    input rst_n,
    output  sdbpflag_wire,
    output  [15:0] wtdina_wire,
    output  [9:0] wtaddr_wire,
    input        I_vs          ,
    input        I_hs          ,
    input        I_de          ,
    input    I_pix_clk,//x1
    input [7:0] r,
    input [7:0] g,
    input [7:0] b,
    input [15:0]  als_kk
);

    reg  flagkk;
    reg [4:0] cx;
    reg [4:0] cy;
    reg [11:0] cntx;
    reg [11:0] cnty;
    reg [7:0]  graykk;
    reg [8:0]  grayout[24:0][15:0];
reg [11:0] cnt;  //用于延迟1250个dclk 等待配置寄存器时间。
reg [30:0] cnt1; //用于周期性发送sdbpflag信号，可以设置cnt1长度修改发送sdbpflag信号时间间隔
reg [9:0] cnt2;  // 用于每帧暂存时间
reg [13:0]  cnt3;  // 每一轮addr自加+1 当addr=cnt3时点亮对应位置的灯珠
reg flag= 'd0; //标志配置寄存器结束，可以发送sdbp数据了;
reg sdbpflag;
reg [15:0]wtdina;
reg [9:0]wtaddr;
assign sdbpflag_wire = sdbpflag;
assign wtdina_wire = wtdina;
assign wtaddr_wire = wtaddr;
//等待cnt记满，以完成寄存器配置
always @(posedge clk or negedge rst_n)   
 begin
    if(!rst_n)
        begin
            flag <= 0;
            cnt <= 0;
        end
    else if(cnt < 2500)
    begin
        flag <= 0;
        cnt <= cnt + 1;
    end
    else if(cnt == 2500)
    begin
        flag <= 1;
    end
end
//cnt1用来计数sdbpflag的周期
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt1 <= 0;
    else if(cnt1 >= 35_000)begin
        cnt1 <= 0;
    end
    else
        cnt1 <= cnt1 + 1;
end
//cnt2用来计数流水灯状态下每颗灯点亮的持续时间
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
            cnt2 <= 0;
        end
    else if(cnt1 == 0 && flag)
            begin 
//  cnt2是一颗灯保持亮的速率
                if(cnt2 == 20)
                    begin
                        cnt2 <= 0;
                    end
                else 
                    begin
                        cnt2 <= cnt2 + 1;
                    end
            end
end
//cnt3用来计数点亮灯珠的位置
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        cnt3 <= 0;
    end
    else if(cnt1 == 1 && cnt2 == 0 && flag)begin
        if(cnt3 >= 359)begin
            cnt3 <= 0;
        end
        else begin
            cnt3 <= cnt3 + 1;
        end
    end
end
//===============================================================================================
//以下为控制输出信号,拉高sdpbflag,并确保sdpb使能足够长，确保时钟能够判断sdbp使能开启）；此时进入灰度写入阶段

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sdbpflag <= 0;
    else if(cnt1 == 1 && flag)begin
        sdbpflag <= 1;
    end
    else if(cnt1 == 30 && flag)begin
        sdbpflag <= 0;  
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        wtaddr <= 0;
    end
    else if(cnt1 == 3) begin
        wtaddr <= 0;
    end 
    else if (cnt1 > 4 && cnt1<=4+360  && flag)begin//cnt1:5-364 wtaddr:1-360
        wtaddr <= wtaddr + 1;
    end
    else if(cnt1 > 4+360) begin
        wtaddr <= 0; 
    end
end
//===============================================================================================
//以下always语句将1280*800像素按53*53像素分成360个区域，将每个区域分别映射到背光板360颗灯珠上
always @(posedge I_pix_clk or negedge rst_n )   
 begin
    if(!rst_n)
        begin
            cntx <= 0;
            cnty <= 0;
            cx<=0;
            cy<=0;
        end
else
begin
    if(I_vs==0&&I_hs==0&&I_de==1)
        begin
            cntx<=cntx+1;
            if(cntx==1279)
            begin
                cnty<=cnty+1;
                cntx<=0;
            end
            graykk <= (r * 299 + g * 587 + b * 114) / 1000;
         cx=(cntx/53);
           if(cx>=23)
           begin
             cx =23;
           end
        cy=(cnty/53);
            if(cy>=14)
            begin
                cy =14;
            end
          grayout[cx][cy] <= ((graykk+grayout[cx][cy])/2); 
        end
    else if (I_vs==1&&I_hs==1&&I_de==0)
    begin 
            cntx <= 0;
            cnty <= 0;
            cx<=0;
            cy<=0;

    end
end
end

//流水灯
//always@(posedge clk or negedge rst_n)
//  begin
//      if(!rst_n)
//          wtdina <= 0;
//      else if(wtaddr==cnt3&&flag)
//              wtdina <= 16'hfff;
//      else
//          wtdina <= 0;
//  end
//更换显示模式
 always@(posedge clk or negedge rst_n)
 begin
     if(!rst_n)begin
         wtdina <= 0;
                  end
     else if(cnt1>4&&cnt1<=364&&flag)
                                                begin
//=============================================================
//左侧加载全亮背光，右侧加载背光算法
//        if(((cnt1-5)%24)<=11)
//            begin   
//                    wtdina <= 16'hFFFF ; 
//            end
//              else
//                     wtdina <=grayout[(cnt1-5)%24][((cnt1-5)/24)]*65536/256;
//=============================================================
//加载加权的背光算法
        if(grayout[(cnt1-5)%24][((cnt1-5)/24)]<30)begin
            wtdina <=(grayout[(cnt1-5)%24][((cnt1-5)/24)]*7/10)*65536/256;
        end
        else if(grayout[(cnt1-5)%24][((cnt1-5)/24)]>=30 && grayout[(cnt1-5)%24][((cnt1-5)/24)]<70)begin
            wtdina <=(grayout[(cnt1-5)%24][((cnt1-5)/24)]*8/10)*65536/256;
        end
        else if(grayout[(cnt1-5)%24][((cnt1-5)/24)]>=70 && grayout[(cnt1-5)%24][((cnt1-5)/24)]<110)begin
            wtdina <=(grayout[(cnt1-5)%24][((cnt1-5)/24)]*85/100)*65536/256;
        end
        else if(grayout[(cnt1-5)%24][((cnt1-5)/24)]>=110 && grayout[(cnt1-5)%24][((cnt1-5)/24)]<150)begin
            wtdina <=(grayout[(cnt1-5)%24][((cnt1-5)/24)]*95/100)*65536/256;
        end
        else if(grayout[(cnt1-5)%24][((cnt1-5)/24)]>=150 && grayout[(cnt1-5)%24][((cnt1-5)/24)]<210)begin
            wtdina <=(grayout[(cnt1-5)%24][((cnt1-5)/24)]*11/10)*65536/256;
        end
            if(grayout[(cnt1-5)%24][((cnt1-5)/24)]>=210)begin
            wtdina <=16'hFFFF;
            end

//=============================================================
//环境光调节屏幕亮度
                if((grayout[(cnt1-5)%24][((cnt1-5)/24)]*65536/256*(als_kk+20)/655)>16'hFFFF)
                                wtdina<=16'hFFFF;
                  else 
                                wtdina <=(grayout[(cnt1-5)%24][((cnt1-5)/24)]*65536/256*(als_kk+20)/655);
//=============================================================
                                                 end
     else
        wtdina <= 16'hFFFF ; 
 end
 //1/3全亮度 1/3一半亮度 1/3暗 
// always@(posedge clk or negedge rst_n)begin 
//     if(!rst_n)begin
//         wtdina <= 0;    
//     end 
//     else if(wtaddr%24==0 || (wtaddr-1)%24==0 || (wtaddr-2)%24==0 || (wtaddr-3)%24==0 || (wtaddr-4)%24==0 || (wtaddr-5)%24==0 ||(wtaddr-6)%24==0 || (wtaddr-7)%24==0)
//         wtdina <= 16'hffff;
//         else if((wtaddr-8)%24==0 || (wtaddr-9)%24==0 || (wtaddr-10)%24==0 || (wtaddr-11)%24==0||(wtaddr-12)%24==0 || (wtaddr-13)%24==0 || (wtaddr-14)%24==0 || (wtaddr-15)%24==0)
//             wtdina <= 16'h0100;
//     else
//     wtdina <= 0;
// end
//亮固定某一个灯珠 
// always@(posedge clk or negedge rst_n)
//begin 
// if(!rst_n)begin
//         wtdina <= 0;
//     end 
// else if(wtaddr == cnt1-3)begin//wtaddr == x代表第x+1颗灯
//          wtdina <=gray[cnt1-3]*65536/256;
//     end 
// else begin
//         wtdina <= 0;
//     end
// end 


endmodule