----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:45:09 03/02/2016 
-- Design Name: 
-- Module Name:    testing - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           u : in  STD_LOGIC;
           d : in  STD_LOGIC;
			  En : in STD_LOGIC;
			  start : in STD_LOGIC;
			  ball_x : out  STD_LOGIC_VECTOR(9 DOWNTO 0);
			  ball_y : out  STD_LOGIC_VECTOR(9 DOWNTO 0);
			  p1_score: out STD_LOGIC_VECTOR(2 DOWNTO 0);
			  p2_score: out STD_LOGIC_VECTOR(2 DOWNTO 0);
           pos : out  STD_LOGIC_VECTOR(9 DOWNTO 0));
end game;

architecture Behavioral of game is

signal pos_buffer: unsigned (9 DOWNTO 0) := "0011001000";
signal x_buffer: unsigned (9 DOWNTO 0) := "0101000000";
signal y_buffer: unsigned (9 DOWNTO 0) := "0011001000";
signal pos_next,x_next,y_next,x,y,vy_next,vx_next,p: unsigned (9 DOWNTO 0);
signal vx,vy: unsigned(9 DOWNTO 0) := to_unsigned(2,10);
signal dead_l,dead_l_next,dead_r,dead_r_next: STD_LOGIC := '0';
signal score_l,score_r,score_l_next,score_r_next: unsigned(2 DOWNTO 0) := "000";
signal stop,stop_next: STD_LOGIC := '0';

constant v_plus: unsigned(9 DOWNTO 0) := to_unsigned(2,10);
constant v_minus: unsigned(9 DOWNTO 0) := unsigned(to_signed(-2,10));
constant v_pp: unsigned(9 DOWNTO 0) := to_unsigned(4,10);
constant v_mm: unsigned(9 DOWNTO 0) := unsigned(to_signed(-4,10));

constant bar_l: unsigned(9 DOWNTO 0) := to_unsigned(40,10);
constant bar_r: unsigned(9 DOWNTO 0) := to_unsigned(584,10);

signal enable: STD_LOGIC;
constant bar_length: integer := 50;
constant bar_edge: integer := 20;
-- 1 unit
constant unit: integer := 2;
-- top limit
constant top: integer := 410;
-- bottom limit
constant bottom: integer := 150;


begin
	enable <= En;
	stop_next <= '1' when score_l = 6 or score_r = 6 else
		'0';
	process(clk,rst,start,stop)
	begin
		if rst = '1' then
			pos_buffer <= "0011001000";
			x_buffer <= "0101000000";
		   y_buffer <= "0011001000";
			vx <= v_plus;
			vy <= v_minus;
			dead_l <= '0';
			dead_r <= '0';
			score_l <= "000";
			score_r <= "000";	
			stop <= '0';
		elsif rising_edge(clk) and stop = '0' then	
			if start = '1' then
				pos_buffer <= pos_next;
				x_buffer <= x_next;
				y_buffer <= y_next;
				dead_l <= dead_l_next;
				dead_r <= dead_r_next;
				vy <= vy_next;
				vx <= vx_next;
				stop <= stop_next;
				
				if dead_l = '1' or dead_r = '1' then		
					pos_buffer <= "0011001000";
					x_buffer <= "0101000000";
					y_buffer <= "0011001000";
					vx <= v_plus;
					vy <= v_minus;
					dead_l <= '0';
					dead_r <= '0';
					score_r <= score_r_next;
					score_l <= score_l_next;
				end if;
			end if;			
		end if;
	end process;
	
	
	process(enable,pos_buffer,u,d)
	begin
		pos_next <= pos_buffer;
		if enable = '1' then
			if u = '1' and pos_buffer < top then
				pos_next <= pos_buffer + unit;
			end if;
			if d = '1' and pos_buffer > bottom then
				pos_next <= pos_buffer - unit;
			end if;
		end if;
	end process;
	
	x <= x_buffer;
	y <= y_buffer;
	p <= pos_buffer;
	
	dead_l_next <= '1' when x_buffer = bar_l and (y_buffer > p + bar_length or y_buffer < p - bar_length) else
		'0';
	dead_r_next <= '1' when x_buffer = bar_r and (y_buffer > p + bar_length or y_buffer < p - bar_length) else
		'0';	
	score_l_next <= score_l + 1 when dead_r_next = '1' else
		score_l;
	score_r_next <= score_r + 1 when dead_l_next = '1' else
		score_r;
	
	process(x,y,vx,vy,p)
	begin
		vx_next <= vx;
		vy_next <= vy;
		if (x = 40 or x = 584) and (y > p + bar_edge or y < p - bar_edge) then
			if vy = v_plus then
				vy_next <= v_pp;
			elsif vy = v_pp then
				vy_next <= v_plus;
			elsif vy = v_minus then
				vy_next <= v_mm;
			else
				vy_next <= v_minus;
			end if;
		end if;
		
		if x = 40 then
			vx_next <= v_plus;
		elsif x = 584 then
			vx_next <= v_minus;
		elsif y = 100 then
			vy_next <= not vy + 1;
		elsif y = 444 then
			vy_next <= not vy + 1;
		end if;		
	end process;
	

	
	x_next <= x_buffer + vx_next when enable = '1'  else
	x_buffer;
	y_next <= y_buffer + vy_next when enable = '1'  else
	y_buffer;
	
pos <= STD_LOGIC_VECTOR(pos_buffer(9 DOWNTO 0));
ball_x <= STD_LOGIC_VECTOR(x_buffer(9 DOWNTO 0));
ball_y <= STD_LOGIC_VECTOR(y_buffer(9 DOWNTO 0));
p1_score <= STD_LOGIC_VECTOR(score_l);
p2_score <= STD_LOGIC_VECTOR(score_r);
end Behavioral;

