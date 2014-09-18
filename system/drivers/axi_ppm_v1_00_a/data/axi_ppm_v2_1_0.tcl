##############################################################################
## Filename:          /home/vens/classes/Fall2014/cpre488/labs/mp1/MP-1/system/drivers/axi_ppm_v1_00_a/data/axi_ppm_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Wed Sep 17 15:16:32 2014 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "axi_ppm" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
