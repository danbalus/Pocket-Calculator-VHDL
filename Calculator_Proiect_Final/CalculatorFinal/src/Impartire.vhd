library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity impartire is
    port(
       
   	   catrest:inout std_logic_vector(9 downto 0);
        rest:   inout std_logic_vector(4 downto 0);
        cat:  inout std_logic_vector(4 downto 0);
	    ai: inout STD_LOGIC_VECTOR(4 downto 0); 
        aiB: inout STD_LOGIC_VECTOR(4 downto 0)
    );
end impartire;

architecture imp of impartire is 

	   component Sumatorplusmux										   --componenta pt operandul A 
		port(a:inout STD_LOGIC_VECTOR(4 downto 0);
		     zmux: inout STD_LOGIC_VECTOR(4 downto 0)
		    );
		
	end component;

 component SumatorplusmuxB										   --componenta pt operandul B 
		port(aB:inout STD_LOGIC_VECTOR(4 downto 0); 
		     zmuxB: inout STD_LOGIC_VECTOR(4 downto 0)
		    );
		
end component; 
signal Ximp: STD_LOGIC_VECTOR(4 downto 0); 
signal Yimp: STD_LOGIC_VECTOR(4 downto 0);	
begin
	
	 G10: Sumatorplusmux   port map(a=>ai, zmux=>Ximp);
	 G11: SumatorplusmuxB  port map(aB=>aiB,zmuxB=>Yimp);

    process(Ximp,Yimp)
        variable quotient:  unsigned (4 downto 0);
        variable remainder: unsigned (4 downto 0);
    begin  
  
    	
       
            quotient := (others => '0');                     --  punem in cat si rest "0000"
            remainder := (others => '0');
           for i in 4 downto 0 loop  
               remainder := remainder (3 downto 0) & '0';   -- shift-am la stanga cu 1 bit
               remainder(0) := Ximp(i);                  
               if remainder >= unsigned(Yimp) then  			 --restul mai mic decat catul
                    remainder := remainder - unsigned(Yimp);
                    quotient(i) := '1';
               end if;
            end loop;
            cat <= std_logic_vector(quotient); 
            rest  <= std_logic_vector(remainder);
     		
    end process;
	 catrest<=cat&rest;
end imp;