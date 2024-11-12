srcfile:=	../../project/src/lvds_7to1_rx/lvds_7to1_rx_top.v \
            ../../project/src/lvds_7to1_rx/LVDS71RX_1CLK8DATA.v \
            ../../project/src/lvds_7to1_rx/bit_align_ctl.v \
            ../../project/src/lvds_7to1_rx/word_align_ctl.v \
            ../../project/src/lvds_7to1_rx/gowin_rpll/LVDS_RX_rPLL.v \
            ../../project/src/lvds_7to1_rx/gowin_pllvr/LVDS_RX_PLLVR.v \
            ../../project/src/lvds_7to1_tx/lvds_7to1_tx_top.v \
            ../../project/src/lvds_7to1_tx/ip_gddr71tx.v \
            ../../project/src/lvds_7to1_tx/gowin_rpll/LVDS_TX_rPLL.v \
            ../../project/src/lvds_7to1_tx/gowin_pllvr/LVDS_TX_PLLVR.v 

tbfile:=	../../tb/prim_sim.v \
            ../../tb/tb.v \
			../../tb/driver/*.v \
			../../tb/monitor/*.v 
            
srcpath1:=  ../../project/src/lvds_7to1_rx 
srcpath2:=  ../../project/src/lvds_7to1_tx
			

vcs:
	vcs -debug_all -R -full64 -fsdb -sverilog \
	+incdir+$(srcpath1) \
    +incdir+$(srcpath2) \
	$(tbfile) \
	$(srcfile) 

verdi:
	verdi -sverilog	-nologo \
	+incdir+$(srcpath1) \
    +incdir+$(srcpath2) \
	$(tbfile) \
	$(srcfile) \
	-ssf tb.fsdb \
	&

clean:
	rm -rf compile  *.err *.log csrc  run.do  simv  simv.daidir  ucli.key  vc_hdrs.h  work novas.rc  nWaveLog   vcd2fsdbLog  verilog.vcd  verilog.vcd.fsdb vsim.wlf simv.vdb INCA_libs waves.shm .simvision *.rc cov_work daTaseT.asdb  fcover.acdb  library.cfg elab_file *.ucdb verdiLog inTer.vpd novas.conf wave.ses.png *.fsdb daTa

