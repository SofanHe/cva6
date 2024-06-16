// ==============================================================
// Generated by Vitis HLS v2023.2
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module t64_CAG444toRGB888_k8_t64_CAG444toRGB888_k8_Pipeline_VITIS_LOOP_50_1 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        YUV192,
        RGB192_out,
        RGB192_out_ap_vld
);

parameter    ap_ST_fsm_pp0_stage0 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [191:0] YUV192;
output  [191:0] RGB192_out;
output   RGB192_out_ap_vld;

reg ap_idle;
reg RGB192_out_ap_vld;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_enable_reg_pp0_iter2;
reg    ap_enable_reg_pp0_iter3;
reg    ap_enable_reg_pp0_iter4;
reg    ap_idle_pp0;
wire    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln50_fu_147_p2;
reg    ap_condition_exit_pp0_iter1_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
wire    ap_block_pp0_stage0_11001;
reg   [0:0] icmp_ln50_reg_637;
reg   [0:0] icmp_ln50_reg_637_pp0_iter2_reg;
reg   [7:0] tmp_reg_646;
reg   [7:0] tmp_reg_646_pp0_iter2_reg;
reg   [7:0] tmp_reg_646_pp0_iter3_reg;
reg   [7:0] tmp_2_reg_652;
reg   [7:0] tmp_2_reg_652_pp0_iter2_reg;
reg   [7:0] tmp_2_reg_652_pp0_iter3_reg;
wire   [2:0] trunc_ln74_fu_204_p1;
reg   [2:0] trunc_ln74_reg_657;
reg   [2:0] trunc_ln74_reg_657_pp0_iter2_reg;
reg   [2:0] trunc_ln74_reg_657_pp0_iter3_reg;
reg   [191:0] YUV192_1_fu_104;
wire   [191:0] zext_ln56_fu_176_p1;
wire    ap_loop_init;
wire    ap_block_pp0_stage0;
reg   [191:0] RGB192_fu_108;
wire   [191:0] RGB192_1_fu_589_p2;
reg   [3:0] i_fu_112;
wire   [3:0] i_2_fu_153_p2;
wire    ap_block_pp0_stage0_01001;
wire   [167:0] YUV192_2_fu_166_p4;
wire   [7:0] Y_fu_162_p1;
wire   [16:0] shl_ln_fu_221_p3;
wire   [13:0] and_ln_fu_232_p3;
wire   [17:0] zext_ln63_1_fu_239_p1;
wire   [17:0] zext_ln63_fu_228_p1;
wire   [17:0] newFirst11_fu_243_p2;
wire   [17:0] uv448_fu_249_p2;
wire   [14:0] and_ln1_fu_259_p3;
wire  signed [19:0] sext_ln63_fu_255_p1;
wire  signed [19:0] add_ln66_fu_272_p1;
wire   [19:0] grp_fu_604_p3;
wire   [14:0] uv128_fu_266_p2;
wire  signed [19:0] sext_ln67_fu_277_p1;
wire  signed [19:0] newSecond_fu_287_p0;
wire   [19:0] newFirst_fu_281_p2;
wire  signed [19:0] add_ln68_fu_292_p1;
(* use_dsp48 = "no" *) wire   [19:0] add_ln66_fu_272_p2;
wire   [1:0] tmp_3_fu_305_p4;
wire   [0:0] tmp_1_fu_297_p3;
wire   [0:0] xor_ln70_fu_331_p2;
wire   [0:0] icmp_ln70_fu_315_p2;
wire   [0:0] or_ln70_fu_345_p2;
wire   [7:0] select_ln70_fu_337_p3;
wire   [7:0] R_fu_321_p4;
(* use_dsp48 = "no" *) wire   [19:0] newSecond_fu_287_p2;
wire   [1:0] tmp_5_fu_367_p4;
wire   [0:0] tmp_4_fu_359_p3;
wire   [0:0] xor_ln71_fu_393_p2;
wire   [0:0] icmp_ln71_fu_377_p2;
wire   [0:0] or_ln71_fu_407_p2;
wire   [7:0] select_ln71_fu_399_p3;
wire   [7:0] G_fu_383_p4;
(* use_dsp48 = "no" *) wire   [19:0] add_ln68_fu_292_p2;
wire   [1:0] tmp_7_fu_429_p4;
wire   [0:0] tmp_6_fu_421_p3;
wire   [0:0] xor_ln72_fu_455_p2;
wire   [0:0] icmp_ln72_fu_439_p2;
wire   [0:0] or_ln72_fu_469_p2;
wire   [7:0] select_ln72_fu_461_p3;
wire   [7:0] B_fu_445_p4;
wire   [7:0] B_1_fu_475_p3;
wire   [7:0] shl_ln74_1_fu_487_p3;
wire   [5:0] shl_ln74_2_fu_498_p3;
wire   [8:0] zext_ln74_1_fu_494_p1;
wire   [8:0] zext_ln74_2_fu_505_p1;
wire  signed [8:0] sub_ln74_fu_509_p2;
wire  signed [31:0] sext_ln74_fu_515_p1;
wire   [191:0] zext_ln74_fu_483_p1;
wire   [191:0] zext_ln74_3_fu_519_p1;
wire   [7:0] G_1_fu_413_p3;
wire   [8:0] add_ln75_fu_533_p2;
wire  signed [31:0] sext_ln75_fu_539_p1;
wire   [191:0] zext_ln75_fu_529_p1;
wire   [191:0] zext_ln75_1_fu_543_p1;
wire   [7:0] R_1_fu_351_p3;
wire   [8:0] add_ln76_fu_557_p2;
wire  signed [31:0] sext_ln76_fu_563_p1;
wire   [191:0] zext_ln76_fu_553_p1;
wire   [191:0] zext_ln76_1_fu_567_p1;
wire   [191:0] shl_ln74_fu_523_p2;
wire   [191:0] shl_ln76_fu_571_p2;
wire   [191:0] shl_ln75_fu_547_p2;
wire   [191:0] or_ln76_fu_577_p2;
wire   [191:0] or_ln76_1_fu_583_p2;
wire   [7:0] grp_fu_604_p0;
wire   [10:0] grp_fu_604_p1;
wire  signed [15:0] grp_fu_604_p2;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg    ap_loop_exit_ready_pp0_iter2_reg;
reg    ap_loop_exit_ready_pp0_iter3_reg;
reg   [0:0] ap_NS_fsm;
wire    ap_enable_pp0;
wire    ap_start_int;
wire   [18:0] grp_fu_604_p00;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
#0 ap_enable_reg_pp0_iter3 = 1'b0;
#0 ap_enable_reg_pp0_iter4 = 1'b0;
#0 YUV192_1_fu_104 = 192'd0;
#0 RGB192_fu_108 = 192'd0;
#0 i_fu_112 = 4'd0;
#0 ap_done_reg = 1'b0;
end

