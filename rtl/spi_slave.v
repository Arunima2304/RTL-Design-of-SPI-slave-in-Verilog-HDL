module spi_slave #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  rst,

    input  wire                  cs,
    input  wire                  sclk,
    input  wire                  mosi,

    input  wire [DATA_WIDTH-1:0] tx_data,

    input  wire                  cpol,
    input  wire                  cpha,

    output reg                   miso,
    output reg [DATA_WIDTH-1:0]  rx_data,
    output reg                   rx_valid
);


    // Synchronizer registers

    reg sclk_meta;
    reg sclk_sync;
    reg sclk_prev;

    reg cs_meta;
    reg cs_sync;
    reg cs_prev;

    reg mosi_meta;
    reg mosi_sync;


    // SPI configuration registers


    reg cpol_reg;
    reg cpha_reg;


    // SPI data registers


    reg [DATA_WIDTH-1:0] rx_shift;
    reg [DATA_WIDTH-1:0] tx_shift;

    reg [3:0] bit_count;



    // Synchronizing SCLK, CS and MOSI


    always @(posedge clk or posedge rst) begin

        if (rst) begin

            sclk_meta <= 1'b0;
            sclk_sync <= 1'b0;
            sclk_prev <= 1'b0;

            cs_meta   <= 1'b1;
            cs_sync   <= 1'b1;
            cs_prev   <= 1'b1;

            mosi_meta <= 1'b0;
            mosi_sync <= 1'b0;

        end

        else begin

            sclk_meta <= sclk;
            sclk_sync <= sclk_meta;
            sclk_prev <= sclk_sync;

            cs_meta   <= cs;
            cs_sync   <= cs_meta;
            cs_prev   <= cs_sync;

            mosi_meta <= mosi;
            mosi_sync <= mosi_meta;

        end

    end


    wire sclk_rising;
    wire sclk_falling;

    assign sclk_rising  =  sclk_sync & ~sclk_prev;
    assign sclk_falling = ~sclk_sync &  sclk_prev;


    wire cs_start;

    assign cs_start = cs_prev & ~cs_sync;


    wire sample_on_rising;
    wire sample_on_falling;

    assign sample_on_rising  = (cpol_reg == cpha_reg);
    assign sample_on_falling = (cpol_reg != cpha_reg);

    //SPI logic

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            rx_shift  <= {DATA_WIDTH{1'b0}};
            tx_shift  <= {DATA_WIDTH{1'b0}};

            rx_data   <= {DATA_WIDTH{1'b0}};

            bit_count <= 4'd0;

            rx_valid  <= 1'b0;

            miso      <= 1'b0;

            cpol_reg  <= 1'b0;
            cpha_reg  <= 1'b0;

        end

        else begin


            rx_valid <= 1'b0;

            //SPI transaction start


            if (cs_start) begin

                cpol_reg <= cpol;
                cpha_reg <= cpha;

                rx_shift <= {DATA_WIDTH{1'b0}};

                bit_count <= 4'd0;

                tx_shift <= tx_data;


                if (cpha == 1'b0) begin

                    miso <= tx_data[DATA_WIDTH-1];

                    tx_shift <= {
                        tx_data[DATA_WIDTH-2:0],
                        1'b0
                    };

                end

                else begin

                    miso <= 1'b0;

                end

            end

            else if (cs_sync == 1'b0) begin


                if (
                    (sclk_rising && sample_on_rising) ||
                    (sclk_falling && sample_on_falling)
                ) begin
                    rx_shift <= {
                        rx_shift[DATA_WIDTH-2:0],
                        mosi_sync
                    };


                    if (bit_count == DATA_WIDTH-1) begin

                        rx_data <= {
                            rx_shift[DATA_WIDTH-2:0],
                            mosi_sync
                        };

                        rx_valid <= 1'b1;

                        bit_count <= 4'd0;

                    end

                    else begin

                        bit_count <= bit_count + 1'b1;

                    end

                end

                if (
                    (sclk_rising && !sample_on_rising) ||
                    (sclk_falling && !sample_on_falling)
                ) begin

                    miso <= tx_shift[DATA_WIDTH-1];

                    tx_shift <= {
                        tx_shift[DATA_WIDTH-2:0],
                        1'b0
                    };

                end

            end

            else begin

                miso <= 1'b0;

            end

        end

    end

endmodule


// This SPI slave uses a faster system clock clk to synchronize and detect transitions of the external SPI clock sclk
