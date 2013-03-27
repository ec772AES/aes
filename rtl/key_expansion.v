//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module key_expansion(
        input                   clk,            /* clock */
        input           rst,            /* reset line -- high active */
        input           key_in_valid,   /* valid input key at key_in */
        input  [1:0]    key_in_type,    /* type of input key at key_in */
        input  [127:0]  key_in,         /* input key I ASSUME bit0 is the first bit received and bit 128 the last one.*/
        output [127:0]  key_out,        /* output to register's in Ben's design */
        output reg [3:0] key_addr,       /* 1,...,11 for 11 keys, 0 nonvalid addr */
        output reg       key_loaded);    /* key completely loaded */

        localparam TYPE_KEY = 2'b10;
        localparam READY    = 4'd0,
                   ROUND_1  = 4'd1,
                   ROUND_2  = 4'd2,
                   ROUND_3  = 4'd3,
                   ROUND_4  = 4'd4,
                   ROUND_5  = 4'd5,
                   ROUND_6  = 4'd6,
                   ROUND_7  = 4'd7,
                   ROUND_8  = 4'd8,
                   ROUND_9  = 4'd9,
                   ROUND_10 = 4'd10,
                   ROUND_11 = 4'd11,
                   DONE     = 4'd12;

        /* four bits for state */
        reg  [3:0]  state, next;
        wire [3:0]  rcon_addr;
        wire [31:0] rcon_out;
        reg load_enable;
        
        /* note that rcon_addr is not always key_addr - 1 */
        assign rcon_addr = key_addr;

        /* shift to next state allow for async reset */
        always @(posedge clk or posedge rst)
          if (rst)
            state <= READY;
          else begin
            state <= next;
          end

        /* next state combinational logic */
        always @(state or key_in_valid or key_in_type) begin
          next        = READY;
          load_enable = 'b0;
          key_loaded  = 'b0;
          key_addr    = 4'd0;
          case (state)
            READY : if (key_in_valid & (key_in_type == TYPE_KEY)) begin
                      next = ROUND_1;
                      load_enable = 'b1;
                    end else
                      next = READY;
            ROUND_1 : begin
                        next     = ROUND_2; /* 1st key ready */
                        key_addr = 4'd1;
                      end
            ROUND_2 : begin
                        next      = ROUND_3; /* 2nd key ready */
                        key_addr  = 4'd2;
                      end
            ROUND_3 : begin
                        next      = ROUND_4; /* 3rd key ready */
                        key_addr  = 4'd3;
                      end
            ROUND_4 : begin
                        next      = ROUND_5; /* 4th key ready */
                        key_addr  = 4'd4;
                      end
            ROUND_5 : begin
                        next      = ROUND_6; /* 5th key ready */
                        key_addr  = 4'd5;
                      end
            ROUND_6 : begin
                        next      = ROUND_7; /* 6th key ready */
                        key_addr  = 4'd6;
                      end
            ROUND_7 : begin
                        next      = ROUND_8; /* 7th key ready */
                        key_addr  = 4'd7;
                      end
            ROUND_8 : begin
                        next      = ROUND_9; /* 8th key ready */
                        key_addr  = 4'd8;
                      end
            ROUND_9 : begin
                        next      = ROUND_10; /* 9th key ready */
                        key_addr  = 4'd9;
                      end
            ROUND_10 : begin
                        next      = ROUND_11; /* 10th key ready */
                        key_addr  = 4'd10;
                      end
            ROUND_11 : begin
                        next      = DONE;     /* 11th key ready */
                        key_addr  = 4'd11;
                      end
            DONE : begin
                    next = DONE;
                    key_loaded = 'b1;
                   end
          endcase
        end

        rcon u_rcon(
                    .clk(clk),
                    .addr(rcon_addr),
                    .dout(rcon_out));

        key_expansion_logic u_key_expansion_logic(
                                        .clk(clk),
                                        .rst(rst),
                                        .load_enable(load_enable),
                                        .key_in(key_in),
                                        .rcon_in(rcon_out),
                                        .key_out(key_out));

endmodule