module gw_gao(
    r_DE_0,
    \r_R_0[7] ,
    \r_R_0[6] ,
    \r_R_0[5] ,
    \r_R_0[4] ,
    \r_R_0[3] ,
    \r_R_0[2] ,
    \r_R_0[1] ,
    \r_R_0[0] ,
    \r_G_0[7] ,
    \r_G_0[6] ,
    \r_G_0[5] ,
    \r_G_0[4] ,
    \r_G_0[3] ,
    \r_G_0[2] ,
    \r_G_0[1] ,
    \r_G_0[0] ,
    \r_B_0[7] ,
    \r_B_0[6] ,
    \r_B_0[5] ,
    \r_B_0[4] ,
    \r_B_0[3] ,
    \r_B_0[2] ,
    \r_B_0[1] ,
    \r_B_0[0] ,
    \u1/cntx[11] ,
    \u1/cntx[10] ,
    \u1/cntx[9] ,
    \u1/cntx[8] ,
    \u1/cntx[7] ,
    \u1/cntx[6] ,
    \u1/cntx[5] ,
    \u1/cntx[4] ,
    \u1/cntx[3] ,
    \u1/cntx[2] ,
    \u1/cntx[1] ,
    \u1/cntx[0] ,
    \u1/cnty[11] ,
    \u1/cnty[10] ,
    \u1/cnty[9] ,
    \u1/cnty[8] ,
    \u1/cnty[7] ,
    \u1/cnty[6] ,
    \u1/cnty[5] ,
    \u1/cnty[4] ,
    \u1/cnty[3] ,
    \u1/cnty[2] ,
    \u1/cnty[1] ,
    \u1/cnty[0] ,
    r_Vsync_0,
    r_Hsync_0,
    \u1/als_kk[15] ,
    \u1/als_kk[14] ,
    \u1/als_kk[13] ,
    \u1/als_kk[12] ,
    \u1/als_kk[11] ,
    \u1/als_kk[10] ,
    \u1/als_kk[9] ,
    \u1/als_kk[8] ,
    \u1/als_kk[7] ,
    \u1/als_kk[6] ,
    \u1/als_kk[5] ,
    \u1/als_kk[4] ,
    \u1/als_kk[3] ,
    \u1/als_kk[2] ,
    \u1/als_kk[1] ,
    \u1/als_kk[0] ,
    \u_ap3216c/clk ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input r_DE_0;
input \r_R_0[7] ;
input \r_R_0[6] ;
input \r_R_0[5] ;
input \r_R_0[4] ;
input \r_R_0[3] ;
input \r_R_0[2] ;
input \r_R_0[1] ;
input \r_R_0[0] ;
input \r_G_0[7] ;
input \r_G_0[6] ;
input \r_G_0[5] ;
input \r_G_0[4] ;
input \r_G_0[3] ;
input \r_G_0[2] ;
input \r_G_0[1] ;
input \r_G_0[0] ;
input \r_B_0[7] ;
input \r_B_0[6] ;
input \r_B_0[5] ;
input \r_B_0[4] ;
input \r_B_0[3] ;
input \r_B_0[2] ;
input \r_B_0[1] ;
input \r_B_0[0] ;
input \u1/cntx[11] ;
input \u1/cntx[10] ;
input \u1/cntx[9] ;
input \u1/cntx[8] ;
input \u1/cntx[7] ;
input \u1/cntx[6] ;
input \u1/cntx[5] ;
input \u1/cntx[4] ;
input \u1/cntx[3] ;
input \u1/cntx[2] ;
input \u1/cntx[1] ;
input \u1/cntx[0] ;
input \u1/cnty[11] ;
input \u1/cnty[10] ;
input \u1/cnty[9] ;
input \u1/cnty[8] ;
input \u1/cnty[7] ;
input \u1/cnty[6] ;
input \u1/cnty[5] ;
input \u1/cnty[4] ;
input \u1/cnty[3] ;
input \u1/cnty[2] ;
input \u1/cnty[1] ;
input \u1/cnty[0] ;
input r_Vsync_0;
input r_Hsync_0;
input \u1/als_kk[15] ;
input \u1/als_kk[14] ;
input \u1/als_kk[13] ;
input \u1/als_kk[12] ;
input \u1/als_kk[11] ;
input \u1/als_kk[10] ;
input \u1/als_kk[9] ;
input \u1/als_kk[8] ;
input \u1/als_kk[7] ;
input \u1/als_kk[6] ;
input \u1/als_kk[5] ;
input \u1/als_kk[4] ;
input \u1/als_kk[3] ;
input \u1/als_kk[2] ;
input \u1/als_kk[1] ;
input \u1/als_kk[0] ;
input \u_ap3216c/clk ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire r_DE_0;
wire \r_R_0[7] ;
wire \r_R_0[6] ;
wire \r_R_0[5] ;
wire \r_R_0[4] ;
wire \r_R_0[3] ;
wire \r_R_0[2] ;
wire \r_R_0[1] ;
wire \r_R_0[0] ;
wire \r_G_0[7] ;
wire \r_G_0[6] ;
wire \r_G_0[5] ;
wire \r_G_0[4] ;
wire \r_G_0[3] ;
wire \r_G_0[2] ;
wire \r_G_0[1] ;
wire \r_G_0[0] ;
wire \r_B_0[7] ;
wire \r_B_0[6] ;
wire \r_B_0[5] ;
wire \r_B_0[4] ;
wire \r_B_0[3] ;
wire \r_B_0[2] ;
wire \r_B_0[1] ;
wire \r_B_0[0] ;
wire \u1/cntx[11] ;
wire \u1/cntx[10] ;
wire \u1/cntx[9] ;
wire \u1/cntx[8] ;
wire \u1/cntx[7] ;
wire \u1/cntx[6] ;
wire \u1/cntx[5] ;
wire \u1/cntx[4] ;
wire \u1/cntx[3] ;
wire \u1/cntx[2] ;
wire \u1/cntx[1] ;
wire \u1/cntx[0] ;
wire \u1/cnty[11] ;
wire \u1/cnty[10] ;
wire \u1/cnty[9] ;
wire \u1/cnty[8] ;
wire \u1/cnty[7] ;
wire \u1/cnty[6] ;
wire \u1/cnty[5] ;
wire \u1/cnty[4] ;
wire \u1/cnty[3] ;
wire \u1/cnty[2] ;
wire \u1/cnty[1] ;
wire \u1/cnty[0] ;
wire r_Vsync_0;
wire r_Hsync_0;
wire \u1/als_kk[15] ;
wire \u1/als_kk[14] ;
wire \u1/als_kk[13] ;
wire \u1/als_kk[12] ;
wire \u1/als_kk[11] ;
wire \u1/als_kk[10] ;
wire \u1/als_kk[9] ;
wire \u1/als_kk[8] ;
wire \u1/als_kk[7] ;
wire \u1/als_kk[6] ;
wire \u1/als_kk[5] ;
wire \u1/als_kk[4] ;
wire \u1/als_kk[3] ;
wire \u1/als_kk[2] ;
wire \u1/als_kk[1] ;
wire \u1/als_kk[0] ;
wire \u_ap3216c/clk ;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(r_DE_0),
    .data_i({r_DE_0,\r_R_0[7] ,\r_R_0[6] ,\r_R_0[5] ,\r_R_0[4] ,\r_R_0[3] ,\r_R_0[2] ,\r_R_0[1] ,\r_R_0[0] ,\r_G_0[7] ,\r_G_0[6] ,\r_G_0[5] ,\r_G_0[4] ,\r_G_0[3] ,\r_G_0[2] ,\r_G_0[1] ,\r_G_0[0] ,\r_B_0[7] ,\r_B_0[6] ,\r_B_0[5] ,\r_B_0[4] ,\r_B_0[3] ,\r_B_0[2] ,\r_B_0[1] ,\r_B_0[0] ,\u1/cntx[11] ,\u1/cntx[10] ,\u1/cntx[9] ,\u1/cntx[8] ,\u1/cntx[7] ,\u1/cntx[6] ,\u1/cntx[5] ,\u1/cntx[4] ,\u1/cntx[3] ,\u1/cntx[2] ,\u1/cntx[1] ,\u1/cntx[0] ,\u1/cnty[11] ,\u1/cnty[10] ,\u1/cnty[9] ,\u1/cnty[8] ,\u1/cnty[7] ,\u1/cnty[6] ,\u1/cnty[5] ,\u1/cnty[4] ,\u1/cnty[3] ,\u1/cnty[2] ,\u1/cnty[1] ,\u1/cnty[0] ,r_Vsync_0,r_Hsync_0,\u1/als_kk[15] ,\u1/als_kk[14] ,\u1/als_kk[13] ,\u1/als_kk[12] ,\u1/als_kk[11] ,\u1/als_kk[10] ,\u1/als_kk[9] ,\u1/als_kk[8] ,\u1/als_kk[7] ,\u1/als_kk[6] ,\u1/als_kk[5] ,\u1/als_kk[4] ,\u1/als_kk[3] ,\u1/als_kk[2] ,\u1/als_kk[1] ,\u1/als_kk[0] }),
    .clk_i(\u_ap3216c/clk )
);

endmodule
