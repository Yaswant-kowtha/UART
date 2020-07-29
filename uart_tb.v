`timescale 1 ns/ 100 ps

module uart_tb;

reg clock;
reg reset;
reg transmit;
reg [7:0]  dataIn;
wire [7:0] dataOut;
wire txOutData;
wire txenable;
wire rxenable;

uart uart_tub(
	.clock(clock),
	.reset(reset),
	.transmit(transmit),
	.dataIn(dataIn),
	.dataOut(dataOut),
	.txOutData(txOutData),
	.txenable(txenable),
	.rxenable(rxenable)
);
localparam clockFrequency=50000000;
real clockTimePeriod=(1000000000/$itor(clockFrequency)); //time period in ns
integer i=0;
initial begin
	clock=1'b0;
	reset=1'b0;
	dataIn=8'b10111110;
	transmit=1;
	for(i=0;i<6000000;i=i+1) begin
		#(clockTimePeriod/2)
		clock=~clock;
		#(clockTimePeriod/2)
		clock=~clock;
	end
end
endmodule