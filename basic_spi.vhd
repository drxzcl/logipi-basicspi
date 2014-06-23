----------------------------------------------------------------------------------
-- Basic SPI implementation. Use MODE1.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity basic_spi is
port( OSC_FPGA : in std_logic;
		PB : in std_logic_vector(1 downto 0);
		SYS_SPI_MOSI : in std_logic;
		SYS_SPI_SCK : in std_logic;
		SYS_SPI_MISO: out std_logic;
		LED : out std_logic_vector(1 downto 0)
);
end basic_spi;

architecture Behavioral of basic_spi is
	
	signal pb0_synchronizer: std_logic_vector(2 downto 0);
	signal reset:std_logic;
	
	signal data_in:std_logic_vector(7 downto 0);
	signal data_out:std_logic_vector(7 downto 0);
	signal rd:std_logic;
	signal wr:std_logic;
	
begin
	
	blink_hb : entity work.blink_heartbeat port map(CLK => OSC_FPGA, LED => LED(0));
--	spi_fifo: entity work.fifo GENERIC MAP (
--			ADDR_W => 3,
--			DATA_W => 8
--		)
--		PORT MAP (
--          clk => OSC_FPGA,
--          reset => pb0_synchronizer(1),
--          rd_en => rd_en,
--          wr_en => wr_en,
--          data_in => data_in,
--          data_out => data_out,
--          data_count => data_count,
--          empty => empty,
--          full => full
--        );		  
	
	spi: entity work.spi 
		PORT MAP (
			clk => OSC_FPGA,
         reset => reset,
			data_in => X"C5", -- Always output 0xC5 on the SPI interface.
         data_out => data_out,
         rd => rd,
         wr => wr,
         SCK => SYS_SPI_SCK,
         MOSI => SYS_SPI_MOSI,
         MISO => SYS_SPI_MISO
	);
	
	process(OSC_FPGA, PB)
	begin
		if (rising_edge(OSC_FPGA)) then
		
			-- Synch the pushbutton and generate a reset signal
			pb0_synchronizer(2 downto 1) <= pb0_synchronizer(1 downto 0);
			pb0_synchronizer(0) <= PB(0);
		
			if pb0_synchronizer(2 downto 1) = "01" then
				-- Rising edge is button release
				LED(1) <= '0';
				reset <= '1';
			elsif (reset = '1') then
				reset <= '0';
			end if;
			
			-- monitor the SPI output. If we see the magic number,
			-- turn on the LED.
			if (wr = '1') then
				if (data_out = X"AA") then
					LED(1) <= '1';
				end if;
			end if;
		end if;
	end process ;

end Behavioral;

