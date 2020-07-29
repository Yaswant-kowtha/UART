module receiver(
	input reset,
	input enable,
	input rxDataIn,						//input signal to receiver
	output reg [7:0] rxDataOut			//data received by receiver
);
integer count;
integer enableCount;
reg start;
reg stop;
reg startBit;

initial begin
	enableCount=0;
	count=0;
	start=1'b0;
	stop=1'b0;
	startBit=1'b0;
	rxDataOut=8'b00000000;
end
//data is received 8 bits at a time. 
//if bit received is low, data is received.
//if signal received after 8th data bit is high, receiver stops receiving data.
always @ (posedge enable) begin
	if(reset==1'b1) begin
		start=1'b0;
		count=0;
		enableCount=0;
	end
	else begin
		enableCount=enableCount+1;
		//executed when a low signal is received to start receiving
		if(rxDataIn==1'b0 && stop==1'b0 && start==1'b0) begin
			start=1'b1;
			enableCount=1;
		end
		//first low signal which marks start of transmission is not considered as data bit
		else if(startBit==1'b0 && start==1'b1) begin
		
			if(enableCount==8) begin
				startBit=1'b1;
				enableCount=0;
			end
		end
		else if(start==1'b1 && stop==1'b0 && startBit==1'b1) begin
		
		//sample data at half time period of each bit
			if(enableCount==4) begin
				if(count==8 && rxDataIn==1'b1) begin
					stop=1'b1;
					count=0;
				end
				if(stop==1'b0) begin
					rxDataOut[count]=rxDataIn;
					count=count+1;
				end
			end
		end
		if(enableCount==8) begin
			enableCount=0;
		end

	end
end
endmodule