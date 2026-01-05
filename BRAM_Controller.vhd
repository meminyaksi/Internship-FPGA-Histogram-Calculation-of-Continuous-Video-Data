library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BRAM_Controller is
    Port ( f_val : in STD_LOGIC;
           d_val : in STD_LOGIC;
           data  : in STD_LOGIC_VECTOR (7 downto 0);
           clk   : in std_logic;   
           reset : in std_logic;
                               			 
           wr_addr : out std_logic_vector(7 downto 0);     
           wr_data  : out std_logic_vector(16 downto 0);		
           wr_int   : out std_logic;                      
           
--           addra_2 : out std_logic_vector(7 downto 0);  
--           dina_2  : out std_logic_vector(7 downto 0);		  
--           wea_2   : out std_logic;                       			
           
           rd_addr : out std_logic_vector(7 downto 0);    
           enb_1   : out std_logic;                       	
           rd_data : in std_logic_vector(16 downto 0);   	
           wr_txt_data : out std_logic_vector(16 downto 0)   	
--           addrb_2 : out std_logic_vector(7 downto 0);  
--           enb_2   : out std_logic;                      
--           doutb_2 : in std_logic_vector(7 downto 0);  
            
            
          );
end BRAM_Controller;

architecture Behavioral of BRAM_Controller is
    signal c: std_logic:='0';  
    signal dval_delay_1: std_logic:='0';  
    signal dval_delay_2: std_logic:='0';  
    signal fval_delay_2: std_logic:='0';  
    signal f_val_prev: std_logic:='0';  
    signal fval_delay_1: std_logic:='0';      
    signal data_delay_2: std_logic_vector(7 downto 0) := "10000000";  
    signal data_delay_1: std_logic_vector(7 downto 0) := "01000000";  
    signal data_counter: integer range 0 to 255 := 0; 
    signal data_counter_save: integer:= 0; 
    signal every_other: std_logic := '0';
    signal every_other_delay: std_logic := '0';
    signal flag: std_logic := '0';
    signal flag_int: integer:= 0;
    signal wr_int_internal : std_logic;
    signal wr_addr_internal : std_logic_vector(7 downto 0);
    signal rd_addr_internal : std_logic_vector(7 downto 0);
    signal wr_data_internal : std_logic_vector(16 downto 0);
    signal read_start,read_start_delay1, read_start_delay2, read_start_delay3 :std_logic:= '0';
    signal read_counter: integer:= 0;
begin

  wr_int  <= wr_int_internal;
  wr_addr <= wr_addr_internal;
  rd_addr <= rd_addr_internal;
  wr_data <= wr_data_internal;
  
process(Clk) is
begin
    if rising_edge(Clk) then
        enb_1 <= '1';
        if reset = '1' then
            data_delay_2 <= (others => '0');
            data_delay_1 <= (others => '0');
            wr_addr_internal <= (others => '0');
            wr_data_internal <= (others => '0');
            wr_int_internal <= '0';
            enb_1 <= '0';
            data_counter <= 0;
            rd_addr_internal <= (others => '0');
        else
            dval_delay_1 <= d_val;
            dval_delay_2 <= dval_delay_1;
            fval_delay_1 <= f_val;
            fval_delay_2 <= fval_delay_1;
            rd_addr_internal<=data;
            data_delay_1 <= data;
            data_delay_2 <= data_delay_1;
            f_val_prev <= fval_delay_2;
            
            read_start_delay1 <= read_start;
            read_start_delay2 <= read_start_delay1;
            read_start_delay3 <= read_start_delay2;
            
            wr_int_internal <= fval_delay_2 and dval_delay_2;
            if data_delay_2 /= data_delay_1 then
                wr_addr_internal <= data_delay_2;  
                if flag = '1' then
                    wr_data_internal <= std_logic_vector(to_unsigned(flag_int + 1 + data_counter, wr_data_internal'length));
                    flag <= not (fval_delay_2 and dval_delay_2);
                else
                    wr_data_internal <= std_logic_vector(unsigned(rd_data) + to_unsigned(1 + data_counter, wr_data_internal'length));
                end if;
                data_counter <= 0;
            else
      
                wr_int_internal <= '0';
                if fval_delay_2 = '1' and dval_delay_2 = '1' then 
                    data_counter <= data_counter + 1;
                end if;
     
            end if;
            
            if wr_int_internal = '1' and (wr_addr_internal = rd_addr_internal) and f_val = '1' then
                flag <= '1';
                flag_int <= TO_INTEGER(unsigned(wr_data_internal));
            end if;

            if (f_val_prev = '1') and (fval_delay_2 = '0') then
                wr_addr_internal <= data_delay_2; 
                wr_int_internal <= '1';
                read_start <= '1';
                if flag = '1' then
                    wr_data_internal <= std_logic_vector(to_unsigned(flag_int + data_counter, wr_data_internal'length));
                    flag <= '0';
                else
                    wr_data_internal <= std_logic_vector(unsigned(rd_data) + to_unsigned(data_counter, wr_data_internal'length));
                end if;
                data_counter <= 0;
            end if;
            
            if read_start_delay3 = '1' then
                if read_counter < 256 then 
                    wr_txt_data <= rd_data;
                    rd_addr_internal <= std_logic_vector(to_unsigned(read_counter, wr_addr_internal'length));
                    wr_addr_internal <= std_logic_vector(to_unsigned(read_counter, wr_addr_internal'length));
                    wr_data_internal <= (others => '0'); 
                    wr_int_internal <= '1';
                    enb_1 <= '1';
                    read_counter <= read_counter + 1;
                    flag <= '0';
                else
                    read_counter <= 0;
                    enb_1 <= '0';
                    wr_int_internal <= '0';
                    read_start <= '0';
                    read_start_delay1 <= '0';
                    read_start_delay2 <= '0';
                    read_start_delay3 <= '0';
                end if;      
            end if;
            
        end if;       
    end if;
end process;


end Behavioral;

































