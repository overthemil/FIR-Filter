library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_FIR_filter is
	generic (
	    NUM_CONSTANTS   : INTEGER := 29;
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
    component filter_comp is 
        Port(   D        : in signed(15 downto 0);
                Q        : out signed(15 downto 0);
                h        : in signed(7 downto 0); 
                x        : in signed (7 downto 0); 
                out_vld  : out std_logic;
                in_vld   : in std_logic;
                CLK      : in std_logic);
    end component;
    
    type filter_type_eight is array(0 to NUM_CONSTANTS-1) OF signed(7 downto 0);
    type filter_type_sixteen is array(0 to NUM_CONSTANTS-1) OF signed(15 downto 0);
    
    constant h_values : filter_type_eight := (  "00000000",
                                                "00000000",
                                                "00000000",
                                                "00000000",
                                                "00000000",
                                                "00000001",
                                                "00000010",
                                                "00000100",
                                                "00000101",
                                                "00000111",
                                                "00001000",
                                                "00001010",
                                                "00001011",
                                                "00001100",
                                                "00001100",
                                                "00001100",
                                                "00001011",
                                                "00001010",
                                                "00001000",
                                                "00000111",
                                                "00000101",
                                                "00000100",
                                                "00000010",
                                                "00000001",
                                                "00000000",
                                                "00000000",
                                                "00000000",
                                                "00000000",
                                                "00000000");
    
    
    signal x_in : signed (7  downto 0) := (others => '0');
    signal y_out : signed (15 downto 0) := (others => '0'); 
    signal add: filter_type_sixteen;
    signal Q: filter_type_sixteen;
begin            
    x_in <= signed(data_in);
    
    FILTER_GEN: for i in 0 to NUM_CONSTANTS-1 generate
        Q1: if i=0 generate
            U0: filter_comp
                port map (
                    D => "0000000000000000",
                    Q => Q(0),
                    h => h_values(0),
                    x => x_in,
                    out_vld => data_out_vld,
                    in_vld => data_in_vld,
                    CLK => CLK
                );
        end generate Q1;
        
        Q_FILTER: if i>0 generate
            UZ: filter_comp
                port map (
                    D => Q(i-1),
                    Q => Q(i),
                    h => h_values(i),
                    x => x_in,
                    out_vld => data_out_vld,
                    in_vld => data_in_vld,
                    CLK => CLK                    
                );
        end generate Q_FILTER;
    end generate FILTER_GEN;
    
    P_DATA_OUT: process(clk)
    begin            
        if rising_edge(clk) then
            if (data_in_vld = '1') then                            
                data_out_vld <= '1';         
                
                y_out <= Q(NUM_CONSTANTS-1);
                data_out <= std_logic_vector(y_out(14 downto 7));         
            else 
                data_out_vld <= '0';   
            end if;     
        end if;
    end process;
end behav;