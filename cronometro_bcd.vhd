

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cronometro_bcd is
    Port ( start : in STD_LOGIC;
           pause : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC);  
end cronometro_bcd;

architecture Behavioral of cronometro_bcd is

    component driverBCD
        Port ( sw : integer range 0 to 9;
               seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    signal mSegundos: integer range 0 to 9 :=0;
    signal dSegundos: integer range 0 to 5 :=0;
    signal minutos: integer range 0 to 9 :=0;
    signal segundosfinal: integer range 0 to 9 :=0;
    signal counter: integer range 0 to 33333333 :=0;
    signal counter2: integer range 1 to 100000 :=1;
    signal counter3: integer range 1 to 3 :=1;
    signal anodo: integer range 0 to 2 :=0;
    signal s_an:  STD_LOGIC_VECTOR (3 downto 0);
    signal pp : integer range 0 to 1:=1;
    
begin

    anclk: process(clk)  
    begin
        if rising_edge(clk) then
        counter2 <= counter2 +1;
            if counter2=100000 then
                counter2 <= 1;
                anodo <= anodo+1;
                    case anodo is
                        when 0 => s_an <= "1110"; 
                        when 1 => s_an <= "1101";
                        when 2 => s_an <= "1011";
                        when others => null;   
                    end case;
            end if;           
        end if;
    end process;
      
    divisor_clk: process(clk, reset, start, pause)
    begin
        if rising_edge(clk) then
            if start='1' then
                pp<=0; 
            end if;
            
            if pause='1' then
                pp<=1;
            end if;
            
--            if pp=1 then
--                counter3 <= 1; 
--            end if;
            if reset='1' then
                counter3 <= 1;
                mSegundos <= 0;
                dSegundos <= 0;
                minutos<=0;   
            end if;  
            
            if pp=1 then
                 
            else
                counter <= counter +1;
                if counter=33333333 then
                    counter <= 1;
                    counter3 <= counter3 +1;
                    if counter3=3 then
                        counter3 <= 1;
                        if mSegundos=9 then
                                if dSegundos=5 then
                                minutos <= minutos+1;
                                mSegundos <= 0;
                                dSegundos <= 0;
                                else
                                dSegundos <= dSegundos +1;
                                mSegundos <= 0;  
                                end if;
                        else
                            mSegundos <= mSegundos+1; 
                        end if;  
                    end if; 
                end if;
            end if;         
        end if;
    end process;
    
    an<= s_an;
    with s_an select
        segundosfinal <=    mSegundos when "1110",
                            dSegundos when "1101",
                            minutos when "1011",
                            0 when others;  
       
    dr_bcd: driverBCD port map(sw => segundosfinal, seg=>seg);
    dp <= '0';
end Behavioral;
