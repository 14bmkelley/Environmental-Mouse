----------------------------------------------------------------------------------
-- Team: The Team Formally Known as Queen
-- Engineers: Brandon Kelley, Ignacio DeAnquin, Alan Nonaka and Anthony Velasquez
-- 
-- Create Date: December 3, 2015
-- Design Name: Environmental Mouse
-- Module Name: environmental_mouse.vhdl
-- Project Name: Environmental Mouse
-- Target Devices: Basys 3
-- Tool versions: Vivado 14.4
-- Description: This module controls the power of a PS/2 mouse, shutting it off
--    if it is found to be inactive.
-- Dependencies:
--    Hardware:
--      * Computer with Vivado software
--      * Basys 3 circuit board
--      * PS/2 mouse
--      * Jumper wires
--      * LEDs and resistors
--      * NPN Transistor
--    Software:
--      * Clock frequency divider
-- Version: 1.0.0
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Environmental mouse port description
entity environmental_mouse is
   port (
      ps2_data    : in  std_logic; -- Data from the mouse to read signal
      board_clk   : in  std_logic; -- Clock from board to keep processes in time
      board_btn   : in  std_logic; -- Button from board to turn mouse back on
      red_led     : out std_logic; -- LED lit up when mouse is turned off
      yellow_led  : out std_logic; -- LED lit up when mouse is waiting to turn off
      green_led   : out std_logic; -- LED lit up when mouse is active
      mouse_power : out std_logic  -- Signal controlling power to the mouse
   );
end environmental_mouse;

-- Environmental mouse architecture description
architecture arch of environmental_mouse is
   
   -- Clock divider port description
   component clk_div2 is
      port (
         clk  : in  std_logic; -- Input clock
         sclk : out std_logic  -- Output (divided) clock
      );
   end component;
   
   -- Power checker port description
   component nas_counter is
      port (
         nas_data   : in  std_logic; -- Data used to reset counter
         nas_clk    : in  std_logic; -- Clock used to keep processes in time
         nas_btn    : in  std_logic; -- Button used to reset counter
         nas_red    : out std_logic; -- Signal used to show mouse is in off state
         nas_yellow : out std_logic; -- Signal used to show mouse is in waiting state
         nas_green  : out std_logic  -- Signal used to show mouse is in on state
      );
   end component;
   
   -- Signals used to store intermediate values
   signal slow_clk : std_logic; -- The divided clock
   signal red      : std_logic; -- The red led output
   signal yellow   : std_logic; -- The yellow led output
   signal green    : std_logic; -- The green led output
   
begin
   
   -- Divide the clock to a usable speed
   clk_divider : clk_div2
   port map (
      clk  => board_clk,
      sclk => slow_clk
   );
   
   -- Check which state the system is in
   power_checker : nas_counter
   port map (
      nas_data   => ps2_data,
      nas_clk    => slow_clk,
      nas_btn    => board_btn,
      nas_red    => red,
      nas_yellow => yellow,
      nas_green  => green
   );
   
   -- Assign appropriate output values
   red_led     <= red;
   yellow_led  <= yellow;
   green_led   <= green;
   mouse_power <= yellow or green;
   
end arch;
