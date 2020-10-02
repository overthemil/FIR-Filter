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
  constant h0 : signed(7 downto 0) := "11110010";
  constant h1 : signed(7 downto 0) := "00011000";
  constant h2 : signed(7 downto 0) := "00110000";
  constant h3 : signed(7 downto 0) := "00011000";
  constant h4 : signed(7 downto 0) := "11110010";

  signal x_in : signed (7  downto 0) := (others => '0');
  signal y_out : signed (7 downto 0) := (others => '0'); 
  signal M0,M1,M2,M3,M4 : signed(15 downto 0) := (others => '0');
  signal add1,add2,add3,add4 : signed(15 downto 0) := (others => '0');
  signal Q1,Q2,Q3,Q4 : signed(15 downto 0) := (others => '0');

begin            
  -- multipliers
  -- add code here to perform multiplications
  M0 <= h0 * x_in;
  M1 <= h1 * x_in;
  M2 <= h2 * x_in;
  M3 <= h3 * x_in;
  M4 <= h4 * x_in;

  -- adders
  -- add code here to perform additions
  add1 <= M3 + Q1;
  add2 <= M2 + Q2;
  add3 <= M1 + Q3;
  add4 <= M0 + Q4;
  
  x_in <= signed(data_in);
  y_out <= add4(14 downto 7);
  
  P_DATA_OUT: process(clk, rst_n)
    begin            
        if rising_edge(clk) then
            if (data_in_vld = '1') then                            
                data_out_vld <= '1';         

                -- add code here to perform delays		 
                Q1 <= M4;
                Q2 <= add1;
                Q3 <= add2;
                Q4 <= add3;
                
                data_out <= std_logic_vector(y_out);         
            else 
                data_out_vld <= '0';   
            end if;     
        end if;
    end process;
end behav;