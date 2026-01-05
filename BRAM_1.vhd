library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRAM_1 is

port (
        addra_1 : in std_logic_vector(7 downto 0);
        dina_1  : in std_logic_vector(16 downto 0);		  
        clka  : in std_logic;                       			  
        wea_1   : in std_logic;                       			  
       
        addrb_1 : in std_logic_vector(7 downto 0);    
        enb_1   : in std_logic;                       	
        doutb_1 : out std_logic_vector(16 downto 0)   	
        
        
    );

end BRAM_1;

architecture rtl of BRAM_1 is

constant C_RAM_WIDTH : integer := 17;
constant C_RAM_DEPTH : integer := 256;

signal douta_reg : std_logic_vector(C_RAM_WIDTH-1 downto 0) := (others => '0');
type ram_type is array (C_RAM_DEPTH-1 downto 0) of std_logic_vector (C_RAM_WIDTH-1 downto 0);
signal ram_name : ram_type := (others => (others => '0'));

begin
    

process(clka)
begin
    if(clka'event and clka = '1') then
        if(wea_1 = '1') then
            ram_name(to_integer(unsigned(addra_1))) <= dina_1;
        end if;
        if(enb_1 = '1') then
                doutb_1  <= ram_name(to_integer(unsigned(addrb_1)));
        end if;
    end if;
end process;

end rtl;
