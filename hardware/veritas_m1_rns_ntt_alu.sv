// Copyright 2026 Tom Budd.
// Licensed under the Apache License, Version 2.0.
//
// UNA-ARCH-SILICON-2026-VPU1-COMPACT ("Veritas-M1 Compact") · VLSI-1
// Synthesizable Shared Co-Prime RNS (m1=3329, m2=65537, m3=2147483647)
// and ML-KEM (q=3329) Cooley-Tukey NTT Butterfly Arithmetic Logic Unit
// with Fail-Closed Revocation Kill-Switch (`revoked_lstat_i`).

`timescale 1ns / 1ps

module veritas_m1_rns_ntt_alu (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        revoked_lstat_i,
    input  logic        valid_i,
    input  logic [1:0]  op_mode_i,
    input  logic [11:0] a_r1_i,
    input  logic [16:0] a_r2_i,
    input  logic [30:0] a_r3_i,
    input  logic [11:0] b_r1_i,
    input  logic [16:0] b_r2_i,
    input  logic [30:0] b_r3_i,
    input  logic [11:0] zeta_i,
    output logic        valid_o,
    output logic        abstention_hold_o,
    output logic [11:0] y_r1_o,
    output logic [16:0] y_r2_o,
    output logic [30:0] y_r3_o,
    output logic [11:0] ntt_v_o,
    output logic        q_exact_equal_o
);

    // Pairwise co-prime RNS moduli (58.7-bit CRT dynamic range)
    localparam logic [11:0] M1 = 12'd3329;
    localparam logic [16:0] M2 = 17'd65537;
    localparam logic [30:0] M3 = 31'd2147483647; // 2^31 - 1 (Mersenne prime)

    // Operation modes
    localparam logic [1:0] OP_RNS_ADD          = 2'b00;
    localparam logic [1:0] OP_RNS_MUL          = 2'b01;
    localparam logic [1:0] OP_NTT_CT_BUTTERFLY = 2'b10;
    localparam logic [1:0] OP_Q_CROSS_VERIFY   = 2'b11;

    // Normalized lane inputs (guaranteed < Mi)
    logic [11:0] a1_norm, b1_norm, z_norm;
    logic [16:0] a2_norm, b2_norm;
    logic [30:0] a3_norm, b3_norm;

    // Lane 1 intermediates (mod 3329)
    logic [12:0] add1_sum;
    logic [11:0] add1_mod;
    logic [23:0] mul1_prod;
    logic [11:0] mul1_mod;
    logic [23:0] ntt_zv_prod;
    logic [11:0] ntt_zv_mod;
    logic [12:0] ntt_u_plus;
    logic [11:0] ntt_u_prime;
    logic [12:0] ntt_u_minus;
    logic [11:0] ntt_v_prime;

    // Lane 2 intermediates (mod 65537)
    logic [17:0] add2_sum;
    logic [16:0] add2_mod;
    logic [33:0] mul2_prod;
    logic [16:0] mul2_mod;

    // Lane 3 intermediates (mod 2^31 - 1, Mersenne fold)
    logic [31:0] add3_sum;
    logic [30:0] add3_mod;
    logic [61:0] mul3_prod;
    logic [31:0] mul3_fold;
    logic [30:0] mul3_mod;

    // Next-cycle registered values
    logic        nxt_valid;
    logic        nxt_hold;
    logic [11:0] nxt_y_r1;
    logic [16:0] nxt_y_r2;
    logic [30:0] nxt_y_r3;
    logic [11:0] nxt_ntt_v;
    logic        nxt_q_eq;

    // Explicit Mersenne reduction helper for 62-bit product (0 <= x <= (2^31-2)^2 < M3^2)
    function automatic logic [30:0] reduce_mod_m3(input logic [61:0] x);
        logic [31:0] s1;
        logic [31:0] s2;
        begin
            s1 = {1'b0, x[30:0]} + {1'b0, x[61:31]};
            s2 = (s1 >= {1'b0, M3}) ? (s1 - {1'b0, M3}) : s1;
            reduce_mod_m3 = (s2 >= {1'b0, M3}) ? s2[30:0] - M3 : s2[30:0];
        end
    endfunction

    always_comb begin
        // Normalize operands safely into [0, Mi - 1]
        a1_norm = (a_r1_i >= M1) ? (a_r1_i - M1) : a_r1_i;
        b1_norm = (b_r1_i >= M1) ? (b_r1_i - M1) : b_r1_i;
        z_norm  = (zeta_i >= M1) ? (zeta_i - M1) : zeta_i;

        a2_norm = (a_r2_i >= M2) ? (a_r2_i - M2) : a_r2_i;
        b2_norm = (b_r2_i >= M2) ? (b_r2_i - M2) : b_r2_i;

        a3_norm = (a_r3_i >= M3) ? (a_r3_i - M3) : a_r3_i;
        b3_norm = (b_r3_i >= M3) ? (b_r3_i - M3) : b_r3_i;

        // Lane 1 (m1 = 3329): Shared RNS Add/Mul + Cooley-Tukey NTT Butterfly
        add1_sum = {1'b0, a1_norm} + {1'b0, b1_norm};
        add1_mod = (add1_sum >= {1'b0, M1}) ? (add1_sum - {1'b0, M1}) : add1_sum[11:0];

        mul1_prod = a1_norm * b1_norm;
        mul1_mod  = 12'(mul1_prod % 24'(M1));

        ntt_zv_prod = z_norm * b1_norm;
        ntt_zv_mod  = 12'(ntt_zv_prod % 24'(M1));
        ntt_u_plus  = {1'b0, a1_norm} + {1'b0, ntt_zv_mod};
        ntt_u_prime = (ntt_u_plus >= {1'b0, M1}) ? (ntt_u_plus - {1'b0, M1}) : ntt_u_plus[11:0];
        ntt_u_minus = ({1'b0, a1_norm} >= {1'b0, ntt_zv_mod})
                      ? ({1'b0, a1_norm} - {1'b0, ntt_zv_mod})
                      : ({1'b0, a1_norm} + {1'b0, M1} - {1'b0, ntt_zv_mod});
        ntt_v_prime = ntt_u_minus[11:0];

        // Lane 2 (m2 = 65537 = 2^16 + 1)
        add2_sum = {1'b0, a2_norm} + {1'b0, b2_norm};
        add2_mod = (add2_sum >= {1'b0, M2}) ? (add2_sum - {1'b0, M2}) : add2_sum[16:0];

        mul2_prod = a2_norm * b2_norm;
        mul2_mod  = 17'(mul2_prod % 34'(M2));

        // Lane 3 (m3 = 2147483647 = 2^31 - 1)
        add3_sum  = {1'b0, a3_norm} + {1'b0, b3_norm};
        add3_mod  = (add3_sum >= {1'b0, M3}) ? (add3_sum - {1'b0, M3}) : add3_sum[30:0];

        mul3_prod = a3_norm * b3_norm;
        mul3_fold = 32'd0;
        mul3_mod  = reduce_mod_m3(mul3_prod);

        // Default next-state signals
        nxt_valid = valid_i;
        nxt_hold  = 1'b0;
        nxt_y_r1  = 12'd0;
        nxt_y_r2  = 17'd0;
        nxt_y_r3  = 31'd0;
        nxt_ntt_v = 12'd0;
        nxt_q_eq  = 1'b0;

        if (revoked_lstat_i) begin
            // Hardware fail-closed kill-switch clamps outputs to zero
            nxt_valid = 1'b0;
            nxt_hold  = 1'b1;
        end else if (valid_i) begin
            unique case (op_mode_i)
                OP_RNS_ADD: begin
                    nxt_y_r1 = add1_mod;
                    nxt_y_r2 = add2_mod;
                    nxt_y_r3 = add3_mod;
                end
                OP_RNS_MUL: begin
                    nxt_y_r1 = mul1_mod;
                    nxt_y_r2 = mul2_mod;
                    nxt_y_r3 = mul3_mod;
                end
                OP_NTT_CT_BUTTERFLY: begin
                    // Folded into Lane 1 (FU-3 NTT uses FU-1 RNS multiplier/adder lane)
                    nxt_y_r1  = ntt_u_prime;
                    nxt_ntt_v = ntt_v_prime;
                end
                OP_Q_CROSS_VERIFY: begin
                    // Exact rational equality / difference witness mod (M1, M2, M3):
                    // Returns (a_ri - b_ri) mod Mi in y_ri_o and asserts q_exact_equal_o iff all 3 residues == 0
                    nxt_y_r1 = (a1_norm >= b1_norm) ? (a1_norm - b1_norm) : (a1_norm + M1 - b1_norm);
                    nxt_y_r2 = (a2_norm >= b2_norm) ? (a2_norm - b2_norm) : (a2_norm + M2 - b2_norm);
                    nxt_y_r3 = (a3_norm >= b3_norm) ? (a3_norm - b3_norm) : (a3_norm + M3 - b3_norm);
                    nxt_q_eq = (a1_norm == b1_norm) && (a2_norm == b2_norm) && (a3_norm == b3_norm);
                end
                default: begin
                    nxt_y_r1 = 12'd0;
                    nxt_y_r2 = 17'd0;
                    nxt_y_r3 = 31'd0;
                end
            endcase
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_o           <= 1'b0;
            abstention_hold_o <= 1'b0;
            y_r1_o            <= 12'd0;
            y_r2_o            <= 17'd0;
            y_r3_o            <= 31'd0;
            ntt_v_o           <= 12'd0;
            q_exact_equal_o   <= 1'b0;
        end else begin
            valid_o           <= nxt_valid;
            abstention_hold_o <= nxt_hold;
            y_r1_o            <= nxt_y_r1;
            y_r2_o            <= nxt_y_r2;
            y_r3_o            <= nxt_y_r3;
            ntt_v_o           <= nxt_ntt_v;
            q_exact_equal_o   <= nxt_q_eq;
        end
    end

endmodule