t64_CAG444toRGB888_k8_mac_muladd_8ns_11ns_16s_20_4_1 #(
    .ID( 1 ),
    .NUM_STAGE( 4 ),
    .din0_WIDTH( 8 ),
    .din1_WIDTH( 11 ),
    .din2_WIDTH( 16 ),
    .dout_WIDTH( 20 ))
mac_muladd_8ns_11ns_16s_20_4_1_U1(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(grp_fu_604_p0),
    .din1(grp_fu_604_p1),
    .din2(grp_fu_604_p2),
    .ce(1'b1),
    .dout(grp_fu_604_p3)
);

t64_CAG444toRGB888_k8_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter1_stage0),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((ap_loop_exit_ready_pp0_iter3_reg == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter1_stage0)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= ap_start_int;
        end
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter1_stage0)) begin
            ap_enable_reg_pp0_iter2 <= 1'b0;
        end else if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter3 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter3 <= ap_enable_reg_pp0_iter2;
        end
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter4 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter4 <= ap_enable_reg_pp0_iter3;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        if (((ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            RGB192_fu_108 <= 192'd0;
        end else if ((ap_enable_reg_pp0_iter4 == 1'b1)) begin
            RGB192_fu_108 <= RGB192_1_fu_589_p2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            YUV192_1_fu_104 <= YUV192;
        end else if (((icmp_ln50_fu_147_p2 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
            YUV192_1_fu_104 <= zext_ln56_fu_176_p1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            i_fu_112 <= 4'd0;
        end else if (((icmp_ln50_fu_147_p2 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
            i_fu_112 <= i_2_fu_153_p2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_loop_exit_ready_pp0_iter2_reg <= ap_loop_exit_ready;
        icmp_ln50_reg_637 <= icmp_ln50_fu_147_p2;
        tmp_2_reg_652 <= {{YUV192_1_fu_104[23:16]}};
        tmp_reg_646 <= {{YUV192_1_fu_104[15:8]}};
        trunc_ln74_reg_657 <= trunc_ln74_fu_204_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b0 == ap_block_pp0_stage0_11001)) begin
        ap_loop_exit_ready_pp0_iter3_reg <= ap_loop_exit_ready_pp0_iter2_reg;
        icmp_ln50_reg_637_pp0_iter2_reg <= icmp_ln50_reg_637;
        tmp_2_reg_652_pp0_iter2_reg <= tmp_2_reg_652;
        tmp_2_reg_652_pp0_iter3_reg <= tmp_2_reg_652_pp0_iter2_reg;
        tmp_reg_646_pp0_iter2_reg <= tmp_reg_646;
        tmp_reg_646_pp0_iter3_reg <= tmp_reg_646_pp0_iter2_reg;
        trunc_ln74_reg_657_pp0_iter2_reg <= trunc_ln74_reg_657;
        trunc_ln74_reg_657_pp0_iter3_reg <= trunc_ln74_reg_657_pp0_iter2_reg;
    end
end

always @ (*) begin
    if (((icmp_ln50_reg_637_pp0_iter2_reg == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001))) begin
        RGB192_out_ap_vld = 1'b1;
    end else begin
        RGB192_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln50_fu_147_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter1_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter1_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_exit_ready_pp0_iter3_reg == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_start_int == 1'b0) & (ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter4 == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign B_1_fu_475_p3 = ((or_ln72_fu_469_p2[0:0] == 1'b1) ? select_ln72_fu_461_p3 : B_fu_445_p4);

assign B_fu_445_p4 = {{add_ln68_fu_292_p2[17:10]}};

assign G_1_fu_413_p3 = ((or_ln71_fu_407_p2[0:0] == 1'b1) ? select_ln71_fu_399_p3 : G_fu_383_p4);

assign G_fu_383_p4 = {{newSecond_fu_287_p2[17:10]}};

assign RGB192_1_fu_589_p2 = (or_ln76_1_fu_583_p2 | RGB192_fu_108);

assign RGB192_out = RGB192_fu_108;

assign R_1_fu_351_p3 = ((or_ln70_fu_345_p2[0:0] == 1'b1) ? select_ln70_fu_337_p3 : R_fu_321_p4);

assign R_fu_321_p4 = {{add_ln66_fu_272_p2[17:10]}};

assign YUV192_2_fu_166_p4 = {{YUV192_1_fu_104[191:24]}};

assign Y_fu_162_p1 = YUV192_1_fu_104[7:0];

assign add_ln66_fu_272_p1 = grp_fu_604_p3;

assign add_ln66_fu_272_p2 = ($signed(sext_ln63_fu_255_p1) + $signed(add_ln66_fu_272_p1));

assign add_ln68_fu_292_p1 = grp_fu_604_p3;

assign add_ln68_fu_292_p2 = ($signed(sext_ln67_fu_277_p1) + $signed(add_ln68_fu_292_p1));

assign add_ln75_fu_533_p2 = ($signed(sub_ln74_fu_509_p2) + $signed(9'd8));

assign add_ln76_fu_557_p2 = ($signed(sub_ln74_fu_509_p2) + $signed(9'd16));

assign and_ln1_fu_259_p3 = {{tmp_2_reg_652_pp0_iter3_reg}, {7'd0}};

assign and_ln_fu_232_p3 = {{tmp_reg_646_pp0_iter3_reg}, {6'd0}};

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_01001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_enable_reg_pp0_iter0 = ap_start_int;

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter1_stage0;

assign grp_fu_604_p0 = grp_fu_604_p00;

assign grp_fu_604_p00 = Y_fu_162_p1;

assign grp_fu_604_p1 = 19'd1192;

assign grp_fu_604_p2 = 20'd1029504;

assign i_2_fu_153_p2 = (i_fu_112 + 4'd1);

assign icmp_ln50_fu_147_p2 = ((i_fu_112 == 4'd8) ? 1'b1 : 1'b0);

assign icmp_ln70_fu_315_p2 = ((tmp_3_fu_305_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln71_fu_377_p2 = ((tmp_5_fu_367_p4 == 2'd1) ? 1'b1 : 1'b0);

assign icmp_ln72_fu_439_p2 = ((tmp_7_fu_429_p4 == 2'd1) ? 1'b1 : 1'b0);

assign newFirst11_fu_243_p2 = ($signed(18'd204800) - $signed(zext_ln63_1_fu_239_p1));

assign newFirst_fu_281_p2 = ($signed(sext_ln67_fu_277_p1) + $signed(sext_ln63_fu_255_p1));

assign newSecond_fu_287_p0 = grp_fu_604_p3;

assign newSecond_fu_287_p2 = ($signed(newSecond_fu_287_p0) - $signed(newFirst_fu_281_p2));

assign or_ln70_fu_345_p2 = (tmp_1_fu_297_p3 | icmp_ln70_fu_315_p2);

assign or_ln71_fu_407_p2 = (tmp_4_fu_359_p3 | icmp_ln71_fu_377_p2);

assign or_ln72_fu_469_p2 = (tmp_6_fu_421_p3 | icmp_ln72_fu_439_p2);

assign or_ln76_1_fu_583_p2 = (shl_ln75_fu_547_p2 | or_ln76_fu_577_p2);

assign or_ln76_fu_577_p2 = (shl_ln76_fu_571_p2 | shl_ln74_fu_523_p2);

assign select_ln70_fu_337_p3 = ((xor_ln70_fu_331_p2[0:0] == 1'b1) ? 8'd255 : 8'd0);

assign select_ln71_fu_399_p3 = ((xor_ln71_fu_393_p2[0:0] == 1'b1) ? 8'd255 : 8'd0);

assign select_ln72_fu_461_p3 = ((xor_ln72_fu_455_p2[0:0] == 1'b1) ? 8'd255 : 8'd0);

assign sext_ln63_fu_255_p1 = $signed(uv448_fu_249_p2);

assign sext_ln67_fu_277_p1 = $signed(uv128_fu_266_p2);

assign sext_ln74_fu_515_p1 = sub_ln74_fu_509_p2;

assign sext_ln75_fu_539_p1 = $signed(add_ln75_fu_533_p2);

assign sext_ln76_fu_563_p1 = $signed(add_ln76_fu_557_p2);

assign shl_ln74_1_fu_487_p3 = {{trunc_ln74_reg_657_pp0_iter3_reg}, {5'd0}};

assign shl_ln74_2_fu_498_p3 = {{trunc_ln74_reg_657_pp0_iter3_reg}, {3'd0}};

assign shl_ln74_fu_523_p2 = zext_ln74_fu_483_p1 << zext_ln74_3_fu_519_p1;

assign shl_ln75_fu_547_p2 = zext_ln75_fu_529_p1 << zext_ln75_1_fu_543_p1;

assign shl_ln76_fu_571_p2 = zext_ln76_fu_553_p1 << zext_ln76_1_fu_567_p1;

assign shl_ln_fu_221_p3 = {{tmp_reg_646_pp0_iter3_reg}, {9'd0}};

assign sub_ln74_fu_509_p2 = (zext_ln74_1_fu_494_p1 - zext_ln74_2_fu_505_p1);

assign tmp_1_fu_297_p3 = add_ln66_fu_272_p2[32'd19];

assign tmp_3_fu_305_p4 = {{add_ln66_fu_272_p2[19:18]}};

assign tmp_4_fu_359_p3 = newSecond_fu_287_p2[32'd19];

assign tmp_5_fu_367_p4 = {{newSecond_fu_287_p2[19:18]}};

assign tmp_6_fu_421_p3 = add_ln68_fu_292_p2[32'd19];

assign tmp_7_fu_429_p4 = {{add_ln68_fu_292_p2[19:18]}};

assign trunc_ln74_fu_204_p1 = i_fu_112[2:0];

assign uv128_fu_266_p2 = (15'd16384 ^ and_ln1_fu_259_p3);

assign uv448_fu_249_p2 = (zext_ln63_fu_228_p1 + newFirst11_fu_243_p2);

assign xor_ln70_fu_331_p2 = (tmp_1_fu_297_p3 ^ 1'd1);

assign xor_ln71_fu_393_p2 = (tmp_4_fu_359_p3 ^ 1'd1);

assign xor_ln72_fu_455_p2 = (tmp_6_fu_421_p3 ^ 1'd1);

assign zext_ln56_fu_176_p1 = YUV192_2_fu_166_p4;

assign zext_ln63_1_fu_239_p1 = and_ln_fu_232_p3;

assign zext_ln63_fu_228_p1 = shl_ln_fu_221_p3;

assign zext_ln74_1_fu_494_p1 = shl_ln74_1_fu_487_p3;

assign zext_ln74_2_fu_505_p1 = shl_ln74_2_fu_498_p3;

assign zext_ln74_3_fu_519_p1 = $unsigned(sext_ln74_fu_515_p1);

assign zext_ln74_fu_483_p1 = B_1_fu_475_p3;

assign zext_ln75_1_fu_543_p1 = $unsigned(sext_ln75_fu_539_p1);

assign zext_ln75_fu_529_p1 = G_1_fu_413_p3;

assign zext_ln76_1_fu_567_p1 = $unsigned(sext_ln76_fu_563_p1);

assign zext_ln76_fu_553_p1 = R_1_fu_351_p3;

endmodule //t64_CAG444toRGB888_k8_t64_CAG444toRGB888_k8_Pipeline_VITIS_LOOP_50_1
