 ------------------------------------------------------------->>>>>>>>>>>>> OPERANDUL AL DOILEA-->B
  Library	IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_Logic_unsigned.all;  

entity SumatorplusmuxB is
	port( aB:in STD_LOGIC_VECTOR(4 downto 0);
		  zmuxB: inout STD_LOGIC_VECTOR(4 downto 0)								 --iesire multiplexor la transformare intregi cu semn in complement	  PENTRU OPERANDUL B
		  
		  );			 
end SumatorplusmuxB;

architecture  sumatorsimuxB of SumatorplusmuxB is
begin	
	            --nu am pus sel aici deoarece procesul se executa o singura data
	process(aB)
	variable tempB: STD_LOGIC_VECTOR(4 downto 0); 
	variable ssB: STD_LOGIC;		 						   
	begin 
		  
		ssB:=aB(4);																							  --salvez bitul de semn			PENTRU OPERANDUL 
		if(ssB= '0') then	
		zmuxB<= aB;		                              --daca bitul de semn e 0, numarul in complement ramane la fel
	elsif(ssB='1') then 
		zmuxB<=('1'& not aB(3)&not aB(2)&not aB(1)&not aB(0))+"00001";                  --daca bitul de semn e 1, se aplica transformarea	
	end if;
		
	end process;
	
end sumatorsimuxB;