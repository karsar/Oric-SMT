-- Verified parts for Oric code

package body Oric
  with SPARK_Mode
is

   function Count_Pattern (Text: Gene; Patt: Pattern) return Natural is
      Count:Natural:=0;
   begin
      for I in Text'First..Text'Last-K+1 loop
         if Text(I..I+K-1)=Patt then
            Count:=Count+1;
         end if;
         pragma Loop_Invariant (Count<=I and (if (for some J in Text'First..I => Patt = Text(J..J+K-1)) then Count>=1));
      end loop;

      return Count;
   end Count_Pattern;


   function Symbol_To_Number (N: Nucleotide) return Nucl_Num is
   begin
      case N is
         when A => return 0;
         when C => return 1;
         when G => return 2;
         when T => return 3;
      end case;

   end;

   function Number_To_Symbol (Num: Nucl_Num) return Nucleotide is
   begin
      case Num is
         when 0 => return A;
         when 1 => return C;
         when 2 => return G;
         when 3 => return T;
      end case;
   end;


   function Pattern_To_Number(Patt: Pattern) return Count_Pattern_Index is
      Result: Count_Pattern_Index:=0;
      Accum: Natural:=1;
   begin

      pragma Assert (K=Patt'Last and K<10);
      pragma Assert (Patt'First = 1);
      for I in Patt'First .. Patt'Last loop
         pragma Assert (Symbol_To_Number(Patt(I))<=3);
         pragma Loop_Invariant ((Accum<=4**(I-1) and (Result + Symbol_To_Number(Patt(I))*Accum <= 4**I-1)));
         Result := Result + Symbol_To_Number(Patt(I))*Accum;
         Accum:=Accum*4;

      end loop;

      return Result;
   end;

   function Number_To_Pattern (Number: Count_Pattern_Index) return Pattern is
      Patt: Pattern:=(others => A);
      Num: Count_Pattern_Index:= Number;
   begin

      recover: for I in Pattern_Index'Range loop
                  Patt(I):=Number_To_Symbol(Num rem 4);
                  if Num < 4 then
                      exit recover;
                  end if;
                  pragma Loop_Invariant (Num<4**(K-I+1));
                  Num := Num / 4;
                end loop recover;
      pragma Assert (Num < 4); -- this assertion tells us that our Number never corresponds to a pattern longer than K
      return Patt;
      -- checking that Number_To_Patter (Pattern_to_Number (Patt)) = Patt and in other direction
      -- is done by very simple unit tests (runner.adb), as hanging on the proof is not cost-effective.
   end;

   function Hamming_Distance (Patt1, Patt2: Gene) return Natural is
      Count: Natural := 0;
   begin

      for I in Patt1'First..Patt1'Last loop
         if Patt1(I) /= Patt2(I) then
            Count := Count + 1;
         end if;
         pragma Loop_Invariant (Count<=I);

      end loop;

      return Count;
   end Hamming_Distance;

   function Approximate_Pattern_Count (Text: Gene; Patt: Pattern; D: D_Range) return Natural is
      Count: Natural:=0;
      Patt_Cut: Pattern;
   begin
      for I in Text'First..Text'Last-K+1 loop
         Patt_Cut:=Text(I..I+K-1);
         if Hamming_Distance (Patt, Patt_Cut) <= D then
            Count :=Count + 1;
         end if;
         pragma Loop_Invariant (Count<=I);
      end loop;
      return Count;
   end Approximate_Pattern_Count;

   function Max_Count (Freq_Arr: Count_Patterns) return Natural is
     M_Count: Natural:=Freq_Arr(Count_Pattern_Index'First);
   begin

      for I in Count_Pattern_Index loop
         if M_Count<Freq_Arr(I) then
            M_Count:=Freq_Arr(I);
         end if;
      pragma Loop_Invariant (for all J in Count_Pattern_Index'First..I => M_Count>=Freq_Arr(J));
      end loop;

      return M_Count;
   end Max_Count;

   function Complement_Nucleotide (Nucl: Nucleotide) return Nucleotide
   is
   begin
     case Nucl is
         when A => return T;
         when T => return A;
         when C => return G;
         when G => return C;
      end case;
   end Complement_Nucleotide;


   function Reverse_Compliment_Pattern (Patt: Pattern) return Pattern is
      Reversed: Pattern:=(others=>A);
   begin
      for I in Pattern_Index loop
         Reversed (I):=Complement_Nucleotide(Patt(K-I+1));
         pragma Loop_Invariant (for all J in Pattern_Index'First..I => Complement_Nucleotide (Patt(K-J+1)) = Reversed(J));
      end loop;
    return Reversed;
   end Reverse_Compliment_Pattern;

end Oric;

