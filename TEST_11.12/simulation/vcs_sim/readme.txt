Attention, please: 
	1. If use external clock, I_serial_clk must be 3.5 times the frequency of I_rgb_clk
    2. If choose AUTO_PHASE mode, please `define SIM to accelerate the bit align simulation


1.Run Command
    method : make vcs , in the Terminal of the Linux to run functional simulation by software VCS
             make verdi , in the Terminal of the Linux to check waveform by software Verdi

2.Files Introduction

    makefile  : simulation script file
