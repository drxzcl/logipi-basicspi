----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:14:22 06/21/2012 
-- Design Name: 
-- Module Name:    spartcam_beaglebone - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity logipi_blink is
port( OSC_FPGA : in std_logic;
		PB : in std_logic_vector(1 downto 0);
		SYS_SPI_MOSI : in std_logic;
		SYS_SPI_SCK : in std_logic;
		SYS_SPI_MISO: out std_logic;
		LED : out std_logic_vector(1 downto 0)
);
end logipi_blink;

architecture Behavioral of logipi_blink is
	
	signal spi_value: std_logic_vector(7 downto 0);
	--signal spi_counter: std_logic_vector(2 downto 0);
	signal spi_readvalue: std_logic_vector(7 downto 0);
	signal sck_synchronizer: std_logic_vector(2 downto 0);
	signal pb0_synchronizer: std_logic_vector(2 downto 0);
	
begin
	
	blink_hb : entity work.blink_heartbeat port map(CLK => OSC_FPGA, LED => LED(0));
	
	process(OSC_FPGA, PB)
	begin
		if (rising_edge(OSC_FPGA)) then
		
			-- Synch the PB
			pb0_synchronizer(2 downto 1) <= pb0_synchronizer(1 downto 0);
			pb0_synchronizer(0) <= PB(0);
		
			if pb0_synchronizer(2 downto 1) = "01" then
				-- Rising edge is button release
				--spi_counter <= "000";
				spi_value <= X"C5"; -- 11000101
				spi_readvalue <= X"00";
				SYS_SPI_MISO <= '0'; -- Mode1 means this value should never get sampled
				LED(1) <= '0';
  			   --spi_value <= spi_value(6 downto 0) & '0';
				--sck_synchronizer <= "000";
			else
				
				-- Synch the SPI clock
				sck_synchronizer(2 downto 1) <= sck_synchronizer(1 downto 0);
				sck_synchronizer(0) <= SYS_SPI_SCK;
		
				-- SPI MODE 1: clock rests low, assert on rise, latch on fall.
				if (sck_synchronizer(2 downto 1) = "01") then
					-- rise: assert
					--spi_counter <= spi_counter + 1;
					spi_value <= spi_value(6 downto 0) & '0';
					SYS_SPI_MISO <= spi_value(7);
				else
					if (sck_synchronizer(2 downto 1) = "10") then
					-- fall: sample
						spi_readvalue(7 downto 1) <= spi_readvalue(6 downto 0);
						spi_readvalue(0) <= SYS_SPI_MOSI;
					else
						-- If we got a magic value, turn on the led and reset the buffer
						if (spi_readvalue = X"AA") then
							LED(1)<='1';
							spi_readvalue<=X"00";
						end if;
					end if;
				end if;			
			end if;
		end if;
	end process ;

end Behavioral;

