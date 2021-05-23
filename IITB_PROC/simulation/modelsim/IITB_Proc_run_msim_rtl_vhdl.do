transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/IITB_Proc.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/sext_9bit.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/sext_6bit.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/RegisterFile.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/nand.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Mux3_4_1.vhdl}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Mux3_2_1.vhdl}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Mux1_4_1.vhdl}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Mux1_2_1.vhdl}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Mux16_4_1.vhdl}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Mux16_2_1.vhdl}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/memory.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/FSM.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/ff_register.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/DFlipFlop.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Datapath.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/ALU.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/adder_16bit.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Half-Adder.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/Full-Adder.vhd}
vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/testbench.vhd}

vcom -93 -work work {D:/IITB CSE/sem4/CS 226/Project/IITB_PROC/testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 us
