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
           RGB: out  STD_LOGIC_VECTOR (2 downto 0));
end VGA_display;

architecture Behavioral of VGA_display is

type rom is array (0 to 15) of
	STD_LOGIC_VECTOR (15 downto 0);
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
type rom_num is array (0 to 127) of
	STD_LOGIC_VECTOR (0 to 7);
constant score: rom_num := (
		-- 0: code x30
		"00000000", -- 0
		"00000000", -- 1
		"01111100", -- 2  *****
		"11000110", -- 3 **   **
		"11000110", -- 4 **   **
		"11001110", -- 5 **  ***
		"11011110", -- 6 ** ****
		"11110110", -- 7 **** **
		"11100110", -- 8 ***  **
		"11000110", -- 9 **   **
		"11000110", -- a **   **
		"01111100", -- b  *****
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000", -- f
		-- 1: code x31
		"00000000", -- 0
		"00000000", -- 1
		"00011000", -- 2
		"00111000", -- 3
		"01111000", -- 4    **
		"00011000", -- 5   ***
		"00011000", -- 6  ****
		"00011000", -- 7    **
		"00011000", -- 8    **
		"00011000", -- 9    **
		"00011000", -- a    **
		"01111110", -- b    **
		"00000000", -- c    **
		"00000000", -- d  ******
		"00000000", -- e
		"00000000", -- f
		-- 2: code x32
		"00000000", -- 0
		"00000000", -- 1
		"01111100", -- 2  *****
		"11000110", -- 3 **   **
		"00000110", -- 4      **
		"00001100", -- 5     **
		"00011000", -- 6    **
		"00110000", -- 7   **
		"01100000", -- 8  **
		"11000000", -- 9 **
		"11000110", -- a **   **
		"11111110", -- b *******
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000", -- f
		-- 3: code x33
		"00000000", -- 0
		"00000000", -- 1
		"01111100", -- 2  *****
		"11000110", -- 3 **   **
		"00000110", -- 4      **
		"00000110", -- 5      **
		"00111100", -- 6   ****
		"00000110", -- 7      **
		"00000110", -- 8      **
		"00000110", -- 9      **
		"11000110", -- a **   **
		"01111100", -- b  *****
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000", -- f
		-- 4: code x34
		"00000000", -- 0
		"00000000", -- 1
		"00001100", -- 2     **
		"00011100", -- 3    ***
		"00111100", -- 4   ****
		"01101100", -- 5  ** **
		"11001100", -- 6 **  **
		"11111110", -- 7 *******
		"00001100", -- 8     **
		"00001100", -- 9     **
		"00001100", -- a     **
		"00011110", -- b    ****
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000", -- f
		-- code x35
		"00000000", -- 0
		"00000000", -- 1
		"11111110", -- 2 *******
		"11000000", -- 3 **
		"11000000", -- 4 **
		"11000000", -- 5 **
		"11111100", -- 6 ******
		"00000110", -- 7      **
		"00000110", -- 8      **
		"00000110", -- 9      **
		"11000110", -- a **   **
		"01111100", -- b  *****
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000", -- f
		-- code x36
		"00000000", -- 0
		"00000000", -- 1
		"00111000", -- 2   ***
		"01100000", -- 3  **
		"11000000", -- 4 **
		"11000000", -- 5 **
		"11111100", -- 6 ******
		"11000110", -- 7 **   **
		"11000110", -- 8 **   **
		"11000110", -- 9 **   **
		"11000110", -- a **   **
		"01111100", -- b  *****
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000", -- f
		-- code x3a
		"00000000", -- 0
		"00000000", -- 1
		"00000000", -- 2
		"00000000", -- 3
		"00011000", -- 4    **
		"00011000", -- 5    **
		"00000000", -- 6
		"00000000", -- 7
		"00000000", -- 8
		"00011000", -- 9    **
		"00011000", -- a    **
		"00000000", -- b
		"00000000", -- c
		"00000000", -- d
		"00000000", -- e
		"00000000"  -- f
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

signal text_addr: STD_LOGIC_VECTOR (6 DOWNTO 0);
signal char_addr: STD_LOGIC_VECTOR (2 DOWNTO 0);
signal text_col: unsigned (2 DOWNTO 0);
signal text_row: STD_LOGIC_VECTOR(0 to 7);
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

text_in <= '1' when y_counter(9 downto 6) = 0 and  x_counter(9 downto 5) >= 8 and x_counter(9 downto 5) < 11 else
	'0';
with x_counter(8 downto 5) select
		char_addr <=
			p1_score when "1000",
			"111"		when "1001",
		   p2_score when others;
text_addr <= char_addr & y_counter(5 downto 2);
 
text_row <= score(to_integer(unsigned(text_addr)));			 
text_col <= x(4 downto 2);
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

