----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2022 02:14:07 PM
-- Design Name: 
-- Module Name: flipflop_jk_ms - Behavioral
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

entity flipflop_jk_ms is
    Port ( PR : in STD_LOGIC;
           CLR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           J : in STD_LOGIC;
           K : in STD_LOGIC;
           Q : out STD_LOGIC;
           not_Q : out STD_LOGIC);
end flipflop_jk_ms;

architecture Behavioral of flipflop_jk_ms is
    
    signal q_val: STD_LOGIC;
    signal counter: integer range 0 to 100000000 := 0;
    signal clock_div: STD_LOGIC := '0';
    
begin
    Q <= q_val;
    not_Q <= not q_val;
    
    clk_div: process(CLK)
    begin
        if rising_edge(CLK) then
            counter <= counter + 1;
            if counter = 100000000 then 
                counter <= 1;
                clock_div <= not clock_div;
            end if;
        end if;
    end process;
    
    ff: process(clock_div,PR,CLR)
    begin
        if rising_edge(clock_div) and PR ='0' and CLR='0' then   --esse if so roda quando o clock esta na borda de subida, dando preferencia para PR e CLR 
            
            if J='0' and K='1' then
                q_val <= '1';
            elsif J='1' and K='0' then
                q_val <= '0';
            elsif J='0' and K='0' then
                q_val <= not q_val;
            end if;  
               
        end if;
    
        if PR='1' then
            q_val <= '1';   
        elsif CLR='1' then
            q_val <= '0';
        end if;
        
    end process;
    
end Behavioral;
