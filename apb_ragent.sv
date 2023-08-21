class apb_ragent extends uvm_agent;
  `uvm_component_utils(apb_ragent)
 
  apb_rmonitor  rmon;
  
  
  
  //constructor
  function new(string name = "apb_ragent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rmon = apb_rmonitor::type_id::create("rmon",this);
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
endclass
