library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_FIR_filter is
	generic (
        G_DATA_WIDTH    : INTEGER := 32
    );
	port(   
		CLK          : in std_logic;
        rst_n        : in std_logic;
        data_in      : in std_logic_vector(G_DATA_WIDTH-1 downto 0); --input signal
        data_in_vld  : in std_logic;
        data_out     : out std_logic_vector(G_DATA_WIDTH-1  downto 0);  --filter output
        data_out_vld : out std_logic
    );
end my_FIR_filter;

architecture behav of my_FIR_filter is

	--Data PIPELINE internal signal
    signal pipe_2_vld    : STD_LOGIC;
    signal pipe_2_data   : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 00);    

begin                		                     	                     
    -- At the moment this is a pipeline that just copies input to output.
    -- This module can be replaced by your filter        
    P_DATA_OUT : process ( clk, rst_n )
        begin
            if ( rst_n = '0' ) then                    
    
                pipe_2_vld        <= '0';
                pipe_2_data       <= ( others=>'0' );        
                data_out_vld      <= '0';
                data_out          <= ( others=>'0' );
                                
            elsif rising_edge( clk ) then
                    if ( data_in_vld    = '1' ) then 
                        pipe_2_vld    <= '1';                                        
                        pipe_2_data    <= data_in;
                    else
                        pipe_2_vld        <= '0';                
                    end if;
                
                    if ( pipe_2_vld='1' ) then 
                        data_out_vld    <= '1';                    
                        data_out        <= pipe_2_data;            
                    else
                        data_out_vld    <= '0';                    
                    end if;
                              
            end if;    
        end process;        
end behav;
