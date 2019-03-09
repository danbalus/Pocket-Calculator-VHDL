
Library	IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_Logic_unsigned.all; 	

entity ual is
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
		   Op1: inout STD_LOGIC_VECTOR(4 downto 0);   	 --| pt PORT MAP (primul operand)
		   Op2:  inout STD_LOGIC_VECTOR(4 downto 0);	 --| pt PORT MAP (al doilea operand) 
		   
		   Opi1: inout STD_LOGIC_VECTOR(4 downto 0);		 --	pt PORT MAP	(primul operand al inmultirii)
		   Opi2: inout STD_LOGIC_VECTOR(4 downto 0);		 --	pt PORT MAP (al doilea operand al imultirii)
		   aUAL:inout STD_LOGIC_VECTOR(4 downto 0); 
		   aUALB:inout STD_LOGIC_VECTOR(4 downto 0);
		   --nr:inout std_logic_vector (4 downto 0);
           --switch: in std_logic;
		   -- astept: in std_logic;
		   rezultat: inout STD_LOGIC_VECTOR(9 downto 0);  -->aici va fi stocat rezultatul dintre operatia Op1 cu Op2 
		   rezultati: inout STD_LOGIC_VECTOR(9 downto 0);
		   rezultatimp:	inout STD_LOGIC_VECTOR(9 downto 0);
		   clk: inout std_logic
		);		 
end ual;

architecture unitarlog of ual is
 
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
	
	
	component Booth_Con_RCI is 
	Port (
           Z : out STD_LOGIC_VECTOR(9 DOWNTO 0); 
		   ai:inout STD_LOGIC_VECTOR(4 downto 0); 
		   aiB:inout STD_LOGIC_VECTOR(4 downto 0));
	end component;	   
	
	 component impartire is
    Port ( 	 catrest:inout std_logic_vector(9 downto 0);
	        rest:   inout std_logic_vector(4 downto 0);
            cat:  inout std_logic_vector(4 downto 0);
	        ai: inout STD_LOGIC_VECTOR(4 downto 0); 
            aiB: inout STD_LOGIC_VECTOR(4 downto 0));
     end component; 

--component introducere_numere
--port(
--              nr:inout std_logic_vector (4 downto 0);
--              switch: in std_logic;
--           astept: in std_logic;
--          aUAL:inout STD_LOGIC_VECTOR(4 downto 0); 
--		  aUALB:inout STD_LOGIC_VECTOR(4 downto 0)
--		  );
--end component;
	
begin	
	
	
	G1: Sumatorplusmux   port map(a=>aUAL,zmux=>Op1);			  
	G2: SumatorplusmuxB  port map(aB=>aUALb,zmuxB=>Op2);
	G3: Booth_Con_RCI    port map(ai=>aual,aib=>aualb,Z=>rezultati); 
	G12: impartire       port map(ai=>aual,aib=>aualb,catrest=>rezultatimp);
	--G9: introducere_numere port map ( nr=>nr, switch=>switch, astept=>astept, aual=>aual, aualb=>aualb);
	process(Op1,Op2, sel,rezultat,clk) 
	variable semn: STD_LOGIC;		                      --semnul operatiei (avem nevoie sa stim daca mai convertim rezultatul la sfarsit)
	begin 
		if(sel ="00") then			   
			Y0<=Op1;
			Y0B<=Op2;
			
			rezultat<="00000"&(Y0+Y0B);			      --semnul e lasat in vector
			semn:=rezultat(4);                        --pun semnul intr o variabila deoarece imi e mai usor cand transform in intregi cu semn
			rezultat<=semn&semn&semn&semn&semn&(Y0+Y0B);
		elsif(sel ="01") then			   
			Y1<=Op1;
			Y1B<=Op2;
			
			rezultat<="00000"&(Y1-Y1B);				  --semnul e lasat in vector
			semn:=rezultat(4);                        -- -,,-
			rezultat<=semn&semn&semn&semn&semn&(Y1-Y1B);   
		
		elsif(sel="10")	 then
			semn:=(Op1(4) xor Op2(4));
			Y2<=Op1;
			Y2B<=Op2;
			rezultat<=rezultati;
			
		elsif(sel="11")	 then  
			semn:=(Op1(4) xor Op2(4));
			Y3<=Op1;
			Y3B<=Op2; 
			rezultat<=rezultatimp;
		  end if;
	end process;
end unitarlog;