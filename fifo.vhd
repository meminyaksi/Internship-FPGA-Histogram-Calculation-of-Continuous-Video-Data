library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo is
    Port ( clk      :  in STD_LOGIC;
           reset    :  in STD_LOGIC;
           f_val    :  in STD_LOGIC;
           d_val    :  in STD_LOGIC;
           data     :  in std_logic_vector(7 downto 0);
           data_out :  out std_logic_vector(7 downto 0));
end fifo;

architecture Behavioral of fifo is

type memory is array (0 to 255) of std_logic_vector(7 downto 0);
signal mem: memory := (others => (others=>'0'));

signal write_addr: std_logic_vector(7 downto 0) := (others=>'0');
signal read_addr: std_logic_vector(7 downto 0) := (others=>'0');
signal read_write: std_logic := '1';  --0 read 1 write
signal f_val_prev: std_logic := '0';

begin


process(clk) begin
    if reset = '1' then

    elsif rising_edge(clk) then
        if (f_val and d_val) = '1' then
            f_val_prev <= '1';
            if read_write = '0' then                                         -- read
                data_out <= mem(TO_INTEGER(unsigned(read_addr)));
                read_addr <= std_logic_vector(unsigned(read_addr) + 1);
            else                                                             --write
                mem(TO_INTEGER(unsigned(write_addr))) <= data;
                write_addr <=  std_logic_vector(unsigned(write_addr) + 1);
            end if;
        else
            if f_val_prev  = '1' then
                read_write <= not read_write;
            end if;
        end if;
    end if;
end process;
end Behavioral;