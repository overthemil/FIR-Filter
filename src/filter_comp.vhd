----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.10.2020 13:24:43
-- Design Name: 
-- Module Name: filter_comp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter_comp is
    Port(   D        : in signed(15 downto 0) := (others => '0');
            Q        : out signed(15 downto 0) := (others => '0');
            h        : in signed(7 downto 0) := (others => '0'); 
            x        : in signed (7 downto 0) := (others => '0'); 
            out_vld  : out std_logic;
            in_vld   : in std_logic;
            CLK      : in std_logic);
end filter_comp;

architecture Behavioral of filter_comp is
begin
DATA_OUT: process(CLK)
    begin            
        if rising_edge(CLK) then
            if (in_vld = '1') then                            
                out_vld <= '1';         
                
                Q <= D + (h * x);


            else 
                out_vld <= '0';   
            end if;     
        end if;
    end process;
end Behavioral;
