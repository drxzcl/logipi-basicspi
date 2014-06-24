----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:29:43 06/23/2014 
-- Design Name: 
-- Module Name:    spi - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi is
    Port ( clk : in STD_LOGIC;
           reset : in  STD_LOGIC;
			  data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0)  := (others => '0');
           rd : out  STD_LOGIC := '0';
           wr : out  STD_LOGIC := '0';
           SCK : in  STD_LOGIC;
           MOSI : in  STD_LOGIC;
           MISO : out  STD_LOGIC := '0');
end spi;

architecture Behavioral of spi is
	signal spi_value: std_logic_vector(7 downto 0) := (others => '0');
	signal spi_readvalue: std_logic_vector(7 downto 0):= (others => '0');
	signal sck_synchronizer: std_logic_vector(2 downto 0):= (others => '0');

	signal rdcnt: std_logic_vector(3 downto 0) := "1111";
	signal wrcnt: std_logic_vector(2 downto 0) := "000";
	signal feed_me: std_logic := '0';
	signal read_me: std_logic := '0';

begin
process(clk, reset)
	begin
		if (rising_edge(clk)) then

			-- Synch the SPI clock
			sck_synchronizer(2 downto 1) <= sck_synchronizer(1 downto 0);
			sck_synchronizer(0) <= SCK;
	
			if (reset = '1') then
				spi_value <= X"00"; 
				spi_readvalue <= X"00";
				MISO <= '0'; -- Mode1 means this value should never get sampled
				rdcnt <= "1111";
				wrcnt <= "000";
				rd <= '0';
				wr <= '0';
				read_me <= '0';
				feed_me <= '0';
				data_out <= (others => '0');
			else						
				-- SPI MODE 1: clock rests low, assert on rise, latch on fall.
				if (sck_synchronizer(2 downto 1) = "01") then
					-- rise: assert
					spi_value <= spi_value(6 downto 0) & '0';
					MISO <= spi_value(7);
					wrcnt <= wrcnt+1;					
					if (wrcnt = "111") then
						wrcnt <= "000";
						feed_me <= '1';
						rd <= '1';
					end if;
				else
					if (sck_synchronizer(2 downto 1) = "10") then
					-- fall: sample
						spi_readvalue(7 downto 1) <= spi_readvalue(6 downto 0);
						spi_readvalue(0) <= MOSI;
						rdcnt <= rdcnt+1;
						if (rdcnt = "1000") then
							rdcnt <= "0001";
							read_me <= '1';
							wr <= '1';
							data_out <= spi_readvalue;
						end if;						
					end if;
				end if;			
			end if;
			if (feed_me = '1') then
				spi_value <= data_in;
				rd <= '0';
				feed_me <='0';
			end if;
			if (read_me = '1') then
				read_me <='0';
				wr <= '0';
			end if;
		end if;
	end process ;

end Behavioral;

