interface apb_if();
  //Reset and clock
  bit PCLK;
  bit PRESET;
  
  bit PSEL;
  bit PENABLE;
  bit PWRITE;
  bit [0:3] PSTRB;
  logic [31:0] PADDR;
  
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  
  bit PREADY;
  bit PSLVERR; 
endinterface: apb_if 
