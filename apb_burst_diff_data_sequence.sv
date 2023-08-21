class apb_burst_diff_data_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_burst_diff_data_sequence)
  
   int last_addr;
   int WRITE_BURST_LENGTH = 8;
   int READ_BURST_LENGTH = 8;
   int DATA_SIZE[] ={8,16,24,32};
   int d,data_size;
  //constructor
  function new(string name = "apb_burst_diff_data_sequence");
    super.new(name);
  endfunction 
  
  virtual task body();
    apb_transaction write_trans;
    apb_transaction read_trans;
    
   
    //generate the write transaction 
    write_trans = apb_transaction::type_id::create("write_trans");
    write_trans.PADDR = $urandom_range(0,24);
    //write_trans.PWDATA = $urandom_range(5,50);
    
    last_addr = write_trans.PADDR;
       
   for (int i=1; i<=WRITE_BURST_LENGTH; i++) begin
    d = $urandom_range(0,3);
    data_size = DATA_SIZE[d];
    write_trans.PSEL = 1;
    write_trans.PWRITE = 1;
    write_trans.PENABLE = 1;  
    write_trans.PWDATA = $urandom_range(0,2**data_size-1);
	write_trans.PSTRB = (1<<(data_size/8))-1;
    start_item(write_trans);
  `uvm_info("WSEQUENCE",$sformatf("Write Transaction Generated: PRESET =%0d,PSEL =%0d, PWRITE =%0d, PENABLE =%0d, PSTRB =%0b, ADDR =%0d, PWDATA =%0d, data_size =%0d",write_trans.PRESET,write_trans.PSEL,write_trans.PWRITE,write_trans.PENABLE,write_trans.PSTRB,write_trans.PADDR,write_trans.PWDATA,data_size),UVM_LOW)
    finish_item(write_trans);        
    write_trans.PADDR++;
	#20;
   end
    
    //generate read transaction 
    read_trans = apb_transaction::type_id::create("read_trans");
    read_trans.PADDR = last_addr;
    
    for(int i=1; i<=READ_BURST_LENGTH; i++) begin
    read_trans.PRESET = 0;
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
