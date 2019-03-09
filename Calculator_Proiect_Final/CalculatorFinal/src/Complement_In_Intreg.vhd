library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 	


entity	complementintreg is
	port( A: inout STD_LOGIC_VECTOR(9 downto 0);	  --numarul in complement ce va fi convertit
		  Y: inout STD_LOGIC_VECTOR(9 downto 0);
          aUAL: inout STD_LOGIC_VECTOR(4 downto 0); 
          aUALB: inout STD_LOGIC_VECTOR(4 downto 0);
          sel: inout STD_LOGIC_VECTOR(1 downto 0);              
	      semn: inout STD_LOGIC
          --astept: in std_logic;			--pentru semn	
		  --nr:inout std_logic_vector (4 downto 0);
          --switch: in std_logic
 );
   end complementintreg;
		  
architecture complementininintreg of complementintreg is  
component ual 
	port( 	     
	       Y0: inout STD_LOGIC_VECTOR(4 downto 0);		 --| operatia adunare/ scadere/ inmultire/ impartire
	       Y1: inout STD_LOGIC_VECTOR(4 downto 0);       --| adunare   --> 00
	       Y2: inout STD_LOGIC_VECTOR(4 downto 0);		 --| scadere   --> 01
	       Y3: inout STD_LOGIC_VECTOR(4 downto 0);		 --| inmultire --> 10
		   Y0B: inout STD_LOGIC_VECTOR(4 downto 0);		 --| impartire --> 11 
		   Y1B: inout STD_LOGIC_VECTOR(4 downto 0);	     --|
		   Y2B: inout STD_LOGIC_VECTOR(4 downto 0);		 --|	4 downto 0 deoarece nu voi mai stoca bitul de semn in vector
		   Y3B: inout STD_LOGIC_VECTOR(4 downto 0);		 --|
		   sel: inout STD_LOGIC_VECTOR(1 downto 0);		 --|
		   Op1: inout STD_LOGIC_VECTOR(4 downto 0);   		 --| pt PORT MAP (primul operand)
		   Op2:  inout STD_LOGIC_VECTOR(4 downto 0);		     --| pt PORT MAP (al doilea operand) 
		   
		   Opi1: inout STD_LOGIC_VECTOR(4 downto 0);		 --	pt PORT MAP	(primul operand al inmultirii)
		   Opi2: inout STD_LOGIC_VECTOR(4 downto 0);		 --	pt PORT MAP (al doilea operand al imultirii)
		   aUAL:inout STD_LOGIC_VECTOR(4 downto 0); 
		   aUALB:inout STD_LOGIC_VECTOR(4 downto 0);
			--nr:inout std_logic_vector (4 downto 0);
            --switch: in std_logic;
            --astept: in std_logic;
		 
		   rezultat: inout STD_LOGIC_VECTOR(9 downto 0);  -->aici va fi stocat rezultatul dintre operatia Op1 cu Op2 
		   rezultati: inout STD_LOGIC_VECTOR(9 downto 0);
		   rezultatimp: inout std_logic_vector(9 downto 0);
		   clk: inout std_logic
		);		 
end component;	

begin 

	G7: ual port map(rezultat=>A, aual=>aual, aualb=>aualb,sel=>sel);
	semn<=a(4);
	process(A)
	begin
if(semn='0')then
	Y<=A;				 			--pt 0 vom folosi doar reprezentarea cu plus(+0): 0 0000, nu(-0) 1 0000
elsif(semn='1')	 then
	Y<=('0' & not A(8)& not A(7)& not A(6)& not A(5)& not A(4)& not A(3)& not A(2)& not A(1)& not A(0))+"0000000001"; 
end if;
	end process;
end architecture;

