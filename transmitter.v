module transmitter(
	input reset,
	input enable,
	input transmit, 			//transmission start when transmit bit is set high
	input [7:0] txDataIn,	//input data to be transmitted
	output reg txDataOut,   //data sent to receiver
	output txOut				//transmitted data to verify transmission 
);

reg start;
reg stop;
integer count;
reg transmitprev;
reg prevEnable;

initial begin
	start=1'b0;
	stop=1'b0;
	txDataOut=1'b1;			//trasmitted signal is set to high initially
	count=0;						//counter for enable clock cycles
end
assign txOut=txDataOut;

always @ (posedge enable) begin
	if(reset==1'b1) begin
		txDataOut=1'b1;
		start=1'b0;
		count=0;
	end
	else begin
		if(transmit==1'b1 && start==1'b0 && stop==1'b0) begin
			txDataOut=1'b0;		//transmitted signal is set to low for first cycle of enable
			count=0;
			start=1;	
		end	
		//each bit is transmitted on every clock cycle
		else if(start==1'b1 && count<8) begin
			txDataOut=txDataIn[count];
			count=count+1;
		end
		if(start==1'b1 && count==8) begin
			start=0;
			stop=1;
			count=count+1;
		end
		//when all bits are transmitted output signal is set to high
		if(count>8) begin
			txDataOut=1'b1;
		end
	end
end	

endmodule