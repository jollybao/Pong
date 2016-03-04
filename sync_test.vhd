----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:45 03/01/2016 
-- Design Name: 
-- Module Name:    sync_test - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_test is
    Port ( clk : in  STD_LOGIC;
	        reset : in STD_LOGIC;
			  start : in STD_LOGIC;
			  up : in STD_LOGIC;
			  down : in STD_LOGIC;
           rgb : out  STD_LOGIC_VECTOR(2 DOWNTO 0);
           hsn : out  STD_LOGIC;
           vsn : out  STD_LOGIC);
end sync_test;

architecture Behavioral of sync_test is

     COMPONENT sync_mod
            PORT( clk : IN STD_LOGIC;
					reset : IN STD_LOGIC;
					start : IN STD_LOGIC; 
					y_control : OUT STD_LOGIC_VECTOR(9 downto 0);
					x_control : OUT STD_LOGIC_VECTOR(9 downto 0);
					h_s : OUT STD_LOGIC;
					v_s : OUT STD_LOGIC;
					En : OUT STD_LOGIC;
					video_on : OUT STD_LOGIC );
      END COMPONENT;
		
		COMPONENT game 
			Port ( clk : IN  STD_LOGIC;
           rst : IN  STD_LOGIC;
           u : IN  STD_LOGIC;
           d : IN  STD_LOGIC;
			  En : In STD_LOGIC;
			  start : IN STD_LOGIC;
			  ball_x : out  STD_LOGIC_VECTOR(9 DOWNTO 0);
			  ball_y : out  STD_LOGIC_VECTOR(9 DOWNTO 0);
			  p1_score: out STD_LOGIC_VECTOR(2 DOWNTO 0);
			  p2_score: out STD_LOGIC_VECTOR(2 DOWNTO 0);
           pos : OUT  STD_LOGIC_VECTOR(9 DOWNTO 0));
		END COMPONENT;
		
		COMPONENT VGA_display
			PORT(
				x_counter : IN std_logic_vector(9 downto 0);
				y_counter : IN std_logic_vector(9 downto 0);
				p1_score: in STD_LOGIC_VECTOR (2 downto 0);
				p2_score: in STD_LOGIC_VECTOR (2 downto 0);
				ball_x : IN std_logic_vector(9 downto 0);
				ball_y : IN std_logic_vector(9 downto 0);
				bar_left : IN std_logic_vector(9 downto 0);
				bar_right : IN std_logic_vector(9 downto 0);					
				RGB : OUT std_logic_vector(2 downto 0));
		END COMPONENT;
 
	
     --buffer
     signal video: STD_LOGIC;
	  signal p: STD_LOGIC_VECTOR (9 DOWNTO 0);
	  signal xc: STD_LOGIC_VECTOR (9 DOWNTO 0);
	  signal yc: STD_LOGIC_VECTOR (9 DOWNTO 0);
	  signal rgb_next: STD_LOGIC_VECTOR (2 DOWNTO 0);
	  signal bx: STD_LOGIC_VECTOR (9 DOWNTO 0);
	  signal by: STD_LOGIC_VECTOR (9 DOWNTO 0);
	  signal score_l: STD_LOGIC_VECTOR(2 DOWNTO 0);
	  signal score_r: STD_LOGIC_VECTOR(2 DOWNTO 0);
	  signal enable: STD_LOGIC;
	  
begin
    
	  Inst_sync_mod: sync_mod PORT MAP( 
			clk => clk,
			reset => reset,
			start => '1',
			y_control => yc,
			x_control => xc,
			h_s => hsn,
			v_s => vsn,
			En => enable,
			video_on => video );
		
	  Inst_game: game PORT MAP(
			  clk => clk,
           rst => reset,
           u => up,
           d => down,
			  En => enable,
			  start => start,
			  ball_x => bx, 
			  ball_y => by,
			  p1_score => score_l, 
			  p2_score => score_r,
           pos => p);
		
		Inst_VGA_display: VGA_display PORT MAP(
			x_counter => xc,
			y_counter => yc,
			p1_score => score_l, 
			p2_score => score_r,
			ball_x => bx,
			ball_y => by,
			bar_left => p,
			bar_right => p,
			RGB => rgb_next);

		
		rgb <= rgb_next when video = '1' else "000";

end Behavioral;