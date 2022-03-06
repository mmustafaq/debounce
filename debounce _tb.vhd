library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is

generic(
		clk_freq 		: integer   := 100_000_000; 
		debounce_time	: integer   := 1000;		
		c_initial		: std_logic := '0'          
		);

end tb_debounce;

architecture Behavioral of tb_debounce is


component debounce is
generic(
		clk_freq 		: integer   := 100_000_000; 
		debounce_time	: integer   := 1000;		
		c_initial		: std_logic := '0'          
		);
port (
		clk        : in  std_logic; 
		signal_in  : in  std_logic;	
		signal_out : out std_logic  
		
		);
end component;


signal clk 			: std_logic := '0';
signal signal_in	: std_logic := '0';
signal signal_out	: std_logic;

constant clock_period : time := 10 ns;

begin

DUT : debounce
generic map (
 clk_freq 		=> clk_freq,
 debounce_time	=> debounce_time,
 c_initial		=> c_initial
)

port map(
clk => clk,
signal_in => signal_in,
signal_out => signal_out
);
 
clock_generate: process begin

clk <= '0';
wait for clock_period/2;
clk <= '1';
wait for clock_period/2;
end process;

p_stimulus : process begin


signal_in	<= '0';
wait for 2 ms;

signal_in	<= '1';
wait for 100 us;
signal_in	<= '0';
wait for 200 us;
signal_in	<= '1';
wait for 100 us;
signal_in	<= '0';
wait for 100 us;
signal_in	<= '1';
wait for 800 us;
signal_in	<= '0';
wait for 50 us;
signal_in	<= '1';
wait for 3 ms;

signal_in 	<= '0';
wait for 100 us;
signal_in 	<= '1';
wait for 200 us;
signal_in 	<= '0';
wait for 950 us;
signal_in 	<= '1';
wait for 150 us;
signal_in 	<= '0';
wait for 2 ms;


assert false
report "SIM DONE"
severity failure;

end process;


end Behavioral;




