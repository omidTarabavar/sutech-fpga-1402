library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity WSystem is
	port(TIN,LIN,RESET,CLK : in std_logic;
	    	MIN : in std_logic_vector(2 downto 0);
		LOUT,TOUT : out std_logic;
		STATE : out std_logic_vector(1 downto 0);
		MOUT : out std_logic_vector(2 downto 0);
		SEG : out std_logic_vector(6 downto 0));
end WSystem;

architecture WS of WSystem is
type STATE_TYPE is (ST0,ST1,ST2);
signal PS : STATE_TYPE := ST2;
signal NS : STATE_TYPE := ST0;
begin
CLK_PROC :  process(RESET,NS,CLK)
begin
	if (RESET = '1') then 
	PS <= ST2;
	elsif rising_edge(CLK) then PS <= NS;
	else
	PS <= PS;
	end if;
end process;

SEG_PROC : process(NS)
begin
	if(NS = ST1) then
		SEG <= "0110111";
	else
		SEG <= "0000001";
	end if;
end process;

STATE_PROC : process(NS)
begin
	if(NS = ST1) then
		STATE <= "01";
	elsif (NS = ST0) then
		STATE <= "00";
	else
		STATE <= "01";
	end if;
end process;

CMB_PROC : process(TIN,LIN,MIN,PS)
begin
	case PS is 
		when ST0 =>
			if (TIN = '1' or LIN = '1') and MIN <= "001" then 
			NS <= ST1;
			elsif (TIN = '0' and LIN = '0') and MIN <= "011" then
			NS <= ST1;
			else
			NS <= ST0;
			end if;
		when ST1 =>
			if (TIN = '1' or LIN = '1') and MIN >= "011" then
			NS <= ST0;
			elsif MIN >= "111" then
			NS <= ST0;
			else
			NS <= ST1;
			end if;
		when others =>
			NS <= ST0;
	end case;
	LOUT <= LIN; TOUT <= TIN; MOUT <= MIN;
end process;
end architecture;
