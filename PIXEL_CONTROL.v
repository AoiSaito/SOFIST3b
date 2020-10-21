//
// Module      : PIXEL_CONTROL
// Ver.        : 20190127
// Last Update : 2019/01/27
// Author      : S.Ono
// Comment     : Add External trigger mode (TRG_MODE)
//


/* verilator lint_off ASSIGNDLY */
/* verilator lint_off UNSIGNED */

`timescale 1ps/1ps
`define DELAY_UNIT 1 

module PIXEL_CONTROL (
                        CLK,
                        NRST_X,
                        EN_ALL_RA,
                        PIX_RESET,
                        PIX_STORE,
                        STORE_RESET,
                        COMP_EN_SEL,
                        MEM_SET_EN,
                        MEM_SET_CLR,
                        REGOUT_EN,
                        READ_MEM,
                        TRG_MODE,
                        TRG_DET,
                        EVT_NUM_END,
                        CF_RST,     
                        CDS_RST, 
                        RST_COMP1,
                        RST_COMP2,
                        COMP_EN, 
                        SEL_RST_VTH,
                        PIX_RESET_BUSY,
                        SREG_IN,
                        SREG_RST,
                        PIX_END,
                        MEM_SET_DONE,
                        AOUT_SEL,
                        TOUT_SEL,
                        REGOUT_SEL,
                        COLOUT_SEL,
                        LAST_MEM
                   ) ;
             
    input         CLK ; // 25 MHz
    input         NRST_X ;
    
    input         EN_ALL_RA ;
    input         PIX_RESET ;
    input         PIX_STORE ;
    input         STORE_RESET ;
    input         COMP_EN_SEL ;
    input         MEM_SET_EN ;
    input         MEM_SET_CLR ;
    input         REGOUT_EN ;
    input   [3:0] READ_MEM ;
    input         TRG_MODE ;
    input         TRG_DET  ;
    input         EVT_NUM_END ;
    
    output        CF_RST ;
    output        CDS_RST; 
    output        RST_COMP1;
    output        RST_COMP2;
    output        COMP_EN;  
    output        SEL_RST_VTH ;
    
    output        PIX_RESET_BUSY ;
    output        SREG_IN ;
    output        SREG_RST ;
    output        PIX_END ;
    
    output        MEM_SET_DONE ;
    output        AOUT_SEL ;
    output        TOUT_SEL ;
    output        REGOUT_SEL ;
    output  [2:0] COLOUT_SEL ;
    output        LAST_MEM ;
    
    
    reg          pix_run_en_r;
    reg          pix_end_r;

    reg          cf_rst_r;
    reg          cds_rst_r;
    reg          rst_comp1_r;
    reg          rst_comp2_r;
    reg          comp_en_always_r;
    //reg          comp_en_sync_r ;
    reg          rst_vth_r ;
    
    reg   [7:0]  pix_cnt_r; //  40n x 256 = 10180 ns
    reg          comp_en_mask_r ;
    reg          mem_set_r ;
    reg   [3:0]  mem_set_cnt_r ;
    reg          mem_set_end_r ;
    reg          pix_store_r ;
    
    wire         pix_reset_mask ;
    wire         reset_start ;
    wire  [2:0]  colout_dec ;
    //wire         last_mem ;
    wire  [3:0]  last_mem_cnt ;
    wire         mem_set_pedge ;
    
    wire         pix_store_pedge ;

    wire         comp_en_sync ;
 
    parameter DELAY = `DELAY_UNIT ;  

    // Timing chart
    /*
    // short chart: 440ns
    parameter CF_RST_START = 8'd0 ; // 0 ns
    parameter CF_RST_WIDTH = 8'd3 ; // 120 ns 
    
    parameter CF_RST_END = CF_RST_START + CF_RST_WIDTH;

    parameter RST_COMP1_WIDTH = 8'd4 ; // 160 ns
    parameter RST_COMP1_END   = CF_RST_START + RST_COMP1_WIDTH;
 
    parameter RST_COMP2_WIDTH = 8'd5 ; // 200 ns
    parameter RST_COMP2_END   = CF_RST_START + RST_COMP2_WIDTH;

    parameter RST_VTH_WIDTH   = 8'd6 ; // 240 ns
    parameter RST_VTH_END     = CF_RST_START + RST_VTH_WIDTH ;

    parameter CDS_RST_WIDTH   = 8'd11 ; // 440 ns
    parameter CDS_RST_END     = CF_RST_START + CDS_RST_WIDTH; 
    */
    /*
    // short chart: 720ns
    parameter CF_RST_START = 8'd0 ; // 0 ns
    parameter CF_RST_WIDTH = 8'd5 ; // 200 ns
    parameter CF_RST_END = CF_RST_START + CF_RST_WIDTH;

    parameter RST_COMP1_WIDTH = 8'd6 ; // 240 ns
    parameter RST_COMP1_END   = CF_RST_START + RST_COMP1_WIDTH;
 
    parameter RST_COMP2_WIDTH = 8'd7 ; // 280 ns
    parameter RST_COMP2_END   = CF_RST_START + RST_COMP2_WIDTH;

    parameter RST_VTH_WIDTH   = 8'd8 ; // 320 ns
    parameter RST_VTH_END     = CF_RST_START + RST_VTH_WIDTH ;

    parameter CDS_RST_WIDTH   = 8'd18 ; // 720 ns
    parameter CDS_RST_END     = CF_RST_START + CDS_RST_WIDTH; 
   
*/
   
    // long chart: 1400ns
    
    parameter CF_RST_START = 8'd0; // 
    parameter CF_RST_WIDTH = 8'd10; // 400ns
    parameter CF_RST_END = CF_RST_START + CF_RST_WIDTH;

    parameter RST_COMP1_WIDTH = 8'd15; // 600 ns
    parameter RST_COMP1_END   = CF_RST_START + RST_COMP1_WIDTH;
 
    parameter RST_COMP2_WIDTH = 8'd20; // 800 ns
    parameter RST_COMP2_END   = CF_RST_START + RST_COMP2_WIDTH;

    parameter RST_VTH_WIDTH   = 8'd25; // 1000 ns
    parameter RST_VTH_END     = CF_RST_START + RST_VTH_WIDTH ;

    parameter CDS_RST_WIDTH   = 8'd35; // 1400 ns
    parameter CDS_RST_END     = CF_RST_START + CDS_RST_WIDTH; 
    
   
  /*
    // long long chart: 2100ns
    
    parameter CF_RST_START = 8'd0; // 
    parameter CF_RST_WIDTH = 8'd15; // 600ns
    parameter CF_RST_END = CF_RST_START + CF_RST_WIDTH;

    parameter RST_COMP1_WIDTH = 8'd22; // 880 ns
    parameter RST_COMP1_END   = CF_RST_START + RST_COMP1_WIDTH;
 
    parameter RST_COMP2_WIDTH = 8'd30; // 1200 ns
    parameter RST_COMP2_END   = CF_RST_START + RST_COMP2_WIDTH;

    parameter RST_VTH_WIDTH   = 8'd37; // 1480 ns
    parameter RST_VTH_END     = CF_RST_START + RST_VTH_WIDTH ;

    parameter CDS_RST_WIDTH   = 8'd52; // 2080 ns
    parameter CDS_RST_END     = CF_RST_START + CDS_RST_WIDTH; 
    */
  

/*
    parameter COMP_EN_START   = 8'd97 ; // 3880 ns
    parameter COMP_EN_WIDTH   = 8'd1  ; // 40 ns
    parameter COMP_EN_END     = COMP_EN_START + COMP_EN_WIDTH; 
*/     
    
    parameter PIX_END_START   = CDS_RST_END ; 
    parameter PIX_END_WIDTH   = 8'd1  ; // 40 ns
    parameter PIX_END_END     = PIX_END_START + PIX_END_WIDTH;

    //parameter N_READ_MEM      = 4'd2 ; // number of read memories
    
    //    
    // STORE and reset
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            pix_store_r <= #DELAY 1'b0 ;
        else 
            pix_store_r <= #DELAY PIX_STORE ;
    end
    
    assign #DELAY pix_store_pedge = PIX_STORE & ~pix_store_r ;


    assign #DELAY pix_reset_mask = PIX_RESET & PIX_STORE & ~PIX_RESET_BUSY ; 
    assign #DELAY reset_start    = pix_reset_mask | ( TRG_MODE & pix_store_pedge ) ; 
    
    //
    // Pixel run and Counter
    
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            pix_run_en_r <= #DELAY 1'b0;
        else if( reset_start )
            pix_run_en_r <= #DELAY 1'b1;
        else if( PIX_END )
            pix_run_en_r <= #DELAY 1'b0;
    end
    
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            pix_cnt_r <= #DELAY 8'd0;
        else if(pix_run_en_r)
            pix_cnt_r <= #DELAY pix_cnt_r + 8'd1;
        else
            pix_cnt_r <= #DELAY 8'd0;
    end


    // CF_RST

    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            cf_rst_r <= #DELAY 1'd0;
        else if(pix_cnt_r >= CF_RST_START && pix_cnt_r < CF_RST_END && pix_run_en_r)
            cf_rst_r <= #DELAY 1'd1;
        else
            cf_rst_r <= #DELAY 1'd0;
    end


    // RST_COMP1

    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            rst_comp1_r <= #DELAY 1'd0;
        else if(pix_cnt_r >= CF_RST_START && pix_cnt_r < RST_COMP1_END && pix_run_en_r && !TRG_MODE )
            rst_comp1_r <= #DELAY 1'd1;
        else
            rst_comp1_r <= #DELAY 1'd0;
    end


    // RST_COMP2

    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            rst_comp2_r <= #DELAY 1'd0;
        else if(pix_cnt_r >= CF_RST_START && pix_cnt_r < RST_COMP2_END && pix_run_en_r && !TRG_MODE )
            rst_comp2_r <= #DELAY 1'd1;
        else
            rst_comp2_r <= #DELAY 1'd0;
    end

    // SEL_RST_VTH 
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            rst_vth_r <= #DELAY 1'd1 ;
        else if(pix_cnt_r >= CF_RST_START && pix_cnt_r < RST_VTH_END  && pix_run_en_r && !TRG_MODE )
            rst_vth_r <= #DELAY 1'd0 ;
        else
            rst_vth_r <= #DELAY 1'd1 ;
    end    


    // CDS_RST

    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            cds_rst_r <= #DELAY 1'd0;
        else if(pix_cnt_r >= CF_RST_START && pix_cnt_r < CDS_RST_END && pix_run_en_r)
            cds_rst_r <= #DELAY 1'd1;
        else
            cds_rst_r <= #DELAY 1'd0;
    end


    // COMP_EN 
        
    // COMP EN always on when not CDS_RST
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            comp_en_always_r <= #DELAY 1'd0;
 /*       else if ( COMP_EN_SEL && !TRG_MODE ) begin
            if ( pix_cnt_r == CDS_RST_END && PIX_STORE )
                comp_en_always_r <= #DELAY 1'd1;
            else if ( PIX_RESET && ~pix_run_en_r )
                comp_en_always_r <= #DELAY 1'd0;        
        end*/
        else if ( pix_cnt_r == CDS_RST_END && PIX_STORE )
                comp_en_always_r <= #DELAY 1'd1;
        else if ( PIX_RESET && ~pix_run_en_r )
                comp_en_always_r <= #DELAY 1'd0;        
    end

    
    //COMP_EN pulse with reset sync
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            comp_en_mask_r <= #DELAY 1'b0 ;
        else if ( ~PIX_STORE )
            comp_en_mask_r <= #DELAY 1'b0 ;    
        else if ( reset_start )
            comp_en_mask_r <= #DELAY 1'b1 ;
    end

    /*
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            comp_en_sync_r <= #DELAY 1'd0;
        else if ( !COMP_EN_SEL || TRG_MODE  ) begin
            if ( comp_en_mask_r & pix_reset_mask )
                comp_en_sync_r <= #DELAY 1'd1;
            else 
                comp_en_sync_r <= #DELAY 1'd0;        
        end
    end
    */
    
    //assign #DELAY comp_en_sync = ( !COMP_EN_SEL || TRG_MODE ) ? comp_en_mask_r & pix_reset_mask : 1'b0 ;
    assign #DELAY comp_en_sync = comp_en_mask_r & pix_reset_mask ;


    // PIX_END
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            pix_end_r <= #DELAY 1'b0;
        else if(pix_cnt_r >= PIX_END_START && pix_cnt_r < PIX_END_END && pix_run_en_r)
            pix_end_r <= #DELAY 1'b1;
        else
            pix_end_r <= #DELAY 1'b0;
    end

    //
    // Readout memory
    // mem_set_cnt_r[0]; 0:AOUT, 1:TOUT
    //    if REG_OUT_EN = High, AOUT/TOUT_SEL = Low
    // mem_set_cnt_r[2:1]; COLOUT_SEL
    
    
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            mem_set_r <= #DELAY 1'b0 ;
        else 
            mem_set_r <= #DELAY MEM_SET_EN ;
    end
  
    assign #DELAY mem_set_pedge = MEM_SET_EN & ~mem_set_r ;
    
    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            mem_set_cnt_r <= #DELAY 4'd0 ;
        else if ( MEM_SET_CLR )
            mem_set_cnt_r <= #DELAY 4'd0 ;
        else if ( mem_set_pedge && !LAST_MEM ) 
            mem_set_cnt_r <= #DELAY mem_set_cnt_r + 4'd1 ;
    end

    always @(posedge CLK or negedge NRST_X) begin
        if(!NRST_X)
            mem_set_end_r <= #DELAY 1'b0 ;
        else 
        
        
        
            mem_set_end_r <= #DELAY mem_set_pedge ;
    end

    // Last number of Memory counter 
//    assign #DELAY last_mem_cnt = ( TRG_MODE == 1'b1 ) ? 1'b0 : 
//                                 ( READ_MEM != 4'd0 ) ? READ_MEM - 4'd1 : 4'd0 ;    
    assign #DELAY last_mem_cnt = ( READ_MEM != 4'd0 ) ? READ_MEM - 4'd1 : 4'd0 ;     

    assign #DELAY colout_dec = ( mem_set_cnt_r[2:1] == 2'd0 ) ? 3'b001 :
                               ( mem_set_cnt_r[2:1] == 2'd1 ) ? 3'b010 :
                               ( mem_set_cnt_r[2:1] == 2'd2 ) ? 3'b100 : 3'b000 ;
    
    
    //
    // Output

    assign #DELAY CF_RST      = ( PIX_STORE ) ? cf_rst_r  : 1'b1 ; 
    assign #DELAY CDS_RST     = ( PIX_STORE ) ? cds_rst_r : 1'b1 ; 
    assign #DELAY RST_COMP1   = ( PIX_STORE & rst_comp1_r ) ;
    assign #DELAY RST_COMP2   = ( PIX_STORE & rst_comp2_r ) ;
    assign #DELAY SEL_RST_VTH = ( PIX_STORE ) ? rst_vth_r : 1'b1 ;
    //assign #DELAY COMP_EN     = ( COMP_EN_SEL && !TRG_MODE ) ? comp_en_always_r : comp_en_sync_r ;
    assign #DELAY COMP_EN     = ( TRG_MODE == 1'b1 ) ? TRG_DET & comp_en_sync & ~EVT_NUM_END :
                                ( COMP_EN_SEL ) ? comp_en_always_r : comp_en_sync ;
                                
    assign #DELAY PIX_RESET_BUSY   = pix_run_en_r;
    assign #DELAY PIX_END      = pix_end_r;
    assign #DELAY SREG_IN      = 1'b1 ;
    assign #DELAY SREG_RST     = STORE_RESET ;
    assign #DELAY AOUT_SEL     = ( mem_set_cnt_r[0] == 1'b0 ) & ~REGOUT_EN ;
    assign #DELAY TOUT_SEL     = ( mem_set_cnt_r[0] == 1'b1 ) & ~REGOUT_EN ;
    assign #DELAY REGOUT_SEL   = REGOUT_EN ;
    assign #DELAY COLOUT_SEL   = colout_dec ;
    assign #DELAY MEM_SET_DONE = mem_set_end_r ;
    assign #DELAY LAST_MEM     = ( mem_set_cnt_r == last_mem_cnt ) ;
    
endmodule // PIXEL_CONTROL