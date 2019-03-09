--* În aceasta metoda
--* cifrele înmultitorului sunt examinate în perechi, începând cu cea mai putin semnificativa
--* pereche; deînmultitul este adunat sau scazut din produsul partial acumulat, în functie de
--* informatia obtinuta în urma comparatiei bitilor înmultitorului. Algoritmul pentru aceasta
--* metoda poate fi enuntat astfel:
--* 1) daca cifrele comparate sunt 00 sau 11 nu se efectueaza nimic si se
--* deplaseaza înmultitorul si produsul partial cu o pozitie spre dreapta;
--* 2) daca cifrele comparate sunt 10, se scade deînmultitul (adica se aduna
--* complementul sau fata de doi) din produsul partial acumulat si se deplaseaza
--* cu o pozitie la dreapta:
--* 3) daca cifrele comparate sunt 01, se aduna deînmultitul la produsul partial
--* acumulat si se deplaseaza cu o pozitie la dreapta.
--******************************************************************************************
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity Booth_Con_RCI is 
	Port (
           Z : out STD_LOGIC_VECTOR(9 DOWNTO 0);
		   ai: inout STD_LOGIC_VECTOR(4 downto 0); 
           aiB: inout STD_LOGIC_VECTOR(4 downto 0)
		   );
		  
end Booth_Con_RCI;	 

architecture Behavioral of Booth_Con_RCI is 
SIGNAL A:STD_LOGIC_VECTOR(10 DOWNTO 0); 					 --|
SIGNAL S:STD_LOGIC_VECTOR(10 DOWNTO 0);					 --|
SIGNAL P:STD_LOGIC_VECTOR(10 DOWNTO 0); 					 --|
SIGNAL P1,P1_SHIFT:STD_LOGIC_VECTOR(10 DOWNTO 0); 		 --| 5+5+1(pt shift-are) biti
SIGNAL P2,P2_SHIFT:STD_LOGIC_VECTOR(10 DOWNTO 0); 		 --|
SIGNAL P3,P3_SHIFT:STD_LOGIC_VECTOR(10 DOWNTO 0); 		 --|
SIGNAL P4,P4_SHIFT:STD_LOGIC_VECTOR(10 DOWNTO 0); 		 --|
SIGNAL P5,P5_SHIFT:STD_LOGIC_VECTOR(10 DOWNTO 0); 		 --| 
SIGNAL P6,P6_SHIFT:STD_LOGIC_VECTOR(10 DOWNTO 0);

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
signal X: STD_LOGIC_VECTOR(4 downto 0); 
signal Y: STD_LOGIC_VECTOR(4 downto 0);	
begin  
	G4: Sumatorplusmux   port map(a=>ai, zmux=>X);
	G5: SumatorplusmuxB  port map(aB=>aiB,zmuxB=>Y);
	
	A(10 DOWNTO 6)<=X;							            --A il variable contine pe X, la inceput
    A(5 DOWNTO 0)<=(OTHERS=>'0'); 			                --se pune  0 in rest
    S(10 DOWNTO 6)<=NOT X + "00001"; 			            --se calculeaza complementul numarului (ajuta la calcularea produsului) si se copiaza la inceputul lui S
    S(5 DOWNTO 0)<=(OTHERS=>'0'); 			                -- restul bitilor vectorului S vor fi 0
    P(10 DOWNTO 6)<=(OTHERS=>'0'); 			                --punem 0 pe primele pozitii ale lui P
    P(5 DOWNTO 1)<=Y; P(0)<='0'; 			                --P il variable contine pe Y, la sfarsit & 0
    P1<=P WHEN (P(1 DOWNTO 0)="00" OR P(1 DOWNTO 0)="11")	--daca ultimele 2 cifre ale vectorului sunt 00 sau 11, in P1 se copiaza P
ELSE P+A WHEN P(1 DOWNTO 0)="01"							--daca ultimele 2 cifre ale vectorului sunt 01, in P1 se copiaza P+A
ELSE P+S WHEN P(1 DOWNTO 0)="10";							--daca ultimele 2 cifre ale vectorului sunt 10, in P1 se copiaza P+S
	P1_SHIFT(9 DOWNTO 0)<=P1(10 DOWNTO 1); 					--se aplica shift-area la dreapta
	P1_SHIFT(10)<=P1(10);								    --dupa shift-are, pe prima pozitie se pune bitul cel mai semnificativ a lui P1
	P2<=P1_SHIFT WHEN (P1_SHIFT(1 DOWNTO 0)="00" OR P1_SHIFT(1 DOWNTO 0)="11") -- se aplica aceasi metoda ca mai sus
ELSE  P1_SHIFT+A WHEN P1_SHIFT(1 DOWNTO 0)="01"
ELSE  P1_SHIFT+S WHEN P1_SHIFT(1 DOWNTO 0)="10"; 
	P2_SHIFT(9 DOWNTO 0)<=P2(10 DOWNTO 1); 
	P2_SHIFT(10)<=P2(10);
	P3<=P2_SHIFT WHEN (P2_SHIFT(1 DOWNTO 0)="00" OR P2_SHIFT(1 DOWNTO 0)="11")
ELSE  P2_SHIFT+A WHEN P2_SHIFT(1 DOWNTO 0)="01"
ELSE  P2_SHIFT+S WHEN P2_SHIFT(1 DOWNTO 0)="10"; 
	P3_SHIFT(9 DOWNTO 0)<=P3(10 DOWNTO 1); 
	P3_SHIFT(10)<=P3(10); 
	--P2<=P1_SHIFT P2;
	P4<=P3_SHIFT WHEN (P3_SHIFT(1 DOWNTO 0)="00" OR P3_SHIFT(1 DOWNTO 0)="11")
ELSE  P3_SHIFT+A WHEN P3_SHIFT(1 DOWNTO 0)="01"
ELSE  P3_SHIFT+S WHEN P3_SHIFT(1 DOWNTO 0)="10";
	P4_SHIFT(9 DOWNTO 0)<=P4(10 DOWNTO 1); 
	P4_SHIFT(10)<=P4(10); 
	P5<=P4_SHIFT WHEN (P4_SHIFT(1 DOWNTO 0)="00" OR P4_SHIFT(1 DOWNTO 0)="11")
ELSE  P4_SHIFT+A WHEN P4_SHIFT(1 DOWNTO 0)="01"
ELSE  P4_SHIFT+S WHEN P4_SHIFT(1 DOWNTO 0)="10";
	P5_SHIFT(9 DOWNTO 0)<=P5(10 DOWNTO 1); 
	P5_SHIFT(10)<=P5(10);
	Z<=P5_SHIFT(10 DOWNTO 1);								  --in rezultatul final se variable copia ultima shift-are,dar fara ultimul bit din dreapta
end Behavioral;