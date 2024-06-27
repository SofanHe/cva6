# Make sure you are in the fpga path.

add_files -fileset constrs_1 -norecurse constraints/zc706.xdc

read_ip { \
      "xilinx/xlnx_mig_7_ddr3/xlnx_mig_7_ddr3.srcs/sources_1/ip/xlnx_mig_7_ddr3/xlnx_mig_7_ddr3.xci" \
      "xilinx/xlnx_axi_clock_converter/xlnx_axi_clock_converter.srcs/sources_1/ip/xlnx_axi_clock_converter/xlnx_axi_clock_converter.xci" \
      "xilinx/xlnx_axi_dwidth_converter/xlnx_axi_dwidth_converter.srcs/sources_1/ip/xlnx_axi_dwidth_converter/xlnx_axi_dwidth_converter.xci" \
      "xilinx/xlnx_axi_dwidth_converter_dm_slave/xlnx_axi_dwidth_converter_dm_slave.srcs/sources_1/ip/xlnx_axi_dwidth_converter_dm_slave/xlnx_axi_dwidth_converter_dm_slave.xci" \
      "xilinx/xlnx_axi_dwidth_converter_dm_master/xlnx_axi_dwidth_converter_dm_master.srcs/sources_1/ip/xlnx_axi_dwidth_converter_dm_master/xlnx_axi_dwidth_converter_dm_master.xci" \
      "xilinx/xlnx_axi_gpio/xlnx_axi_gpio.srcs/sources_1/ip/xlnx_axi_gpio/xlnx_axi_gpio.xci" \
      "xilinx/xlnx_axi_quad_spi/xlnx_axi_quad_spi.srcs/sources_1/ip/xlnx_axi_quad_spi/xlnx_axi_quad_spi.xci" \
      "xilinx/xlnx_clk_gen/xlnx_clk_gen.srcs/sources_1/ip/xlnx_clk_gen/xlnx_clk_gen.xci" \
}

set_property include_dirs { \
	"src/axi_sd_bridge/include" \
	"../../vendor/pulp-platform/common_cells/include" \
	"../../vendor/pulp-platform/axi/include" \
	"../../core/cache_subsystem/hpdcache/rtl/include" \
	"../register_interface/include" \
	"../../core/include" \
} [current_fileset]

source scripts/import_cva6_add_sources.tcl

add_files src/custom_inst_cva6_with_reg_warp.v
add_files ../bootrom/bootrom.sv
add_files ../riscv-dbg/debug_rom/debug_rom_one_scratch.sv
add_files ../../vendor/pulp-platform/common_cells/src/fall_through_register.sv
add_files ../../vendor/pulp-platform/axi/src/axi_burst_splitter.sv
add_files ../../vendor/pulp-platform/common_cells/src/id_queue.sv
add_files ../../core/cva6_rvfi.sv

add_files {../register_interface/include/register_interface/typedef.svh ../register_interface/include/register_interface/assign.svh}
add_files {../../core/cache_subsystem/hpdcache/rtl/include/hpdcache_typedef.svh}
add_files {../../core/include/rvfi_types.svh}
add_files {../../vendor/pulp-platform/axi/include/axi/assign.svh ../../vendor/pulp-platform/axi/include/axi/typedef.svh}
add_files {../../vendor/pulp-platform/common_cells/include/common_cells/assertions.svh ../../vendor/pulp-platform/common_cells/include/common_cells/registers.svh}

# set_property top custom_inst_cva6_with_reg [current_fileset]
set_property top custom_inst_cva6_with_reg_warp [current_fileset]

add_files {src/zc706.svh ../../vendor/pulp-platform/common_cells/include/common_cells/registers.svh}
set file "src/zc706.svh"
set registers "../../vendor/pulp-platform/common_cells/include/common_cells/registers.svh"

set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file" "$registers"]]
set_property -dict { file_type {Verilog Header} is_global_include 1} -objects $file_obj

add_files -fileset constrs_1 -norecurse constraints/ariane.xdc


# add cell: create_bd_cell -type module -reference cva6_warp cva6_warp_0
