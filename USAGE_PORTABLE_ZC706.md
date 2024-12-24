在corev_apu/fpga/scripts/run.tcl脚本下，有三行的注释(92-94Line)，取消注释之后，在cva6/仓库根目录下执行以下指令：

```
export RISCV=/tools/RISCV-Toolchain/
source /path/to/vivado/settings64.sh
export FREQ=150MHz
make fpga BOARD=zc706 FREQ=150MHz
cp corev_apu/fpga/ariane.runs/synth_1/custom_inst_cva6_with_reg.dcp ./cva6_dcp
```

然后会在write bitstream的时候报error，因为生成dcp和生成bitstream的综合选项不一样。

生成的dcp文件在corev_apu/fpga/ariane.runs/synth_1/目录下.