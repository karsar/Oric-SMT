with Oric; use Oric;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Oric_Unsafe is

   function Pattern_To_String (Patt: Gene) return String is
      Patt_Str: String (1..K);
   begin
      for I in Pattern_Index loop
         Patt_Str (I) := Nucleotide'Image(Patt(I))(1);
      end loop;

      return Patt_Str;
   end Pattern_To_String;

   procedure Print_Pattern (Patt: Gene) is
   begin
        Ada.Text_IO.Put_Line(Pattern_To_String(Patt));
   end Print_Pattern;


   procedure Print_Pattern_Set (S: Neighbors.Set) is
   begin
      for Elem of S loop
         Print_Pattern (Elem);
      end loop;
   end Print_Pattern_Set;

   function Hamming_DistanceS (Patt1, Patt2: Pattern; S: Pattern_Index) return Natural
   is

   begin
      return Hamming_Distance (Patt1(K-S+1..K),Patt2(K-S+1..K));
   end Hamming_DistanceS;


 function Neighborhoods (Patt: Pattern; D: D_Range; Size: Pattern_Index) return Neighbors.Set is
      Data: Neighbors.Set:=Neighbors.Empty_Set;
      Suffix_Neighbors: Neighbors.Set:=Neighbors.Empty_Set;
      Patt2: Pattern:=Patt;
   begin
      if D = 0 then
         Neighbors.Include(Data, Patt);
         return Data;
      end if;
      if Size = 1 then
              Patt2(K):=A;
              Neighbors.Include(Data, Patt2);
              Patt2(K):=C;
              Neighbors.Include(Data, Patt2);
              Patt2(K):=G;
              Neighbors.Include(Data, Patt2);
              Patt2(K):=T;
              Neighbors.Include(Data, Patt2);
         return Data;
      end if;


      Suffix_Neighbors:=Neighborhoods (Patt,D, Size-1);

         for Elem of Suffix_Neighbors loop
            if Hamming_Distance (Patt, Elem) < d then
               Patt2(K-Size+1):=A;
               Patt2(K-Size+2..Patt'Last) := Elem(K-Size+2..Patt'Last);
               Neighbors.Include(Data, Patt2);
               Patt2(K-Size+1):=C;
               Neighbors.Include(Data, Patt2);
               Patt2(K-Size+1):=G;
               Neighbors.Include(Data, Patt2);
               Patt2(K-Size+1):=T;
               Neighbors.Include(Data, Patt2);
            else
               Patt2(K-Size+1):=Patt(K-Size+1);
               Patt2(K-Size+2..Patt'Last) := Elem(K-Size+2..Patt'Last);
               Neighbors.Include(Data, Patt2);
            end if;

         end loop;

      return Data;
   end Neighborhoods;

   function Neighborhood (Patt: Pattern; D: D_Range) return Neighbors.Set is
   begin
     return Neighborhoods (Patt, D, K);
   end Neighborhood;

   function Frequent_Words_Mismatches (Text: Gene; D: D_Range) return Neighbors.Set is
      Frequent_Patterns: Neighbors.Set:=Neighbors.Empty_Set;
      Near: Neighbors.Set;
      Close: Count_Patterns;
      Frequency_Array: Count_Patterns;
      Index: Count_Pattern_Index;
      Patt: Pattern;
      maxCount: Natural;
   begin
      for I in Text'First..Text'Last-K+1 loop
         Near := Neighborhood(Text(I..I+K-1), D);
         for Elem of Near loop
            Index:=Pattern_To_Number(Elem);
            Close(Index):=1;
         end loop;
      end loop;

      for I in Count_Pattern_Index loop
         if Close(I) = 1 then
            Patt:=Number_To_Pattern(I);
            Frequency_Array(I):=Approximate_Pattern_Count(Text, Patt, D);
         end if;
      end loop;

      maxCount := Max_Count(Frequency_Array);

      for I in Count_Pattern_Index loop
         if Frequency_Array(I) = maxCount then
            Patt:=Number_To_Pattern(I);
            Frequent_Patterns.Include(Patt);
         end if;
      end loop;

      return Frequent_Patterns;

   end Frequent_Words_Mismatches;

   function Frequent_Words_M_RC (Text: Gene; D: D_Range) return Neighbors.Set is
      Frequent_Patterns: Neighbors.Set:=Neighbors.Empty_Set;
      Near: Neighbors.Set;
      Close: Count_Patterns;
      Frequency_Array: Count_Patterns;
      Index: Count_Pattern_Index;
      Patt: Pattern;
      maxCount: Natural;
   begin
      for I in Text'First..Text'Last-K+1 loop
         Near := Neighborhood(Text(I..I+K-1), D);
         for Elem of Near loop
            Index:=Pattern_To_Number(Elem);
            Close(Index):=1;
         end loop;
      end loop;

      for I in Count_Pattern_Index loop
         if Close(I) = 1 then
            Patt:=Number_To_Pattern(I);
            Frequency_Array(I):=Approximate_Pattern_Count(Text, Patt, D) + Approximate_Pattern_Count(Text, Reverse_Compliment_Pattern(Patt), D);
         end if;
      end loop;

      maxCount := Max_Count(Frequency_Array);

      for I in Count_Pattern_Index loop
         if Frequency_Array(I) = maxCount then
            Patt:=Number_To_Pattern(I);
            Frequent_Patterns.Include(Patt);
         end if;
      end loop;

      return Frequent_Patterns;
   end Frequent_Words_M_RC;

end Oric_Unsafe;
