library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE std.textio.all;

entity xilinx_simple_dual_port_1_clock_ram is
generic (
    RAM_WIDTH : integer := 64;                      -- Specify RAM data width
    RAM_DEPTH : integer := 512                -- Specify RAM depth (number of entries)                       -- Specify name/location of RAM initialization file if using one (leave blank if not)
    );

port (
        addra : in std_logic_vector(17 downto 0);     -- Write address bus, width determined from RAM_DEPTH
        addrb : in std_logic_vector(17 downto 0);     -- Read address bus, width determined from RAM_DEPTH
        dina  : in std_logic_vector(RAM_WIDTH-1 downto 0);		  -- RAM input data
        clka  : in std_logic;                       			  -- Clock
        wea   : in std_logic;                       			  -- Write enable
        enb   : in std_logic;                       			  -- RAM Enable, for additional power savings, disable port when not in use
        doutb : out std_logic_vector(RAM_WIDTH-1 downto 0)   			  -- RAM output data
    );

end xilinx_simple_dual_port_1_clock_ram;
 
architecture rtl of xilinx_simple_dual_port_1_clock_ram is

constant C_RAM_WIDTH : integer := RAM_WIDTH;
constant C_RAM_DEPTH : integer := RAM_DEPTH;

signal doutb_reg : std_logic_vector(C_RAM_WIDTH-1 downto 0) := (others => '0');
type ram_type is array (C_RAM_DEPTH-1 downto 0) of std_logic_vector (C_RAM_WIDTH-1 downto 0);    

signal ram_name : ram_type :=(others=>(others=>'0'));

begin

process(clka)
begin
    if(clka'event and clka = '1') then

        if(wea = '1') then
            ram_name(to_integer(unsigned(addra))) <= dina;
        end if;
        if(enb = '1') then
                doutb  <= ram_name(to_integer(unsigned(addrb)));
        end if;
           end if;
end process;
 


end rtl;
