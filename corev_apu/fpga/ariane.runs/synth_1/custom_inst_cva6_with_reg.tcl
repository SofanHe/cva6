# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "/home/sofan/CVA6-ckf/cva6/corev_apu/fpga/ariane.runs/synth_1/custom_inst_cva6_with_reg.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param checkpoint.writeSynthRtdsInDcp 1
set_param synth.incrementalSynthesisCache ./.Xil/Vivado-1113659-sofanserver/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-4480} -limit 1000
set_msg_config -id {Synth 8-638} -limit 10000
set_msg_config  -id {[Synth 8-5858]}  -new_severity {INFO} 
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7z045ffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/ariane.cache/wt [current_project]
set_property parent.project_path /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/ariane.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part xilinx.com:zc706:part0:1.4 [current_project]
set_property ip_output_repo /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/ariane.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
set_property include_dirs {
  /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/src/axi_sd_bridge/include
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/include
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/include
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/include
  /home/sofan/CVA6-ckf/cva6/corev_apu/register_interface/include
  /home/sofan/CVA6-ckf/cva6/core/include
} [current_fileset]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_verilog {
  /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/src/zc706.svh
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/include/common_cells/registers.svh
}
set_property file_type "Verilog Header" [get_files /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/src/zc706.svh]
set_property is_global_include true [get_files /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/src/zc706.svh]
set_property file_type "Verilog Header" [get_files /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/include/common_cells/registers.svh]
set_property is_global_include true [get_files /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/include/common_cells/registers.svh]
read_verilog -library xil_defaultlib -sv {
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/fpga-support/rtl/AsyncDpRam.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/fpga-support/rtl/AsyncThreePortRam.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/fpga-support/rtl/SyncDpRam.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/fpga-support/rtl/SyncSpRamBeNx64.sv
  /home/sofan/CVA6-ckf/cva6/core/include/config_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/include/rv64imc_config_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/include/riscv_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/include/ariane_pkg.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_pkg.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/cf_math_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/acc_dispatcher.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/addr_decode.sv
  /home/sofan/CVA6-ckf/cva6/core/alu.sv
  /home/sofan/CVA6-ckf/cva6/core/amo_buffer.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_pkg.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/tb/ariane_axi_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/include/cvxif_pkg.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/src/ariane.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/tb/ariane_axi_soc_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/ariane_regfile_ff.sv
  /home/sofan/CVA6-ckf/cva6/core/ariane_regfile_fpga.sv
  /home/sofan/CVA6-ckf/cva6/core/include/build_config_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/ariane_vecram.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/axi_mem_if/src/axi2mem.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/axi_adapter.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_atop_filter.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_demux.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_err_slv.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_id_prepend.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/tb/axi_intf.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_mux.sv
  /home/sofan/CVA6-ckf/cva6/core/axi_shim.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/tb/custom_inst_block/axi_slv_break.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/axi/src/axi_xbar.sv
  /home/sofan/CVA6-ckf/cva6/core/frontend/bht.sv
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/include/cvxif_instr_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/blackbox.sv
  /home/sofan/CVA6-ckf/cva6/core/branch_unit.sv
  /home/sofan/CVA6-ckf/cva6/core/frontend/btb.sv
  /home/sofan/CVA6-ckf/cva6/core/include/std_cache_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/cache_ctrl.sv
  /home/sofan/CVA6-ckf/cva6/core/commit_stage.sv
  /home/sofan/CVA6-ckf/cva6/core/compressed_decoder.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv
  /home/sofan/CVA6-ckf/cva6/core/controller.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/counter.sv
  /home/sofan/CVA6-ckf/cva6/core/csr_buffer.sv
  /home/sofan/CVA6-ckf/cva6/core/csr_regfile.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/tb/custom_inst_block/ctrlreg.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/bootrom/custom_inst/cust_inst_bootrom.sv
  /home/sofan/CVA6-ckf/cva6/core/include/wt_cache_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/cva6.sv
  /home/sofan/CVA6-ckf/cva6/core/cva6_accel_first_pass_decoder_stub.sv
  /home/sofan/CVA6-ckf/cva6/core/include/cva6_hpdcache_default_config_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/cva6_hpdcache_if_adapter.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_pkg.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/cva6_hpdcache_subsystem.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/cva6_hpdcache_subsystem_axi_arbiter.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/cva6_icache.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/cva6_icache_axi_wrapper.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv32/cva6_mmu_sv32.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv32/cva6_ptw_sv32.sv
  /home/sofan/CVA6-ckf/cva6/core/cva6_rvfi_probes.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv32/cva6_shared_tlb_sv32.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv32/cva6_tlb_sv32.sv
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cvxif_example_coprocessor.sv
  /home/sofan/CVA6-ckf/cva6/core/cvxif_fu.sv
  /home/sofan/CVA6-ckf/cva6/core/decoder.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/delta_counter.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv
  /home/sofan/CVA6-ckf/cva6/core/ex_stage.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/exp_backoff.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/deprecated/fifo_v2.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/fifo_v3.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_cast_multi.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_classifier.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_divsqrt_multi.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_fma.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_fma_multi.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_noncomp.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_opgroup_block.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_opgroup_fmt_slice.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_opgroup_multifmt_slice.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_rounding.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpnew_top.sv
  /home/sofan/CVA6-ckf/cva6/core/fpu_wrap.sv
  /home/sofan/CVA6-ckf/cva6/core/frontend/frontend.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_amo.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_cmo.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_core_arbiter.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_ctrl.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_ctrl_pe.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_downsize.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_upsize.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_demux.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fifo_reg.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fxarb.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_lfsr.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_req_read_arbiter.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_req_write_arbiter.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_resp_demux.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_to_axi_read.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_to_axi_write.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memarray.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_miss_handler.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr_to_cache_set.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_mux.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_plru.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_prio_1hot_encoder.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_regbank_wbyteenable_1rw.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_regbank_wmask_1rw.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_rrarb.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_rtab.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sram.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_1rw.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sram_wbyteenable.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_wbyteenable_1rw.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sram_wmask.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_wmask_1rw.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_sync_buffer.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_uncached.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_sel.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf_wrapper.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv
  /home/sofan/CVA6-ckf/cva6/core/id_stage.sv
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/instr_decoder.sv
  /home/sofan/CVA6-ckf/cva6/core/frontend/instr_queue.sv
  /home/sofan/CVA6-ckf/cva6/core/instr_realign.sv
  /home/sofan/CVA6-ckf/cva6/core/frontend/instr_scan.sv
  /home/sofan/CVA6-ckf/cva6/core/issue_read_operands.sv
  /home/sofan/CVA6-ckf/cva6/core/issue_stage.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/lfsr.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/lfsr_8bit.sv
  /home/sofan/CVA6-ckf/cva6/core/load_store_unit.sv
  /home/sofan/CVA6-ckf/cva6/core/load_unit.sv
  /home/sofan/CVA6-ckf/cva6/core/lsu_bypass.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/lzc.sv
  /home/sofan/CVA6-ckf/cva6/core/macro_decoder.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/miss_handler.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv39/mmu.sv
  /home/sofan/CVA6-ckf/cva6/core/mult.sv
  /home/sofan/CVA6-ckf/cva6/core/multiplier.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv
  /home/sofan/CVA6-ckf/cva6/core/perf_counters.sv
  /home/sofan/CVA6-ckf/cva6/core/pmp/src/pmp.sv
  /home/sofan/CVA6-ckf/cva6/core/pmp/src/pmp_entry.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/popcount.sv
  /home/sofan/CVA6-ckf/cva6/vendor/openhwgroup/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv39/ptw.sv
  /home/sofan/CVA6-ckf/cva6/core/frontend/ras.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv
  /home/sofan/CVA6-ckf/cva6/core/scoreboard.sv
  /home/sofan/CVA6-ckf/cva6/core/serdiv.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/shift_reg.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/spill_register.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/spill_register_flushable.sv
  /home/sofan/CVA6-ckf/cva6/common/local/util/sram.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/std_cache_subsystem.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/std_nbdcache.sv
  /home/sofan/CVA6-ckf/cva6/core/store_buffer.sv
  /home/sofan/CVA6-ckf/cva6/core/store_unit.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/stream_demux.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/stream_mux.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/stream_register.sv
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_CAG444toRGB888_k8_150MHz/t64_CAG444toRGB888_k8.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_CAG444toRGB888_k8_150MHz/t64_CAG444toRGB888_k8_flow_control_loop_pipe_sequential_init.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_CAG444toRGB888_k8_150MHz/t64_CAG444toRGB888_k8_mac_muladd_8ns_11ns_16s_20_4_1.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_CAG444toRGB888_k8_150MHz/t64_CAG444toRGB888_k8_regslice_forward.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_CAG444toRGB888_k8_150MHz/t64_CAG444toRGB888_k8_t64_CAG444toRGB888_k8_Pipeline_VITIS_LOOP_50_1.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_nv12toCAG444_k8_150MHz/t64_nv12toCAG444_k8.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_nv12toCAG444_k8_150MHz/t64_nv12toCAG444_k8_flow_control_loop_pipe_sequential_init.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_nv12toCAG444_k8_150MHz/t64_nv12toCAG444_k8_regslice_forward.v
  /home/sofan/CVA6-ckf/cva6/core/cvxif_example/cust_inst/t64_nv12toCAG444_k8_150MHz/t64_nv12toCAG444_k8_t64_nv12toCAG444_k8_Pipeline_VITIS_LOOP_17_1.v
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/tag_cmp.sv
  /home/sofan/CVA6-ckf/cva6/common/local/util/tc_sram_fpga_wrapper.sv
  /home/sofan/CVA6-ckf/cva6/core/mmu_sv39/tlb.sv
  /home/sofan/CVA6-ckf/cva6/vendor/pulp-platform/common_cells/src/unread.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_axi_adapter.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_cache_subsystem.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_dcache.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_dcache_ctrl.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_dcache_mem.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_dcache_missunit.sv
  /home/sofan/CVA6-ckf/cva6/core/cache_subsystem/wt_dcache_wbuffer.sv
  /home/sofan/CVA6-ckf/cva6/corev_apu/tb/custom_inst_cva6_with_reg.sv
}
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/constraints/zc706.xdc
set_property used_in_implementation false [get_files /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/constraints/zc706.xdc]

read_xdc /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/constraints/ariane.xdc
set_property used_in_implementation false [get_files /home/sofan/CVA6-ckf/cva6/corev_apu/fpga/constraints/ariane.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top custom_inst_cva6_with_reg -part xc7z045ffg900-2 -global_retiming on
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef custom_inst_cva6_with_reg.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file custom_inst_cva6_with_reg_utilization_synth.rpt -pb custom_inst_cva6_with_reg_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
