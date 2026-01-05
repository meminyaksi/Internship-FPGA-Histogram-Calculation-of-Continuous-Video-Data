library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRAM_2 is

port (
        addra_2 : in std_logic_vector(7 downto 0);   
        dina_2  : in std_logic_vector(16 downto 0);
        clka  : in std_logic;                      
        wea_2   : in std_logic;                      
     
        addrb_2 : in std_logic_vector(7 downto 0);  
        enb_2   : in std_logic;                      
        doutb_2 : out std_logic_vector(16 downto 0)  
        
    );

end BRAM_2;

architecture rtl of BRAM_2 is

constant C_RAM_WIDTH : integer := 17;
constant C_RAM_DEPTH : integer := 256;

signal douta_reg : std_logic_vector(C_RAM_WIDTH-1 downto 0) := (others => '0');
type ram_type is array (C_RAM_DEPTH-1 downto 0) of std_logic_vector (C_RAM_WIDTH-1 downto 0);
signal ram_name : ram_type := (others => (others => '0'));


begin


process(clka)
begin
    if(clka'event and clka = '1') then
        if(wea_2 = '1') then
            ram_name(to_integer(unsigned(addra_2))) <= dina_2;
        end if;
        if(enb_2 = '1') then
                doutb_2  <= ram_name(to_integer(unsigned(addrb_2)));
        end if;
    end if;
end process;

end rtl;
