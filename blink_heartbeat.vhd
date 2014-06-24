----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:01 06/19/2014 
-- Design Name: 
-- Module Name:    blink_heartbeat - Behavioral 
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


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blink_heartbeat is
    Port ( CLK : in  STD_LOGIC;
           LED : out  STD_LOGIC);
end blink_heartbeat;

architecture Behavioral of blink_heartbeat is
	-- Led counter
	signal counter_output : std_logic_vector(24 downto 0) := (others => '0');

begin

process(CLK)
	begin
		if (rising_edge(CLK)) then		
			counter_output <= counter_output + 1 ;				
		end if;
	end process ;

	LED <= counter_output(24);
	
end Behavioral;

