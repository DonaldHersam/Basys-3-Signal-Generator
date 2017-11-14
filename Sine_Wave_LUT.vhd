library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;     

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;     

entity cntr_basys2 is
Port (I1 : in std_logic ; clk: in std_logic; A,B,C,D,E : buffer std_logic );
end cntr_basys2;

architecture Behavioral of cntr_basys2 is

begin
cntr:  process (clk, I1) is
variable temp: unsigned (29 downto 0):= "00"&X"0000000";
variable result: integer;
begin
if (I1 = '0') then
if rising_edge (clk) then

result := to_integer(unsigned(temp));
result := (result + 1) mod 1073741824;

temp := to_unsigned (result, temp'length);
end if;

else temp:= "00"&X"0000000";
end if;
A <= temp(19);
B <= temp(18);
C <= temp(17);
D <= temp(16);
E <= temp(13);

end process;
end Behavioral;






library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_24 is
port(I1,I2 : in std_logic;
    O : out std_logic_vector (3 downto 0));
    
end decoder_24;

architecture Behavioral of decoder_24 is

begin

O(0) <= not I1 and not I2;
O(1) <= I1 and not I2;
O(2) <= not I1 and I2;
O(3) <= I1 and I2;

end Behavioral;











library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sinewave is
port (clk : in  std_logic;
      switch : in std_logic_vector (1 downto 0);
      clk_f : in std_logic_vector (1 downto 0);
      reset : in std_logic;
      --dataout : out integer range -128 to 127
      --dataout : out std_logic_vector(100 downto 0)
      output_value : out std_logic_vector (7 downto 0)
      );
end sinewave;

architecture Behavioral of sinewave is


component decoder_24
Port(I1,I2 : in std_logic;
    O : out std_logic_vector (3 downto 0)); END COMPONENT;

component cntr_basys2 
Port (I1 : in std_logic ; clk: in std_logic; A,B,C,D,E : buffer std_logic );
end component;


signal i : integer range 0 to 101:=0;
type memory_type is array (0 to 100) of integer range -128 to 127; 



--Sine Wave:
signal sine : memory_type :=(80,85,90,95,99,104,109,113,118,122,126,130,133,137,140,143,146,148,151,153,154,156,157,158,158,158,158,158,157,156,154,153,151,148,146,143,140,137,133,130,126,122,118,113,109,104,99,95,90,85,80,75,70,65,61,56,51,47,42,38,34,30,27,23,20,17,14,12,9,7,6,4,3,2,2,2,2,2,3,4,6,7,9,12,14,17,20,23,27,30,34,38,42,47,51,56,61,65,70,75,80);
--Square Wave
signal square : memory_type :=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100);
--Sawtooth
signal sawtooth : memory_type := (0,10,20,30,40,50,60,70,80,90,100,120,130,140,150,0,10,20,30,40,50,60,70,80,90,100,120,130,140,150,0,10,20,30,40,50,60,70,80,90,100,120,130,140,150,0,10,20,30,40,50,60,70,80,90,100,120,130,140,150,0,10,20,30,40,50,60,70,80,90,100,120,130,140,150,0,10,20,30,40,50,60,70,80,90,100,120,130,140,150,0,10,20,30,40,50,60,70,80,90,100);

signal waveform : memory_type;
signal S : signed (100 downto 0);
signal dataout : std_logic_vector(100 downto 0);
signal o : std_logic_vector(3 downto 0);
signal A,B,C,D,E : std_logic;
signal clock : std_logic;

begin



B0: cntr_basys2 port map(reset,clk,A,B,C,D,E);

process (switch(0),switch(1))
begin
if ((switch(0) = '0') and (switch(1) = '0')) then
	waveform <= sine;
end if;
if ((switch(0) = '1') and (switch(1) = '0')) then
    waveform <= square;
end if;
if ((switch(0) = '1') and (switch(1) = '1')) then
    waveform <= sawtooth;

end if;

end process;



process (clk_f(1),clk_f(0))
begin
if ((clk_f(1) = '0') and (clk_f(0) = '0') ) then
	clock <= E;
end if;
if ((clk_f(1) = '1') and (clk_f(0) = '0')) then
    clock <= D;
end if;
if ((clk_f(1) = '0') and (clk_f(0) = '1')) then
    clock <= C;
end if;
if ((clk_f(1) = '1') and (clk_f(0) = '1')) then
    clock <= B;
end if;


end process;





process(clock)
begin

    if(clock'event and clock='1') then   
        S <=   to_signed(waveform(i),waveform'length);
        dataout <= std_logic_vector(S);
        i <= i + 1;
        if(i = 100) then
            i <= 0;
            
   
        end if;
        
        output_value(0) <= dataout(0);
        output_value(1) <= dataout(1);
        output_value(2) <= dataout(2);
        output_value(3) <= dataout(3);
        output_value(4) <= dataout(4);
        output_value(5) <= dataout(5);
        output_value(6) <= dataout(6);
        output_value(7) <= dataout(7);

    end if;
end process;





end Behavioral;



