// Code your design here
module asyncfifo(
                write_clk,
                read_clk ,//input clk
                reset,    //input reset
                write_en,//input write enable
                read_en,//input read enable
                data_in,//input data
                full,//output if the memory is full 
                empty,//output if the memory is 
  				out//output out
                );

//port declarations
input            write_clk,read_clk,reset,write_en,read_en;
input      [7:0] data_in;
output           full,empty;
output reg [7:0] out;

//reg declarations
reg [7:0] memory_vec   [0:7];//memory of 8 * 8 
reg [3:0] write_pointer;//write pointer
reg [3:0] read_pointer;//read pointer;
  

assign full  = (write_pointer[3]==1 && read_pointer[3]==0 && write_pointer[2:0]==read_pointer[2:0]);//assign full to 8
assign empty = (write_pointer ==read_pointer);


always @ (posedge write_clk or negedge reset)
   begin
      if(!reset)
         begin
            write_pointer <= 4'b0;//reset write pointer
         end
      else
         begin
            if(write_en == 1 && !full)
               begin
                  memory_vec   [write_pointer[2:0]] <=  data_in ;//data is written to the location
                  write_pointer <=  write_pointer + 1'b1 ;//increment pointer
               end
         end
    end


always @ (posedge read_clk or negedge reset)
   begin
      if(!reset)
         begin
            read_pointer <= 4'b0  ;//reset read pointer
         end
      else
         begin
            if(read_en == 1 && !empty)
               begin
                  out  <=  memory_vec[read_pointer[2:0]];//data is read from the pointer location
                  read_pointer <=  read_pointer + 1'b1;//increment read pointer
               end
         end
    end
endmodule