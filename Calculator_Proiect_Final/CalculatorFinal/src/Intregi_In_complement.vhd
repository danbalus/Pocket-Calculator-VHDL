	  	   	  
Library	IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_Logic_unsigned.all;  

entity Sumatorplusmux is
	port( a:inout STD_LOGIC_VECTOR(4 downto 0);
		  zmux: inout STD_LOGIC_VECTOR(4 downto 0)								 --iesire multiplexor la transformare intregi cu semn in complement		(inout->pt a fi compatibil cu port map-ul
		  
		  );			 
end Sumatorplusmux;

architecture  sumatorsimux of Sumatorplusmux is
begin	
	                                                 --nu am pus sel aici deoarece procesul se executa o singura data
	process(a)
	variable temp: STD_LOGIC_VECTOR(4 downto 0); 
	variable ss: STD_LOGIC;			 						   
	begin 
		  
		ss:=a(4);																							  --salvez bitul de semn
	if(ss= '0') then
		zmux<=  a;		                             --daca bitul de semn e 0, numarul in complement ramane la fel
	elsif(ss='1') then 
		zmux<=('1'& not a(3)&not a(2)&not a(1)&not a(0))+"00001";                  --daca bitul de semn e 1, se aplica transformarea	
	end if;
		
	end process;
	
end sumatorsimux;	 

 