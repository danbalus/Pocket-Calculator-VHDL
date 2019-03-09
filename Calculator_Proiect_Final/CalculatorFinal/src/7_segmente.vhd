library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity x7seg is 
	port(x: inout std_logic_vector(15 downto 0);
	clk: in std_logic;
	clr: in std_logic;
	a_to_g: out std_logic_vector (6 downto 0);
	semn: inout std_logic;
	an: out std_logic_vector (3 downto 0);
	sel: inout STD_LOGIC_VECTOR(1 downto 0);
	aUAL: inout STD_LOGIC_VECTOR(4 downto 0); 
    aUALB: inout STD_LOGIC_VECTOR(4 downto 0);
    --nr:inout std_logic_vector (4 downto 0);
    --switch: in std_logic;
    --astept: in std_logic;
	dp: out std_logic);
end x7seg;

architecture x7seg of x7seg is 

 
component bin2bcd_12bit 
    Port ( binIN : inout  STD_LOGIC_VECTOR (11 downto 0);
	       semn:inout std_logic;
           ones : inout  STD_LOGIC_VECTOR (3 downto 0);
           tens : inout  STD_LOGIC_VECTOR (3 downto 0);
		   aUAL: inout STD_LOGIC_VECTOR(4 downto 0); 
           aUALB: inout STD_LOGIC_VECTOR(4 downto 0);
		   sel: inout STD_LOGIC_VECTOR(1 downto 0);
		   --nr:inout std_logic_vector (4 downto 0);
           --switch: in std_logic;
           --astept: in std_logic;
           hundreds : inout  STD_LOGIC_VECTOR (3 downto 0);
           thousands : inout  STD_LOGIC_VECTOR (3 downto 0)
          );
end component;
  
signal s: std_logic_vector (1 downto 0);
signal digit: std_logic_vector (3 downto 0);
signal aen: std_logic_vector (3 downto 0);
signal clkdiv: std_logic_vector (19 downto 0);

begin 
	
   G8: bin2bcd_12bit port map (binin=>open, semn=>semn, ones=>x(3 downto 0), tens=>x(7 downto 4), 
	   hundreds => x(11 downto 8), thousands=>x(15 downto 12), aual=>aual, aualb=>aualb,sel=>sel);
	
	   s <= clkdiv(19 downto 18);	--selectia	pe 2 biti
	aen <= "1111";					 --anodul
	dp <= '1';
	
	-- mux 
	process(s, x)
	begin
		case s is 
			when "00" => digit <= x(3 downto 0);
			when "01" => digit <= x(7 downto 4);
			when "10" => digit <= x(11 downto 8);
			when others => digit <= x(15 downto 12);
		end case;
	end process;
	
	process(digit)
	begin 
	    case digit is 
			when "0000" => a_to_g <= "0000001";
			when "0001" => a_to_g <= "1001111";
			when "0010" => a_to_g <= "0010010";
			when "0011" => a_to_g <= "0000110";
			when "0100" => a_to_g <= "1001100";
			when "0101" => a_to_g <= "0100100";
			when "0110" => a_to_g <= "0100000";
			when "0111" => a_to_g <= "0001101";
			when "1000" => a_to_g <= "0000000";
			when "1001" => a_to_g <= "0000100";
			when others => a_to_g <= "0111000";
		end case;
	end process;
	
	
	process (s, aen)	   --selecteaza cifra : ones/tens etc
	begin 
		an <= "1111";
		if aen(conv_integer(s)) = '1' then 
			an(conv_integer(s)) <= '0';
		end if;
	end process;
	
	
	process(clk, clr)	  --divizor de clock
	begin 
		if clr = '1' then
			clkdiv <= (others => '0');
		elsif clk'event and clk = '1' then
			clkdiv <= clkdiv + 1;
		end if;
		end process;
	end x7seg;
	
	