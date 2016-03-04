----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:48:35 03/02/2016 
-- Design Name: 
-- Module Name:    VGA_display - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_display is
    Port ( x_counter: in STD_LOGIC_VECTOR (9 downto 0);
			  y_counter: in STD_LOGIC_VECTOR (9 downto 0);
			  p1_score: in STD_LOGIC_VECTOR (2 downto 0);
			  p2_score: in STD_LOGIC_VECTOR (2 downto 0);
			  ball_x: in  STD_LOGIC_VECTOR (9 downto 0);
           ball_y: in  STD_LOGIC_VECTOR (9 downto 0);
			  bar_left: in  STD_LOGIC_VECTOR (9 downto 0);
           bar_right: in  STD_LOGIC_VECTOR (9 downto 0);
			  addr : OUT std_logic_vector(10 downto 0);          
			  dataIn : IN std_logic_vector(7 downto 0);
           RGB: out  STD_LOGIC_VECTOR (2 downto 0));
end VGA_display;

architecture Behavioral of VGA_display is

type rom is array (0 to 15) of
	STD_LOGIC_VECTOR (0 to 15);
constant ball_shape: rom := (
	"0000011111100000",
	"0001111111111000",
	"0011111111111100",
	"0011111111111100",
	"0111111111111110",
	"1111111111111111",
	"1111111111111111",
	"1111111111111111",
	"1111111111111111",
	"1111111111111111",
	"1111111111111111",
	"0111111111111110",
	"0011111111111100",
	"0011111111111100",
	"0001111111111000",
	"0000011111100000"
);

constant wall_left: integer := 20;
constant wall_right: integer := 620;
constant bar_length: integer := 50;
constant ball_width: integer := 16;


signal x,y: unsigned (9 downto 0);
signal bar_l,bar_r: unsigned (9 downto 0);
signal ball_sx,ball_sy: unsigned (9 downto 0);
signal wall_on,bar_on,ball_in,ball_on,text_in,text_on: STD_LOGIC;

signal ball_addr,ball_col: unsigned(3 DOWNTO 0);
signal ball_row: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal wall_rgb,bar_rgb,ball_rgb,text_rgb: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal ball_bit: STD_LOGIC;

signal text_addr: STD_LOGIC_VECTOR (10 DOWNTO 0);
signal char_addr: STD_LOGIC_VECTOR (6 DOWNTO 0);
signal text_col: unsigned (2 DOWNTO 0);
signal text_row: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal text_bit: STD_LOGIC;

begin

x <= unsigned(x_counter);
y <= unsigned(y_counter);
bar_l <= unsigned(bar_left);
bar_r <= unsigned(bar_right);
ball_sx <= unsigned(ball_x);
ball_sy <= unsigned(ball_y);

------------------------------------------------------
wall_on <= '1' when x < 20 or x > 620 or y > 460 or (y > 80 and y < 100) else
	'0';
wall_rgb <= "111";
bar_on <= '1' when (x < 40 and x > 20 and y > bar_l - bar_length and y < bar_l + bar_length) or
					(x > 600 and x < 620 and y > bar_r -bar_length and y < bar_r + bar_length) else
	'0';
bar_rgb <= "010";
ball_in <= '1' when x >= ball_sx and x < ball_sx + ball_width and y >= ball_sy and y < ball_sy + ball_width else
   '0';
	
ball_addr <= y(3 DOWNTO 0) - ball_sy(3 DOWNTO 0);
ball_col <= x(3 DOWNTO 0) - ball_sx(3 DOWNTO 0);
ball_row <= ball_shape(to_integer(ball_addr));
ball_bit <= ball_row(to_integer(ball_col));

ball_on <= '1' when ball_in = '1' and ball_bit = '1' else
	'0';
ball_rgb <= "001";

----------------------------------------

text_in <= '1' when y < 64 and x_counter(9 downto 6) < 3 else
	'0';
with x_counter(7 downto 6) select
		char_addr <=
		"0110" & p1_score when "00",
		"0111010" when "01",
		"0110" & p2_score when others;
text_addr <= char_addr & y_counter(5 downto 2);
 
			 
addr <= text_addr;
text_row <= dataIn;
text_col <= x(8 downto 6);
text_bit <= text_row(to_integer(text_col)); 

text_on <= '1' when text_in = '1' and text_bit = '1' else
	'0';
text_rgb <= "111";

---------------------------------------
process(wall_on,bar_on,ball_on,text_on,
wall_rgb, bar_rgb, ball_rgb,text_rgb)	
begin
	if wall_on = '1' then
		RGB <= wall_rgb;
	elsif bar_on = '1' then
		RGB <= bar_rgb;
	elsif ball_on = '1' then
		RGB <= ball_rgb;
	elsif text_on = '1' then
		RGB <= text_rgb;
	else
		RGB <= "000";
	end if;
end process;

end Behavioral;

