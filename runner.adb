with Oric; use Oric;
with Oric_Unsafe; use Oric_Unsafe;
with Ada.Assertions; use Ada.Assertions;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- some test procedures via simple assertions

procedure Runner is
   Text1: Gene:=(A,C,G,T,T,G,C,A,T,G,T,C,G,C,A,T,G,A,T,G,C,A,T,G,A,G,A,G,C,T);
   Text2: Gene:=(C,T,T,G,C,C,G,G,C,G,C,C,G,A,T,T,A,T,A,C,G,A,T,C,G,C,G,G,C,C,G,C,T,T,G,C,C,T,T,C,T,T,T,A,T,A,A,T,G,C,A,T,C,G,G,C,G,C,C,G,C,G,A,T,C,T,T,G,C,T,A,T,A,T,A,C,G,T,A,C,G,C,T,T,C,G,C,T,T,G,C,A,T,C,T,T,G,C,G,C,G,C,A,T,T,A,C,G,T,A,C,T,T,A,T,C,G,A,T,T,A,C,T,T,A,T,C,T,T,C,G,A,T,G,C,C,G,G,C,C,G,G,C,A,T,A,T,G,C,C,G,C,T,T,T,A,G,C,A,T,C,G,A,T,C,G,A,T,C,G,T,A,C,T,T,T,A,C,G,C,G,T,A,T,A,G,C,C,G,C,T,T,C,G,C,T,T,G,C,C,G,T,A,C,G,C,G,A,T,G,C,T,A,G,C,A,T,A,T,G,C,T,A,G,C,G,C,T,A,A,T,T,A,C,T,T,A,T);
   Some_Set: Neighbors.Set;
begin

   for I in Count_Pattern_Index loop
     Assert (Pattern_To_Number(Number_To_Pattern(I)) = I, "Loop Assertion Failed");
   end loop;

   Some_Set:=Frequent_Words_M_RC(Text2,3);
   Print_Pattern_Set (Some_Set);

   for Elem of Some_Set loop
      Assert (Elem = (A,G,C,G,C,C,G,C,T) or Elem = (A,G,C,G,G,C,G,C,T), "Something wrong with Frequent Words");
   end loop;


end Runner;
