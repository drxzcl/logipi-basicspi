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
		--onboard
		LED : out std_logic_vector(1 downto 0)
);
end logipi_blink;

architecture Behavioral of logipi_blink is
	
	-- Led counter
	signal counter_output : std_logic_vector(31 downto 0);
	
begin
	
	process(OSC_FPGA, PB)
	begin
		if (rising_edge(OSC_FPGA)) then
			if PB(0) = '0' then
				counter_output <= X"00000000";
			else
				counter_output <= counter_output + 1 ;
			end if;
		end if;
	end process ;
	LED(0) <= counter_output(24);
	LED(1) <= counter_output(23);

end Behavioral;

