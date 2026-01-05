library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity read_video_ram is

  generic(
     RAM_WIDTH       : integer := 8;
     RAM_DEPTH       : integer := 262144
  );

  Port (
    clk   : in std_logic;                              
    enb   : out std_logic;                             
    addrb : out std_logic_vector(17 downto 0);          
    doutb : in std_logic_vector(7 downto 0); 
    reset : in std_logic;
    f_val: out std_logic;                          
    d_val: out std_logic;                          
    data: out std_logic_vector(7 downto 0)       
                                  
  );
  
end read_video_ram;

architecture Behavioral of read_video_ram is

constant frame_width: integer := 400; 
constant frame_height: integer := 300;
constant dval_on_time: integer := frame_width;
signal dval_counter: integer := 0;
signal dval_on_counter: integer := 0;

signal fval_counter: integer := 0; 
constant fval_on_time: integer := frame_width*frame_height + frame_height+2;
constant fps: integer := 30;
constant fps_counter_lim: integer := 100000000/fps; 

signal offset: integer := 120000;
signal addr_counter: integer := 0;
constant addr_counter_lim: integer := frame_width*frame_height;
signal  addr_inc: std_logic:= '1';

begin


process(clk) begin
if rising_edge(clk) then
    
    if reset = '1' then
        addrb <=  (others => '0') ;
        enb   <= '0';
        data        <= (others => '0');
        f_val       <=  '0';
        d_val       <=  '0';
            
    else
        if fval_counter < fval_on_time then
        
            f_val <= '1';
            enb <= '1';
            data <= doutb;
            
            if fval_counter < fval_on_time - 3 then
                if addr_inc = '1' then
                    if addr_counter < addr_counter_lim then
                        if addr_counter = addr_counter_lim - 1  then 
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
                    addrb <= std_logic_vector(to_unsigned(addr_counter + offset, addrb'length));
                end if;
            end if;

            
            
            
            
            if fval_counter > 1 then
                if dval_on_counter < dval_on_time then
                    if dval_on_counter = dval_on_time - 2 then
                        addr_inc <= '0';
                    else
                        addr_inc <= '1';
                    end if;
                
                    d_val <= '1';
                    dval_on_counter <= dval_on_counter + 1;
      
                else
                    addr_inc <= '1';
                    d_val <= '0';
                    dval_on_counter <= 0;
                    
                end if;

            end if;
            
            fval_counter <= fval_counter + 1;
            
        elsif fval_counter < fps_counter_lim  then
            addr_inc <= '1';
            f_val <= '0';
            d_val <= '0';
            enb <= '0';

            if fval_counter = fps_counter_lim - 1 then
                fval_counter <= 0;
            else
                fval_counter <= fval_counter + 1;
            end if;
            
        end if;
        

 
  
        
       
       
       
       
       
       
       
        
    end if;  
end if;
  

end process;
end Behavioral;
