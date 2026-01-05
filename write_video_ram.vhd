library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity write_video_ram is
  Port (
  f_val: in std_logic;
  d_val: in std_logic;
  data: in std_logic_vector(7 downto 0);
  addra: out std_logic_vector(17 downto 0);
  dina : out std_logic_vector(7 downto 0);
  wea : out std_logic; 
  reset : in std_logic;
  clk : in std_logic
   );
end write_video_ram;

architecture Behavioral of write_video_ram is

constant frame_width: integer := 400; 
constant frame_height: integer := 300;
signal offset: integer := 0;
signal addr_counter: integer := 0;
constant addr_counter_lim: integer := frame_width*frame_height;


begin

process(clk) begin

if rising_edge(clk) then

    if reset = '1' then
        addra <=  (others => '0') ;
        dina  <=  (others => '0') ;
        wea   <= '0';
         
    else
        if (f_val and d_val) = '1' then
            if addr_counter < addr_counter_lim then
                if addr_counter = addr_counter_lim - 1 then
                    addr_counter <= 0;
                    if offset = 0 then
                        offset <= 120000;
                    else
                        offset <= 0;
                    end if;
                else 
                    addr_counter <= addr_counter + 1;
                end if;
            end if;
            addra <= std_logic_vector(to_unsigned(addr_counter + offset, addra'length));
            wea <= '1';
            dina <= data; 
        else
            wea <= '0';
        end if;
    end if;
end if;

end process;

end Behavioral;




--if rising_edge(clk) then
    
--    if f_val = '1' and d_val = '1' then

--            if col_count < frame_width then
--                addra <= std_logic_vector(to_unsigned((row_count * frame_width) + col_count + to_integer(unsigned(offset)), addra'length));
--                col_count <= col_count + 1;       
--                wea <= '1';
--                dina <= data;     
--            else
--                col_count <= 0;
--                if row_count < frame_height then
--                    row_count <= row_count + 1;
--                else
--                    row_count <= 0;
--                    if  offset = "011101010011000000" then
--                        offset <= "000000000000000000";
--                    elsif offset = "000000000000000000" then
--                        offset <= "011101010011000000";
--                    end if;
--                end if;
--            end if;       
--    else
--        wea <= '0';
--    end if;
--end if;
