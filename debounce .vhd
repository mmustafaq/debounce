library ieee;
use ieee.std_logic_1164.all;

entity debounce is

generic(
		clk_freq 		: integer   := 100_000_000; -- clock parameters
		debounce_time	: integer   := 1000;		--
		c_initial		: std_logic := '0'          -- initial clock value
		);
port (
		clk        : in  std_logic; --clock 
		signal_in  : in  std_logic;	--input signal value 0 or 1
		signal_out : out std_logic  --outpu signal value 
		
);
end debounce;

architecture arch of debounce is
constant timer_lim : integer := clk_freq/debounce_time;  -- maximum timer value

signal timer 		: integer range 0 to timer_lim := 0; -- timer 
signal timer_en 	: std_logic := '0';					 --	signal to enable timer
signal timer_tick	: std_logic := '0';					 -- if it is 1 then we know that our state will not change afterwards	

type t_state is (s_initial,s_zero,s_one,s_zero_to_one,s_one_to_zero); 
signal state : t_state := s_initial;


begin

process(clk)
begin
if(rising_edge(clk)) then
	case state is
		
		when s_initial => 
			if(c_initial = '0')then 
				state <= s_zero;
			else
				state <= s_one;
			end if;
			
			
		when s_zero =>
			signal_out <= '0';
			if(signal_in = '1') then 
				state <= s_zero_to_one;
			end if;
		
		when s_zero_to_one =>
			signal_out<='0';
			timer_en  <='1';
			if(timer_tick = '1') then 
				state <= s_one;
				timer_en  <='0';
			end if;
			if(signal_in= '0') then
				state <= s_zero;
				timer_en  <='0';
			end if;	
		
		when s_one =>
			signal_out <= '1';
			if(signal_in = '0') then 
				state <= s_one_to_zero;
			end if;
			
		
		when s_one_to_zero =>
			signal_out<='1';
			timer_en  <='1';
		    if(timer_tick = '1') then
		    	state <= s_zero;
		    	timer_en  <='0';
		    end if;
		    if(signal_in= '1') then
		    	state <= s_one;
		    	timer_en  <='0';
		    end if;		
	end case;
end if;
end process;

process(clk)
begin
if(rising_edge(clk)) then
	if(timer_en = '1') then
		if(timer = timer_lim - 1) then 
			timer_tick <= '1';
			timer 	   <= 0  ;
		else 
			timer_tick <= '0';
			timer      <= timer + 1;
			
		end if;
	
	else
		timer 		<= 0;
		timer_tick	<= '0';
	end if;
end if;
end process;
end architecture;