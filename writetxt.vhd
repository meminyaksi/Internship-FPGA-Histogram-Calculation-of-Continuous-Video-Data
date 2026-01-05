library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use STD.TEXTIO.ALL;
use ieee.std_logic_textio.all;

entity writetxt is
generic(
 RAM_WIDTH       : integer := 17;
 RAM_DEPTH       : integer := 262144
);
Port(
clk   : in std_logic;
data : in std_logic_vector(RAM_WIDTH-1 downto 0);
f_val: in std_logic;                          
d_val: in std_logic;           
reset : in std_logic 

);
end writetxt;

architecture Behavioral of writetxt is

    file outfile : text open write_mode is "output.txt";
    signal data_int: integer;    
begin
    

process(clk)

  variable out_line : line;
  
begin

if rising_edge(clk) then
        data_int <= TO_INTEGER(unsigned(data));
        if data_int /= 0 then
            write(out_line, data_int);
            writeline(outfile, out_line);     
        end if;   
end if;



end process;

end Behavioral;

