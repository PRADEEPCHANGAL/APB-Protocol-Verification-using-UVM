class apb_max_burst_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_max_burst_sequence)
  
   int WRITE_BURST_LENGTH = 32;
   int READ_BURST_LENGTH = 32;
  //constructor
  function new(string name = "apb_max_burst_sequence");
    super.new(name);
  endfunction 
  
  virtual task body();
    apb_transaction write_trans;
    apb_transaction read_trans;
    
   
    //generate the write transaction 
    write_trans = apb_transaction::type_id::create("write_trans");
    write_trans.PADDR = 0;
    //write_trans.PWDATA = $urandom_range(5,50);
    
       
   for (int i=1; i<=WRITE_BURST_LENGTH; i++) begin
    write_trans.PSEL = 1;
    write_trans.PWRITE = 1;
    write_trans.PENABLE = 1;  
    write_trans.PWDATA = $urandom;
     
    start_item(write_trans);
  `uvm_info("WSEQUENCE",$sformatf("Write Transaction Generated: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PWDATA =%0d ", write_trans.PRESET,write_trans.PSEL,write_trans.PWRITE,write_trans.PENABLE,write_trans.PADDR,write_trans.PWDATA),UVM_LOW)
    finish_item(write_trans);
   
     
    write_trans.PADDR++; 
   end
    
    //generate read transaction 
    read_trans = apb_transaction::type_id::create("read_trans");
    read_trans.PADDR = 0;
    
    for(int i=1; i<=READ_BURST_LENGTH; i++) begin
    read_trans.PSEL = 1;
    read_trans.PWRITE = 0;
    read_trans.PENABLE = 1;
     
    start_item(read_trans);
    `uvm_info("RSEQUENCE",$sformatf("Read Transaction Generated: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d ", read_trans.PRESET,read_trans.PSEL,read_trans.PWRITE,read_trans.PENABLE,read_trans.PADDR),UVM_LOW)
    finish_item(read_trans);
    
      
    read_trans.PADDR++;
    end
      endtask
endclass
