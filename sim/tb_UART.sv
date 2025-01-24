module tb_UART;

  // Parameters
  parameter D_WIDTH      = 8;
  parameter PARITY_O_1   = 0; // Even parity
  parameter CLK_FREQ_MHZ = 50;

  // Clock and reset
  logic clk;
  logic arst_n;

  // Master UART signals
  logic               start_master     ;
  logic [D_WIDTH-1:0] data_in_master   ;
  logic               rx_master        ;
  logic               tx_master        ;
  logic [D_WIDTH-1:0] data_out_master  ;
  logic               error_flag_master;

  // Slave UART signals
  logic               start_slave     ;
  logic [D_WIDTH-1:0] data_in_slave   ;
  logic               rx_slave        ;
  logic               tx_slave        ;
  logic [D_WIDTH-1:0] data_out_slave  ;
  logic               error_flag_slave;

  // Clock generation
  always #10 clk = ~clk; // 50 MHz clock (period = 20 ns)

  // Instantiate Master UART
  UART #(
    .D_WIDTH(D_WIDTH),
    .PARITY_O_1(PARITY_O_1),
    .CLK_FREQ_MHZ(CLK_FREQ_MHZ)
  ) master_uart (
    .clk(clk),
    .arst_n(arst_n),
    .start(start_master),
    .data_in(data_in_master),
    .Rx(rx_master),
    .data_out(data_out_master),
    .error_flag(error_flag_master),
    .Tx(tx_master)
  );

  // Instantiate Slave UART
  UART #(
    .D_WIDTH(D_WIDTH),
    .PARITY_O_1(PARITY_O_1),
    .CLK_FREQ_MHZ(CLK_FREQ_MHZ)
  ) slave_uart (
    .clk(clk),
    .arst_n(arst_n),
    .start(start_slave),
    .data_in(data_in_slave),
    .Rx(rx_slave),
    .data_out(data_out_slave),
    .error_flag(error_flag_slave),
    .Tx(tx_slave)
  );

  // Initialize signals
  initial begin
    clk         = 0;
    arst_n      = 0;
    start_master = 0;
    start_slave  = 0;
    tx_slave     = 1;
    tx_master    = 1;
    data_in_master = 8'b0;
    data_in_slave  = 8'b0;

    // Reset
    #50;
    arst_n = 1;

// Test case Master sending the data "Hi!"

    // Test case: Send "H" (0x48) and "i" (0x69) from Master to Slave
    @(posedge clk);
    start_master = 1;
    data_in_master = 8'b01001000; // ASCII for 'H'
    #1000;
    start_master = 0;
    #11000;
    start_master = 1;
    data_in_master = 8'b01101001; // ASCII for 'i'
    #1000;
    start_master = 0;
    #11000;
    start_master = 1;
    data_in_master = 8'b00100001; // ASCII for '!'
    #1000;
    start_master = 0;
    #11000;

// Test case Slave sending the data "How are you ?"

    start_slave = 1;
    data_in_slave = 8'b01001000; // ASCII for 'H'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd111; // ASCII for 'o'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd119; // ASCII for 'w'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd32; // ASCII for ' '
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd97; // ASCII for 'a'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd114; // ASCII for 'r'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd101; // ASCII for 'e'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd32; // ASCII for ' '
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd121; // ASCII for 'y'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd111; // ASCII for 'o'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd117; // ASCII for 'u'
    #1000;
    start_slave = 0;
    #11000;
    start_slave = 1;
    data_in_slave = 8'd63; // ASCII for 'H'
    #1000;
    start_slave = 0;
    #11000;

    #10000;
    $stop; // End simulation
  end

  // Connect Master Tx to Slave Rx and vice versa
  assign rx_master = tx_slave;
  assign rx_slave  = tx_master;

endmodule
