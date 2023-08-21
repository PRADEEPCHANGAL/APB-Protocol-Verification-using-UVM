module AMBA_APB(PSEL,PENABLE,PADDR,PWRITE,PRESET,
                PWDATA,PCLK,PREADY,PRDATA);
  
  input  bit       PSEL;
  input  bit       PENABLE;
  input  bit [31:0]  PADDR;
  input  bit       PWRITE;
  input  bit [31:0]  PWDATA;
  input  bit       PCLK;
 // input  [3:0]  PSTRB;
  input  bit      PRESET; //Active low
  
  output reg  [31:0]  PRDATA;
  output reg         PREADY;
 // output reg         PSLVERR;
  

  
  parameter IDLE=2'b00;
  parameter SETUP=2'b01;
  parameter ACCESS=2'b10;
  
   
  reg [1:0]  ps,ns;
  reg [31:0]mem [31:0]; 
  
  always @(posedge PCLK)
    begin
      if(PRESET)
        ps = IDLE;
      else
        ps = ns;
    end
  
  always @(*)
    begin
      case(ps)
        IDLE:begin
            if(PSEL==1 & PENABLE==0)
              ns = SETUP;
            if(PSEL==0 & PENABLE==0)
              ns = IDLE;
              end
        SETUP:begin
            if(PSEL==1 & PENABLE==1) begin
              ns = ACCESS; 
              PREADY = 1;
              if(PWRITE) begin
                mem[PADDR] = PWDATA;
                end
              else begin
                PRDATA = mem[PADDR];
                end
              //ns = SETUP;
              
            end
             if(PSEL==0 & PENABLE==0)
              ns = IDLE;
          end
        ACCESS:begin
            if(PSEL==0 & PENABLE==0)
              ns = IDLE;
              PREADY = 0;
            if(PSEL==1 & PENABLE==1)
              ns=ACCESS;
             end
      endcase
    end
  
enmodule
