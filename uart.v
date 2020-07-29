//top-level entity uart
module uart # (
	parameter baudRate=100,
	parameter clockFrequency=50000000
)(
	input clock,            //clock signal
	input reset,            //reset signal
	input transmit,			//transmitter starts transmitting when transmit is set to high
	input [7:0] dataIn,     //data input to transmitter
	output  txenable,			//enable signal for transmitter
	output  rxenable,       //enable signal for receiver
	output [7:0] dataOut,	//data received by receiver
	output txOutData        //data transmitted from transmitter
);

wire txDataOut;
wire rxDataIn;
//data transmitted from transmitter is received by receiver
assign rxDataIn=txDataOut;

frequencyDivider #(
	.baudRate(baudRate),
	.frequencyClock(clockFrequency)
	)frequencyDivider1 (
	.clock(clock),
	.reset(reset),
	.txenable1(txenable),
	.rxenable1(rxenable)
	);
transmitter tx(
	.enable(txenable),
	.reset(reset),
	.transmit(transmit),
	.txDataIn(dataIn),
	.txDataOut(txDataOut),
	.txOut(txOutData)
);
receiver rx(
	.enable(rxenable),
	.reset(reset),
	.rxDataIn(rxDataIn),
	.rxDataOut(dataOut)
);

endmodule



