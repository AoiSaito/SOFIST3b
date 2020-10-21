//
// Module      : TB_PIXEL_CONTROL
// Ver.        : 20171016
// Last Update : 2017/10/16
// Author      : S.Ono
//

`timescale 1ps/1ps

module TB_PIXEL_CONTROL () ;


    reg  clk ;
    reg  nrst_x ;

    // input
    
    reg           en_all_ra ;
    //reg           pix_reset_en ;
    reg           pix_reset ;
    reg           pix_store ;
    reg           store_reset ;
    reg           comp_en_sel ;
    //reg           pix_reset_ext ;
    reg           mem_set_en ;
    reg           mem_set_clr ;
    reg           regout_en ;
    reg    [3:0]  read_mem  ;  
    reg           trg_mode ;
    reg           trg_det  ;
    reg           evt_num_end ;
    
    wire       cf_rst ;
    wire  	   cds_rst; 
    wire  	   rst_comp1;
    wire  	   rst_comp2;
    wire  	   comp_en; 
    wire       sel_rst_vth ;
    
    wire  	   pix_reset_busy ;
    //wire       en_all_ra ;
    wire  	   pix_end;
    wire       mem_set_done ;
    wire       aout_sel ;
    wire       tout_sel ;
    wire       regout_sel ;
    wire [2:0] colout_sel ;
    wire       last_mem ;
    
    // file output
    integer OpenFile ; 
        
    // pacameter
//    parameter CLK_CYCLE = 20000 ; // 50MHz
    parameter CLK_CYCLE = 40000 ; // 25MHz

    parameter DELAY = 1 ;
    
    // module assign
    PIXEL_CONTROL PIXEL_CONTROL (
                        .CLK(clk),
                        .NRST_X(nrst_x),
                        //.PIX_RESET_EN(pix_reset_en),
                        .PIX_RESET(pix_reset),
                        //.PIX_RESET_EXT(pix_reset_ext),                      
                        .PIX_STORE(pix_store),
                        .STORE_RESET(store_reset),
                        .COMP_EN_SEL(comp_en_sel),          
                        .MEM_SET_EN(mem_set_en),
                        .MEM_SET_CLR(mem_set_clr),
                        .REGOUT_EN(regout_en),
                        .READ_MEM(read_mem),
                        .TRG_MODE(trg_mode),
                        .TRG_DET(trg_det),
                        .EVT_NUM_END(evt_num_end),
                        .CF_RST(cf_rst),	 
			            .CDS_RST(cds_rst), 
			            .RST_COMP1(rst_comp1),
			            .RST_COMP2(rst_comp2),
			            .COMP_EN(comp_en), 
                        .SEL_RST_VTH(sel_rst_vth),
                        .PIX_RESET_BUSY(pix_reset_busy),
                        .SREG_IN(sreg_in),
                        .SREG_RST(sreg_rst),
			            .PIX_END(pix_end),
			            .MEM_SET_DONE(mem_set_done),
                        .AOUT_SEL(aout_sel),
                        .TOUT_SEL(tout_sel),
                        .REGOUT_SEL(regout_sel),
                        .COLOUT_SEL(colout_sel),
                        .LAST_MEM(last_mem)
    ) ;
                
         
    // clock 
    always #(CLK_CYCLE/2) begin
        clk <= !clk ;
    end

     // reset 
    initial begin
        nrst_x <= 1'b0 ;
        clk   <= 1'b1 ;
        
        #(CLK_CYCLE*2) nrst_x <= 1'b1 ;
    end 
    
 
    integer i ;
    // signal input
    initial begin
        //OpenFile = $fopen("TB_PIXEL_CONTROL_vector.txt") ;
 
        //en_all_ra   <= 1'b0 ;
        //pix_reset_en <= 1'b0 ;
        pix_reset   <= 1'b0 ;
        pix_store   <= 1'b0 ;
        store_reset <= 1'b0 ;
        comp_en_sel <= 1'b0 ;
        //pix_reset_ext  <= 1'b0 ;
        mem_set_en  <= 1'b0 ;
        mem_set_clr   <= 1'b0 ;
        regout_en   <= 1'b0 ;
        read_mem   <= 4'd0 ;
        trg_mode  <= 1'b0 ;
        trg_det   <= 1'b0 ;
        evt_num_end <= 1'b0 ;
        
        @(posedge nrst_x) ;
        #(CLK_CYCLE*5) ;
    
        //
        //
        // Pixel start
        
        //
        #DELAY ;
        pix_reset  <= 1'b0 ;
        comp_en_sel <= 1'b0 ;
        
        #(CLK_CYCLE*2) ;
        
        pix_reset <= 1'b1 ;
        pix_store  <= 1'b1 ;
        
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        #(CLK_CYCLE ) ;
        pix_reset <= 1'b0 ;
        

        #(CLK_CYCLE*75) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        pix_store  <= 1'b0 ;
        #(CLK_CYCLE*100) ;
        
        //
        //
        // Pixel start
        
        //
        pix_reset  <= 1'b0 ;
        pix_store  <= 1'b1 ;
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        #(CLK_CYCLE*75) ;
       
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        #(CLK_CYCLE*75) ;
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        pix_store <= 1'b0 ;
        #(CLK_CYCLE*100) ;
        
        
        
        //
        //
        // Pixel start
        comp_en_sel <= 1'b1 ;
        #(CLK_CYCLE) ;

        pix_reset  <= 1'b0 ;
        pix_store  <= 1'b1 ;
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;  
        #(CLK_CYCLE*75) ;

        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        #(CLK_CYCLE*75) ;
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        pix_store <= 1'b0 ;
        #(CLK_CYCLE*100) ;
        

        
        //
        //
        // Pixel start
        comp_en_sel <= 1'b0 ;
        #(CLK_CYCLE) ;

        pix_reset  <= 1'b0 ;
        pix_store  <= 1'b1 ;
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;  
        #(CLK_CYCLE*75) ;

        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        #(CLK_CYCLE*75) ;
        
        #(CLK_CYCLE) ;
        pix_reset <= 1'b1 ;
        #(CLK_CYCLE) ;
        pix_reset <= 1'b0 ;
        pix_store <= 1'b0 ;
        #(CLK_CYCLE*100) ;
            
        
        //
        //
        // Memory select
        read_mem  <= 4'd4 ;
        regout_en <= 1'b1 ;
        #(CLK_CYCLE*10) ;
        regout_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;

        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;
      
        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;
      
        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;

        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;

        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;

        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;

        //
        mem_set_clr <= 1'b1;
        #(CLK_CYCLE*5) ;
        mem_set_clr <= 1'b0 ;
        #(CLK_CYCLE*10) ;       
        
        mem_set_en <= 1'b1 ;
        #(CLK_CYCLE*5) ;
        mem_set_en <= 1'b0 ;
        #(CLK_CYCLE*10) ;
        
        $finish ;
    end 


    // Output
    initial begin
        $dumpfile("TB_PIXEL_CONTROL.vcd") ;
        $dumpvars( 0, TB_PIXEL_CONTROL ) ; 


    end 

endmodule // TB_PIXEL_CONTROL

