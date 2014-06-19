----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fifo is
	Generic(
			ADDR_W	: integer	:= 4;					-- address width in bits
			DATA_W 	: integer	:= 24 				-- data width in bits
			);
	Port ( 
			clk 					: in std_logic;
			reset 				: in std_logic;
			rd_en 				: in std_logic; 		-- read enable 
			wr_en					: in std_logic; 		-- write enable 
			data_in 				: in std_logic_vector(DATA_W- 1 downto 0); 
			data_out				: out std_logic_vector(DATA_W- 1 downto 0); 
			data_count			: buffer std_logic_vector(ADDR_W downto 0);
			empty 				: out std_logic; 
			full					: out std_logic
);
end fifo;


architecture Behavioral of fifo is
	-----memory, pointers-------
	type reg_file_type is array (0 to ((2**ADDR_W) - 1)) of std_logic_vector(DATA_W - 1 downto 0);
	
	signal mem_array					: reg_file_type ;
	signal rd_ptr, wr_ptr 			: std_logic_vector(ADDR_W-1 downto 0); 		-- current pointers
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				mem_array <= (others => (others => '0'));
				rd_ptr <= (others => '0');
				wr_ptr <= (others => '0');		
				data_count <= (others => '0');
				empty <= '1';
				full <= '0';
			end if;
		else
			if (wr_en = '1') then
				-- Write into the fifo
				if (conv_integer(data_count) /= ((2**ADDR_W))) then					
					mem_array(conv_integer(wr_ptr)) <= data_in;
					wr_ptr <= wr_ptr + 1;
					data_count <= data_count + 1;
					empty <= '0';
					if (conv_integer(data_count) = ((2**ADDR_W) - 1)) then
						full <= '1';
					end if;
				end if;
			end if;
			if (rd_en = '1') then
				-- Write into the fifo
				if (conv_integer(data_count) /= 0) then
					data_out <= mem_array(conv_integer(rd_ptr));
					rd_ptr <= rd_ptr + 1;
					data_count <= data_count - 1;
					full <= '0';
					if (conv_integer(data_count) = 1) then
						empty <= '1';
					end if;
				else
					data_out <= (others => '0');
				end if;
			end if;
		end if;
	end process;


end Behavioral;

