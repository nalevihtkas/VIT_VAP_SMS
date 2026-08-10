
// ============================================================================
// SMART SENSOR PROCESSING UNIT
//
// Application:
//   Four 8-bit sensors are combined into a weighted result.
//   A controller accepts START, computes the result, asserts VALID,
//   and distributes an ALARM/ENABLE status to many monitoring outputs.
//
// All variants implement the same application idea.
// The pipelined versions have additional latency.
// ============================================================================

// ----------------------------------------------------------------------------
// Small hierarchy block used to demonstrate hierarchy optimization.
// ----------------------------------------------------------------------------
module sensor_preprocess_leaf (
    input  wire [7:0] sensor_a,
    input  wire [7:0] sensor_b,
    output wire [8:0] pair_sum
);
    assign pair_sum = sensor_a + sensor_b;
endmodule

// ============================================================================
// 1. BASELINE VERSION
// Intentionally contains redundant and inefficient structures.
// ============================================================================
module smart_sensor_base (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        enable,
    input  wire        debug_enable,
    input  wire [7:0]  s0,
    input  wire [7:0]  s1,
    input  wire [7:0]  s2,
    input  wire [7:0]  s3,
    output reg  [19:0] result,
    output reg         valid,
    output wire [15:0] monitor_enable
);

    // TI: constant propagation candidate.
    wire fixed_mode = 1'b1;

    // TI: Boolean simplification candidate:
    // (enable & start) | (enable & ~start) = enable.
    wire redundant_enable;
    assign redundant_enable =
        (enable & start) | (enable & ~start);

    // TI: hierarchy optimization candidate.
    wire [8:0] pair01_hier;
    sensor_preprocess_leaf u_pair01 (
        .sensor_a(s0),
        .sensor_b(s1),
        .pair_sum(pair01_hier)
    );

    // TI: dead code candidate. This value is not observable.
    wire [15:0] unused_debug_product;
    assign unused_debug_product = s2 * s3;

    // TI/CSE: duplicated common expression.
    wire [9:0] path_a = (s0 + s1) + s2;
    wire [9:0] path_b = (s0 + s1) + s3;

    // Datapath: two independent multipliers.
    wire [15:0] product0 = s0 * s1;
    wire [15:0] product1 = s2 * s3;

    // Datapath: serial adder chain.
    wire [17:0] serial_sum_0 = product0 + product1;
    wire [18:0] serial_sum_1 = serial_sum_0 + path_a;
    wire [19:0] full_sum     = serial_sum_1 + path_b;

    // TI: arithmetic simplification candidate: result + 0.
    wire [19:0] arithmetic_redundant = full_sum + 20'd0;

    // Technology mapping candidates.
    wire aoi_function = ~((s0[0] & s1[0]) | (s2[0] & s3[0]));
    wire nand_function = ~(s0[1] & s1[1]);
    wire nor_function  = ~(s2[1] | s3[1]);

    // High-fanout status net for buffer/fanout/drive optimization.
    wire alarm_status = fixed_mode &
                        redundant_enable &
                        (aoi_function | nand_function | nor_function);
    assign monitor_enable = {16{alarm_status}};

    // FSM contains an unnecessary DEBUG state reachable only by debug_enable.
    localparam IDLE    = 3'd0;
    localparam LOAD    = 3'd1;
    localparam COMPUTE = 3'd2;
    localparam OUTPUTS = 3'd3;
    localparam DEBUG   = 3'd4;

    reg [2:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        valid = 1'b0;

        case (state)
            IDLE:
                if (debug_enable)
                    next_state = DEBUG;
                else if (start)
                    next_state = LOAD;

            LOAD:
                next_state = COMPUTE;

            COMPUTE:
                next_state = OUTPUTS;

            OUTPUTS: begin
                valid = 1'b1;
                next_state = IDLE;
            end

            DEBUG:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            result <= 20'd0;
        else
            result <= arithmetic_redundant;
    end
endmodule

// ============================================================================
// 2. TECHNOLOGY-INDEPENDENT OPTIMIZED VERSION
// Same application; redundant generic logic is removed/exposed for syn_generic.
// ============================================================================
module smart_sensor_ti_opt (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        enable,
    input  wire [7:0]  s0,
    input  wire [7:0]  s1,
    input  wire [7:0]  s2,
    input  wire [7:0]  s3,
    output reg  [19:0] result,
    output reg         valid,
    output wire [15:0] monitor_enable
);
    // Constant propagation and Boolean simplification already exposed.
    wire simplified_enable = enable;

    // Common-subexpression elimination.
    wire [8:0] common_pair = s0 + s1;
    wire [9:0] path_a = common_pair + s2;
    wire [9:0] path_b = common_pair + s3;

    // Resource sharing: one multiplier selected by phase.
    reg         mult_select;
    wire [7:0]  mult_a = mult_select ? s2 : s0;
    wire [7:0]  mult_b = mult_select ? s3 : s1;
    wire [15:0] shared_product = mult_a * mult_b;

    reg [15:0] product0_reg;
    reg [15:0] product1_reg;

    // Arithmetic simplification: constant multiply by 5 = (x<<2)+x.
    wire [12:0] weighted_common =
        ({4'd0, common_pair} << 2) + {4'd0, common_pair};

    // Technology mapping candidates remain as compact Boolean expressions.
    wire aoi_function = ~((s0[0] & s1[0]) | (s2[0] & s3[0]));
    wire nand_function = ~(s0[1] & s1[1]);
    wire nor_function  = ~(s2[1] | s3[1]);

    wire alarm_status =
        simplified_enable & (aoi_function | nand_function | nor_function);
    assign monitor_enable = {16{alarm_status}};

    // FSM optimization: DEBUG state removed.
    localparam IDLE  = 3'd0;
    localparam MUL0  = 3'd1;
    localparam MUL1  = 3'd2;
    localparam ADD   = 3'd3;
    localparam DONE  = 3'd4;

    reg [2:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        valid       = 1'b0;
        mult_select = 1'b0;

        case (state)
            IDLE:
                if (start)
                    next_state = MUL0;

            MUL0: begin
                mult_select = 1'b0;
                next_state  = MUL1;
            end

            MUL1: begin
                mult_select = 1'b1;
                next_state  = ADD;
            end

            ADD:
                next_state = DONE;

            DONE: begin
                valid = 1'b1;
                next_state = IDLE;
            end

            default:
                next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product0_reg <= 16'd0;
            product1_reg <= 16'd0;
            result       <= 20'd0;
        end else begin
            if (state == MUL0)
                product0_reg <= shared_product;

            if (state == MUL1)
                product1_reg <= shared_product;

            if (state == ADD)
                result <= product0_reg + product1_reg +
                          path_a + path_b + weighted_common;
        end
    end
endmodule

// ============================================================================
// 3. DATAPATH OPTIMIZED VERSION
// Operator inference, proper widths, balanced tree, pipelining and register/MUX
// optimization. This version is used for technology-dependent mapping too.
// ============================================================================
module smart_sensor_datapath_opt (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        enable,
    input  wire [7:0]  s0,
    input  wire [7:0]  s1,
    input  wire [7:0]  s2,
    input  wire [7:0]  s3,
    output reg  [19:0] result,
    output reg         valid,
    output wire [15:0] monitor_enable
);
    // Operator inference with minimum correct widths.
    wire [15:0] product0 = s0 * s1;
    wire [15:0] product1 = s2 * s3;

    wire [8:0] pair01 = s0 + s1;
    wire [8:0] pair23 = s2 + s3;

    // Constant multiplication by five using shift-add.
    wire [11:0] pair01_x5 = (pair01 << 2) + pair01;

    // Balanced adder tree.
    wire [16:0] product_sum = product0 + product1;
    wire [9:0]  sensor_sum  = pair01 + pair23;

    // Pipeline registers.
    reg [16:0] product_sum_reg;
    reg [9:0]  sensor_sum_reg;
    reg [11:0] weight_reg;
    reg        stage_valid;

    // Compact mapping functions for AOI/OAI/NAND/NOR.
    wire aoi_function = ~((s0[0] & s1[0]) | (s2[0] & s3[0]));
    wire oai_function = ~((s0[1] | s1[1]) & (s2[1] | s3[1]));
    wire nand_function = ~(s0[2] & s1[2]);
    wire nor_function  = ~(s2[2] | s3[2]);

    wire alarm_status =
        enable & (aoi_function | oai_function |
                  nand_function | nor_function);
    assign monitor_enable = {16{alarm_status}};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_sum_reg <= 17'd0;
            sensor_sum_reg  <= 10'd0;
            weight_reg      <= 12'd0;
            result          <= 20'd0;
            stage_valid     <= 1'b0;
            valid           <= 1'b0;
        end else begin
            // Register and MUX optimization: explicit enable style.
            if (start) begin
                product_sum_reg <= product_sum;
                sensor_sum_reg  <= sensor_sum;
                weight_reg      <= pair01_x5;
            end

            stage_valid <= start;
            valid       <= stage_valid;

            if (stage_valid)
                result <= product_sum_reg +
                          sensor_sum_reg +
                          weight_reg;
        end
    end
endmodule

// ============================================================================
// 4. LOW-POWER OPTIMIZED VERSION
// Same datapath with clock-gating candidates, operand isolation, data gating,
// grouped register banks, and isolation/retention behavioral controls.
// ============================================================================
module smart_sensor_low_power (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        enable,
    input  wire        power_on,
    input  wire        isolate,
    input  wire [7:0]  s0,
    input  wire [7:0]  s1,
    input  wire [7:0]  s2,
    input  wire [7:0]  s3,
    output reg  [19:0] result,
    output reg         valid,
    output wire [15:0] monitor_enable
);
    wire active = start & enable & power_on;

    // Operand isolation.
    wire [7:0] iso_s0 = active ? s0 : 8'd0;
    wire [7:0] iso_s1 = active ? s1 : 8'd0;
    wire [7:0] iso_s2 = active ? s2 : 8'd0;
    wire [7:0] iso_s3 = active ? s3 : 8'd0;

    wire [15:0] product0 = iso_s0 * iso_s1;
    wire [15:0] product1 = iso_s2 * iso_s3;
    wire [8:0] pair01 = iso_s0 + iso_s1;
    wire [8:0] pair23 = iso_s2 + iso_s3;
    wire [11:0] pair01_x5 = (pair01 << 2) + pair01;

    wire [16:0] product_sum = product0 + product1;
    wire [9:0] sensor_sum = pair01 + pair23;

    // Grouped register banks are MBFF candidates when the library supports them.
    reg [16:0] product_sum_reg;
    reg [9:0]  sensor_sum_reg;
    reg [11:0] weight_reg;
    reg [19:0] retained_result;
    reg        stage_valid;

    // Clock-gating inference candidate: registers update only when active.
    // Data gating: inactive data does not reach datapath registers.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_sum_reg <= 17'd0;
            sensor_sum_reg  <= 10'd0;
            weight_reg      <= 12'd0;
            stage_valid     <= 1'b0;
            retained_result <= 20'd0;
            valid           <= 1'b0;
        end else begin
            if (active) begin
                product_sum_reg <= product_sum;
                sensor_sum_reg  <= sensor_sum;
                weight_reg      <= pair01_x5;
            end

            stage_valid <= active;
            valid       <= stage_valid & power_on;

            // Behavioral retention: update only while powered and valid.
            if (stage_valid & power_on)
                retained_result <= product_sum_reg +
                                   sensor_sum_reg +
                                   weight_reg;
        end
    end

    // Behavioral isolation clamp.
    always @(*) begin
        if (isolate || !power_on)
            result = 20'd0;
        else
            result = retained_result;
    end

    wire alarm_status =
        enable & power_on &
        (~((s0[0] & s1[0]) | (s2[0] & s3[0])));
    assign monitor_enable =
        (isolate || !power_on) ? 16'd0 : {16{alarm_status}};
endmodule

// Alias used for the final all-optimized synthesis run.
module smart_sensor_all_opt (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire        enable,
    input  wire        power_on,
    input  wire        isolate,
    input  wire [7:0]  s0,
    input  wire [7:0]  s1,
    input  wire [7:0]  s2,
    input  wire [7:0]  s3,
    output wire [19:0] result,
    output wire        valid,
    output wire [15:0] monitor_enable
);
    smart_sensor_low_power u_final (
        .clk(clk), .rst_n(rst_n), .start(start), .enable(enable),
        .power_on(power_on), .isolate(isolate),
        .s0(s0), .s1(s1), .s2(s2), .s3(s3),
        .result(result), .valid(valid),
        .monitor_enable(monitor_enable)
    );
endmodule
