--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:09:27 06/24/2014
-- Design Name:   
-- Module Name:   C:/Dev/fpga/logipi/experiment/basic_spi_tb.vhd
-- Project Name:  logipi-hw
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: basic_spi
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY basic_spi_tb IS
END basic_spi_tb;
 
ARCHITECTURE behavior OF basic_spi_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT basic_spi
    PORT(
         OSC_FPGA : IN  std_logic;
         PB : IN  std_logic_vector(1 downto 0);
         SYS_SPI_MOSI : IN  std_logic;
         SYS_SPI_SCK : IN  std_logic;
         SYS_SPI_MISO : OUT  std_logic;
         LED : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal OSC_FPGA : std_logic := '0';
   signal PB : std_logic_vector(1 downto 0) := (others => '0');
   signal SYS_SPI_MOSI : std_logic := '0';
   signal SYS_SPI_SCK : std_logic := '0';

 	--Outputs
   signal SYS_SPI_MISO : std_logic;
   signal LED : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant OSC_FPGA_period : time := 20 ns;
 
   -- Purpose: Increments a std_logic_vector by 1
  procedure SEND_BYTE (
    constant b : in  std_logic_vector(7 downto 0);
	 signal mosi: out std_logic;
	 signal sck: out std_logic
    ) is
	 variable i : std_logic_vector(3 downto 0) := "0000";
  begin
		while (i <= 7) loop
			mosi <= b(7-conv_integer(i));
			sck <= '1';
			wait for OSC_FPGA_period * 5;
			sck <= '0';
			wait for OSC_FPGA_period * 5;	
			i := i + 1;
		end loop;
  end SEND_BYTE;
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: basic_spi PORT MAP (
          OSC_FPGA => OSC_FPGA,
          PB => PB,
          SYS_SPI_MOSI => SYS_SPI_MOSI,
          SYS_SPI_SCK => SYS_SPI_SCK,
          SYS_SPI_MISO => SYS_SPI_MISO,
          LED => LED
        );

   -- Clock process definitions
   OSC_FPGA_process :process
   begin
		OSC_FPGA <= '0';
		wait for OSC_FPGA_period/2;
		OSC_FPGA <= '1';
		wait for OSC_FPGA_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		PB(0) <= '1';

      wait for OSC_FPGA_period*10;
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);
		SEND_BYTE(X"AA", SYS_SPI_MOSI, SYS_SPI_SCK);


      wait;
   end process;

END;
