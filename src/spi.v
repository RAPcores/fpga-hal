
module spi #(
    parameter arch = "ice40",
    parameter mode = 0
)(
    input clk,
    input sck

);

   //hw spi signals
   reg spi_stb; //strobe must be set to high when read or write
   reg spi_rw; //selects read or write (high = write)
   reg [7:0] spi_adr; // address
   reg [7:0] spi_dati; // data input
   wire [7:0] spi_dato; // data output
   wire spi_ack; //ack that the transfer is done (read valid or write ack)
   //the miso/mosi signals are not used, because this module is set as a slave
   wire spi_miso;
   wire spi_mosi;
   wire spi_sck;
   wire spi_csn;

    if (arch == "ice40") begin
        SB_SPI SB_SPI_inst(.SBCLKI(clk), .SBSTBI(spi_stb), .SBRWI(spi_rw),
            .SBADRI0(spi_adr[0]), .SBADRI1(spi_adr[1]), .SBADRI2(spi_adr[2]), .SBADRI3(spi_adr[3]), .SBADRI4(spi_adr[4]), .SBADRI5(spi_adr[5]), .SBADRI6(spi_adr[6]), .SBADRI7(spi_adr[7]),
            .SBDATI0(spi_dati[0]), .SBDATI1(spi_dati[1]), .SBDATI2(spi_dati[2]), .SBDATI3(spi_dati[3]), .SBDATI4(spi_dati[4]), .SBDATI5(spi_dati[5]), .SBDATI6(spi_dati[6]), .SBDATI7(spi_dati[7]),
            .SBDATO0(spi_dato[0]), .SBDATO1(spi_dato[1]), .SBDATO2(spi_dato[2]), .SBDATO3(spi_dato[3]), .SBDATO4(spi_dato[4]), .SBDATO5(spi_dato[5]), .SBDATO6(spi_dato[6]), .SBDATO7(spi_dato[7]),
            .SBACKO(spi_ack),
            .MI(spi_miso), .SO(SPI_MISO),
            .MO(spi_mosi), .SI(SPI_MOSI),
            .SCKI(SPI_SCK), .SCSNI(SPI_SS)
    );
    end

endmodule