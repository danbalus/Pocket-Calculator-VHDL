 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity bin2bcd_12bit is
    Port ( binIN : inout  STD_LOGIC_VECTOR (11 downto 0);
	       semn:inout std_logic;
		   aUAL: inout STD_LOGIC_VECTOR(4 downto 0); 
           aUALB: inout STD_LOGIC_VECTOR(4 downto 0);
           ones : inout  STD_LOGIC_VECTOR (3 downto 0);
           tens : inout  STD_LOGIC_VECTOR (3 downto 0);
           hundreds : inout  STD_LOGIC_VECTOR (3 downto 0);
		   sel: inout STD_LOGIC_VECTOR(1 downto 0);
		--nr:inout std_logic_vector (4 downto 0);
        --switch: in std_logic;
        --astept: in std_logic;
           thousands : inout  STD_LOGIC_VECTOR (3 downto 0)
          );
end bin2bcd_12bit;

architecture Behavioral of bin2bcd_12bit is

 component	complementintreg 
	port( A: inout STD_LOGIC_VECTOR(9 downto 0);	  --numarul in complement ce variable fi convertit
		  Y: inout STD_LOGIC_VECTOR(9 downto 0);      --numarul convertit
	      semn: inout STD_LOGIC; 
          sel: inout STD_LOGIC_VECTOR(1 downto 0);			--pentru semn	
		  aUAL: inout STD_LOGIC_VECTOR(4 downto 0); 
          aUALB: inout STD_LOGIC_VECTOR(4 downto 0)
          --nr:inout std_logic_vector (4 downto 0);
          --astept: in std_logic;
          --switch: in std_logic
);
   end component;

begin
 G8: complementintreg port map ( y=>binIN(9 downto 0), semn=>semn, aual=>aual, aualb=>aualb,sel=>sel);
 binIN(11 downto 10)<="00";
bcd1: process(binIN)

  
  variable temp : STD_LOGIC_VECTOR (11 downto 0);	 -- temporary variable
  
  -- variabilele ce syocheaza output-ul lui BCD
  
  -- thousands = bcd(15 downto 12)
  -- hundreds = bcd(11 downto 8)
  -- tens = bcd(7 downto 4)
  -- units = bcd(3 downto 0)
  variable bcd : UNSIGNED (15 downto 0) := (others => '0');
  
  begin
    
    bcd := (others => '0');			 -- punem 0 in bcd
    
    
    temp(11 downto 0) := binIN;		    -- citesc imput-ul in variabila temporala
    
    for i in 0 to 11 loop
    
      if bcd(3 downto 0) > 4 then 
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      
      if bcd(7 downto 4) > 4 then 
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
    
      if bcd(11 downto 8) > 4 then  
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;
    
      -- thousands nu pot fi mai mari decat 4 pet nr pe 12 biti, deci nu vom face nimic
     
     
      bcd := bcd(14 downto 0) & temp(11);	 --shift-am bcd la stanga cu 1 bit, copiem cel mai semnificativ bit a variabilei temp in cel mai nesemnificativ bit a llu bcd
    
      temp := temp(10 downto 0) & '0';	     --shift-am in stanga cu 1 bit
    
    end loop;
 
    
    ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));			 --iesirile
    tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
    hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));
    thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
  
  end process bcd1;            
  
end Behavioral;