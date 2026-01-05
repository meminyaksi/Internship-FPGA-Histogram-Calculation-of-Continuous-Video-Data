library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.ALL;
use ieee.std_logic_textio.all;

entity top is
--  Port ( );
end top;

architecture Behavioral of top is

    constant RAM_WIDTH       : integer := 8;
    constant RAM_DEPTH       : integer := 262144;

    -- Signals
    signal addra   : std_logic_vector(17 downto 0) := (others => '0');
    signal addrb   : std_logic_vector(17 downto 0) := (others => '0');
    signal dina    : std_logic_vector(RAM_WIDTH-1 downto 0) := (others => '0');
    signal wea     : std_logic := '0';
    signal enb     : std_logic := '1';
    signal rstb    : std_logic := '0';
    signal regceb  : std_logic := '1';
    signal doutb   : std_logic_vector(RAM_WIDTH-1 downto 0);
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal data    : std_logic_vector(RAM_WIDTH-1 downto 0) := (others => '0');
    signal f_val : std_logic;
    signal d_val : std_logic;
    signal data_2    : std_logic_vector(RAM_WIDTH-1 downto 0) := (others => '0');
    signal f_val_2 : std_logic;
    signal d_val_2 : std_logic;      
    
    signal enb_1  : std_logic;
    signal addrb_1:STD_LOGIC_VECTOR (7 downto 0);
    signal doutb_1:STD_LOGIC_VECTOR (16 downto 0);
    signal addra_1:STD_LOGIC_VECTOR (7 downto 0);
    signal dina_1 : STD_LOGIC_VECTOR (16 downto 0);
    signal wea_1  : std_logic;

    signal enb_2  : std_logic;
    signal addrb_2:STD_LOGIC_VECTOR (7 downto 0);
    signal doutb_2:STD_LOGIC_VECTOR (16 downto 0);
    signal addra_2:STD_LOGIC_VECTOR (7 downto 0);
    signal dina_2 : STD_LOGIC_VECTOR (16 downto 0);
    signal wea_2  : std_logic;
    signal wr_txt_data : STD_LOGIC_VECTOR (16 downto 0);
begin

clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

reset_process : process
    begin
        while true loop
            reset <= '1';
            wait for 100 ns;
            reset <= '0';
            wait;
        end loop;
    end process;



--u_clk: entity work.clock
--port map (
--    clk => clk,
--    reset => reset
--);

ram_inst : entity work.xilinx_simple_dual_port_1_clock_ram
        generic map (
            RAM_WIDTH       => RAM_WIDTH,
            RAM_DEPTH       => RAM_DEPTH
        )
        port map (
            addra   => addra,
            addrb   => addrb,
            dina    => dina,
            clka    => clk,
            wea     => wea,
            enb     => enb,
            doutb   => doutb
        );
 readtxtinstantiation: entity work.readtxt

generic map (
    RAM_WIDTH => 8,
    RAM_DEPTH => 262144
  )
  port map (
    clk    => clk,
    data   => data,
    reset => reset,
    f_val =>  f_val,
    d_val =>  d_val

  );

write_video_raminstantiation: entity work.write_video_ram
port map (
 f_val => f_val,
 d_val => d_val,
 data  => data,
 addra => addra,
 dina  => dina ,
 wea   => wea ,
 reset => reset ,
 clk   => clk 
);


writetxtinstantiation: entity work.writetxt
generic map (
    RAM_WIDTH => 17,
    RAM_DEPTH => 262144
  )
  port map (
clk     => clk,
data    => wr_txt_data, 
f_val   => f_val_2,
d_val   => d_val_2,
reset   => reset


  );

read_video_raminstantiation: entity work.read_video_ram
generic map(
     RAM_WIDTH       => 8,
     RAM_DEPTH       => 262144
  )
  
  port map(
    clk   => clk,            
    enb   => enb,            
    addrb => addrb,          
    doutb => doutb,
    reset => reset,
    f_val => f_val_2,      
    d_val => d_val_2,      
    data => data_2    
                                  
);

BRAM_Controllerinstantiation: entity work.BRAM_Controller
  port map(
    clk   => clk,            
    enb_1   => enb_1,            
    rd_addr => addrb_1,          
    rd_data => doutb_1,
    reset => reset,
    f_val => f_val_2,      
    d_val => d_val_2,      
    data => data_2,   
    wr_addr => addra_1,
    wr_data  => dina_1 ,
    wr_int   => wea_1,
    wr_txt_data => wr_txt_data 
    
--    enb_2   => enb_2,            
--    rd_addr_2 => addrb_2,          
--    rd_data_2 => doutb_2,
--    wr_addr_2 => addra_2,
--    wr_data_2  => dina_2,
--    wr_int_2   => wea_2,
--    wr_data_txt => wr_data_txt 
    );


BRAM_1instantiation: entity work.BRAM_1
  port map(
    clka   => clk,            
    enb_1   => enb_1,            
    addrb_1 => addrb_1,          
    doutb_1 => doutb_1,
    addra_1 => addra_1,
    dina_1  => dina_1 ,
    wea_1   => wea_1 );
    
--BRAM_2instantiation: entity work.BRAM_2
--  port map(
--    clka   => clk,            
--    enb_2   => enb_2,            
--    addrb_2 => addrb_2,          
--    doutb_2 => doutb_2,
--    addra_2 => addra_2,
--    dina_2  => dina_2 ,
--    wea_2   => wea_2 );  

stim_proc: process(clk)

  begin
  
    if rising_edge(clk) then

    end if;

    
  end process stim_proc;


end Behavioral;
