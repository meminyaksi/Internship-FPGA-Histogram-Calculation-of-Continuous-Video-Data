library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

entity readtxt is
generic(
 RAM_WIDTH       : integer := 8;
 RAM_DEPTH       : integer := 262144
);
Port(
clk : in std_logic;
data : out std_logic_vector(RAM_WIDTH-1 downto 0);
reset : in std_logic;
f_val: out std_logic;
d_val: out std_logic
);

end readtxt;

architecture Behavioral of readtxt is

file stim_file : text open read_mode is "stimulus.txt";

constant frame_width: integer := 400; 
constant frame_height: integer := 300;
constant dval_on_time: integer := frame_width;
signal dval_counter: integer := 0;
signal dval_on_counter: integer := 0;

signal fval_counter: integer := 0; 
constant fval_on_time: integer := frame_width*frame_height + frame_height;
constant fps: integer := 30;
constant fps_counter_lim: integer := 100000000/fps; 
--signal d_val_1: std_logic:= '0';
--signal d_val_2: std_logic:= '0';
--signal f_val_1: std_logic:= '0';
--signal f_val_2: std_logic:= '0';

begin
  stim_proc: process(clk)
    variable line_buf    : line;
    variable data_slv    : std_logic_vector(RAM_WIDTH-1    downto 0);
  begin

if rising_edge(clk) then
--   d_val_1 <= d_val_2;
--   d_val   <= d_val_1;
--   f_val_1 <= f_val_2;
--   f_val   <= f_val_1;
    if reset = '1' then
        data        <= (others => '0');
        f_val       <=  '0';
        d_val       <=  '0';
    else 
    
        if not endfile(stim_file) then
            if fval_counter < fval_on_time then
                f_val <= '1';
                fval_counter <= fval_counter + 1;
            elsif fval_counter < fps_counter_lim then
                f_val <= '0';
                if fval_counter = fps_counter_lim - 1 then
                    fval_counter <= 0;
                else
                    fval_counter <= fval_counter + 1;
                end if;
            end if;
            
            if dval_counter < fval_on_time then
                if dval_on_counter < dval_on_time then
                    d_val <= '1';
                    readline(stim_file, line_buf);
                    read(line_buf, data_slv);
                    data <= data_slv;
                    dval_on_counter <= dval_on_counter + 1;
                else    
                    d_val <= '0';
                    dval_on_counter <= 0;
    
                end if;
                dval_counter <= dval_counter + 1;
                
            elsif dval_counter < fps_counter_lim then
                d_val <= '0';
                if dval_counter = fps_counter_lim - 1 then
                    dval_counter <= 0;
                else
                    dval_counter <= dval_counter + 1;
                end if;
            end if;
        else
            f_val <= '0';
            d_val <= '0';
        end if;    
    end if;
end if;
    
    

end process stim_proc;

end Behavioral;
