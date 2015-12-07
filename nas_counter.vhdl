----------------------------------------------------------------------------------
-- Team: The Team Formally Known as Queen
-- Engineers: Brandon Kelley, Ignacio DeAnquin, Alan Nonaka and Anthony Velasquez
-- 
-- Create Date: December 3, 2015
-- Design Name: Environmental Mouse
-- Module Name: nas_counter.vhdl
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

-- Power checker port description
entity nas_counter is
   port (
      nas_data   : in  std_logic; -- Data used to reset counter
      nas_clk    : in  std_logic; -- Clock used to keep processes in time
      nas_btn    : in  std_logic; -- Button used to reset counter
      nas_red    : out std_logic; -- Signal used to show mouse is in off state
      nas_yellow : out std_logic; -- Signal used to show mouse is in waiting state
      nas_green  : out std_logic  -- Signal used to show mouse is in on state
   );
end nas_counter;

-- Power checker architecture description
architecture nas_arch of nas_counter is
  
  -- Signal used to track the state of the mouse
  signal counter : integer := 0;
  
begin
   
   -- Start the checker
   check : process (nas_data, nas_clk, counter) begin
      
      -- Only check on clock signal to keep time
      if rising_edge(nas_clk) then
         
         -- Reset counter if there is mouse data or the button is pressed
         if nas_data = '0' or nas_btn = '1' then
            counter <= 0;
         
         -- Otherwise, increment counter
         else
            counter <= counter + 1;
         end if;
         
      end if;
      
      -- Check for off state
      if counter > 100000 then
         nas_red <= '1';
      else
         nas_red <= '0';
      end if;
      
      -- Check for waiting state
      if (counter < 100000) and (counter > 1000) then -- yellow
         nas_yellow <= '1';
      else
         nas_yellow <= '0';
      end if;
      
      -- Check for on state
      if (counter < 1000) then
         nas_green <= '1';
      else
         nas_green <= '0';
      end if;
      
   end process check;

end nas_arch;
