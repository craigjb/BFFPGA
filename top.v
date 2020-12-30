module TOP (
	LEDS,
	VCCINT_EN,
	VCCAUX_EN,
	VCCAUX_PG,
	VCCAUXIO_EN,
	VCCAUXIO_PG,
	VCC_MGTA_EN,
	VCC_MGTA_PG,
	VTT_MGTA_EN,
	VTT_MGTA_PG,
	VCCO_34_EN,
	VCCO_34_PG,
	VCCO_32_EN,
	VCCO_32_PG,
	VCCO_16_13_EN,
	VCCO_16_13_PG,
	VCCO_12_EN,
	VCCO_12_PG
);

output wire [3:0] LEDS;
output wire VCCINT_EN;
output wire VCCAUX_EN;
input wire VCCAUX_PG;
output wire VCCAUXIO_EN;
input wire VCCAUXIO_PG;
output wire VCC_MGTA_EN;
input wire VCC_MGTA_PG;
output wire VTT_MGTA_EN;
input wire VTT_MGTA_PG;
output wire VCCO_34_EN;
input wire VCCO_34_PG;
output wire VCCO_32_EN;
input wire VCCO_32_PG;
output wire VCCO_16_13_EN;
input wire VCCO_16_13_PG;
output wire VCCO_12_EN;
input wire VCCO_12_PG;

wire clk;

OSCH # (
	.NOM_FREQ("2.08")) mainclk (
	.STDBY(1'b0),
	.OSC(clk),
	.SEDSTDBY()
);

reg stage0 = 0;
wire stage0_pg;
reg stage1 = 0;
wire stage1_pg;
reg stage2 = 0;
wire stage2_pg;
reg stage3 = 0;
wire stage3_pg;
reg [14:0] counter = 15'h0;

always @ (posedge clk) begin
	counter <= counter + 1'h1;
	stage0 <= stage0;
	stage1 <= stage1;
	stage2 <= stage2;
	
	if (counter[14] == 1) begin
		counter <= 15'h0;
		
		if (stage2 && stage2_pg && !stage3) begin
			stage3 <= 1;
		end else if (stage1 && stage1_pg && !stage2) begin
			stage2 <= 1;
		end else if (stage0 && stage0_pg && !stage1) begin
			stage1 <= 1;
		end else if (!stage0) begin
			stage0 <= 1;
		end
	end
end

assign LEDS[0] = stage0_pg;
assign LEDS[1] = stage1_pg;
assign LEDS[2] = stage2_pg;
assign LEDS[3] = stage3_pg;

// STAGE 0
assign VCCINT_EN = stage0;
assign stage0_pg = 1;

// STAGE 1
assign VCCAUX_EN = stage1;
assign VCC_MGTA_EN = stage1;
assign stage1_pg = VCCAUX_PG && VCC_MGTA_PG;

// STAGE 2
assign VCCAUXIO_EN = stage2;
assign VTT_MGTA_EN = stage2;
assign stage2_pg = VCCAUXIO_PG && VTT_MGTA_PG;

// STAGE 3
assign VCCO_34_EN = stage3;
assign VCCO_32_EN = stage3;
assign VCCO_16_13_EN = stage3;
assign VCCO_12_EN = stage3;
assign stage3_pg = VCCO_34_PG && VCCO_32_PG && VCCO_16_13_PG && VCCO_12_PG;

endmodule

