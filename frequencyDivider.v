module frequencyDivider #(
	parameter frequencyClock=50000000,
	parameter baudRate=100
)(
	input clock,
	input reset,
	output txenable1,					//output transmitter enable signal
	output rxenable1					//output receiver enable signal
);
integer txCountMax=(frequencyClock/baudRate);
integer rxCountMax;
reg txDividedClock;		//enable signal for transmitter
reg rxDividedClock;		//enable signal for receiver
//frequency of receiver enable signal is 8 times the frequency of transmitter enable signal
initial begin
	rxCountMax=(txCountMax/8);	
end
assign txenable1=txDividedClock;
assign rxenable1=rxDividedClock;
integer txCount;
integer rxCount;						

initial begin
	txCount=0;
	rxCount=0;
end
//number of positive edges of clock are counted and 
//enable signals are set according to count values
always @ (posedge clock) begin
	if(reset) begin
		txCount=0;
		rxCount=0;
	end
	else begin
		if(txCount<=(txCountMax/2)) begin
			txDividedClock=1'b1;
		end
		else if(txCount>(txCountMax/2)) begin
			txDividedClock=1'b0;
		end
		txCount=txCount+1;
		if(txCount==txCountMax) begin
			txCount=0;
		end
		if(rxCount<=(rxCountMax/2)) begin
			rxDividedClock=1'b1;
		end
		else if(rxCount>(rxCountMax/2)) begin
			rxDividedClock=1'b0;
		end
		rxCount=rxCount+1;
		if(rxCount==rxCountMax) begin
			rxCount=0;
		end
	end
end

endmodule
	