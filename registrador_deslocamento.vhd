----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2022 04:40:58 PM
-- Design Name: 
-- Module Name: registrador_deslocamento - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registrador_deslocamento is
    Port ( JB : in STD_LOGIC_VECTOR (7 downto 0); 
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           DR_IN : in STD_LOGIC;
           DL_IN : in STD_LOGIC;
           clk : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (7 downto 0)); 
end registrador_deslocamento;

architecture Behavioral of registrador_deslocamento is
    signal COUNTER: integer range 0 to 100000000 := 0;
    signal d_out_val: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    signal DIVISORCLOCK : STD_LOGIC;
    
begin
    led <= d_out_val;
    clk_div: process(clk)
    begin
        if rising_edge(clk) then
            COUNTER <= COUNTER + 1;
            if COUNTER = 100000000 then 
                COUNTER <= 1;
                DIVISORCLOCK <= not DIVISORCLOCK;
            end if;
        end if;
    end process;
    
    registrador: process(DIVISORCLOCK)
    begin
                if rising_edge(DIVISORCLOCK) then
                    CASE SEL IS
                        WHEN "00" => d_out_val <= d_out_val;
                        WHEN "01" => d_out_val <= JB;
                        WHEN "10" => d_out_val <= DL_IN & d_out_val(7 downto 1);
                        WHEN "11" => d_out_val <= d_out_val(6 downto 0) & DR_IN;
                        WHEN OTHERS => d_out_val <= "00000000";
                    END CASE;

                end if;
    end process;
    
end Behavioral;

