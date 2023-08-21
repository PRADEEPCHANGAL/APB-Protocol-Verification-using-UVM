class apb_transaction extends uvm_sequence_item;
  
  `uvm_object_utils(apb_transaction)
  
  rand bit [31:0] PADDR;
  rand bit [31:0] PWDATA;
  
  bit PWRITE;
  bit PENABLE;
  bit PSEL;
  bit PRESET;
  bit [0:3] PSTRB; 
  bit [31:0] PRDATA;
  bit PSLVERR;
  bit PREADY;
 
  constraint c1{soft PADDR[31:0]>=32'd0; PADDR[31:0] <32'd32;};
 
  //Constructor
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction 
 
endclass
