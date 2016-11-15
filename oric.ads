-- verified part of Genome

package Oric
  with SPARK_Mode
is

   type Nucleotide is (A,T,G,C);
   subtype Nucl_Num is Natural range 0..3;

   GenomeLength: constant Positive:= 500;                 --  max length of the GenomePatch (Oric region)
   subtype Gene_Index is Positive range 1..GenomeLength;  -- indexing the 'string' of genes from GenomePatch
   type Gene is array (Gene_Index range <>) of Nucleotide;

   K: constant Gene_Index:=4;                             -- an average expected size of Oric region in GenomePatch
   subtype Pattern_Index is Positive range 1..K;
   subtype Pattern is Gene(Pattern_Index);

   subtype Count_Pattern_Index is Natural range 0 .. (4**K)-1;
   type Count_Patterns is array (Count_Pattern_Index) of Natural with Default_Component_Value => 0;

   subtype D_Range is Natural range 0..K;

   function Count_Pattern (Text: Gene; Patt: Pattern) return Natural
     with Pre => Text'Length>K and Text'First=1,
          Post => Count_Pattern'Result <= Text'Length - K + 1;


   function Symbol_To_Number (N: Nucleotide) return Nucl_Num
     with Contract_Cases => ((N = A) => Symbol_To_Number'Result = 0,
                             (N = C) => Symbol_To_Number'Result = 1,
                             (N = G) => Symbol_To_Number'Result = 2,
                             (N = T) => Symbol_To_Number'Result = 3) ;

   function Number_To_Symbol (Num: Nucl_Num) return Nucleotide
     with Contract_Cases => ((Num = 0) => Number_To_Symbol'Result = A,
                             (Num = 1) => Number_To_Symbol'Result = C,
                             (Num = 2) => Number_To_Symbol'Result = G,
                             (Num = 3) => Number_To_Symbol'Result = T) ;

   function Pattern_To_Number(Patt: Pattern) return Count_Pattern_Index;

   function Number_To_Pattern (Number: Count_Pattern_Index) return Pattern;

   -- Hamming Distance ---

   function Hamming_Distance (Patt1, Patt2: Gene) return Natural
     with Pre => (Patt1'First = Patt2'First) and (Patt1'Last<=K and Patt2'Last = Patt1'Last),
       Post => (Hamming_Distance'Result <=K);

   -- ApproximatePatternCount ---

   function Approximate_Pattern_Count (Text: Gene; Patt: Pattern; D: D_Range) return Natural
     with Pre => Text'Length>K and Text'First=1,
          Post => Approximate_Pattern_Count'Result <= Text'Length - K + 1;


   function Max_Count (Freq_Arr: Count_Patterns) return Natural
   with Post => (for all I in Count_Pattern_Index => Max_Count'Result>=Freq_Arr(I));



   function Complement_Nucleotide (Nucl: Nucleotide) return Nucleotide
     with Contract_Cases => ((Nucl = A) => Complement_Nucleotide'Result = T,
                             (Nucl = T) => Complement_Nucleotide'Result = A,
                             (Nucl = G) => Complement_Nucleotide'Result = C,
                             (Nucl = C) => Complement_Nucleotide'Result = G) ;

   function Valid_Complement return Boolean
   is (for all Nucl in Nucleotide => Complement_Nucleotide (Complement_Nucleotide (Nucl)) = Nucl)
   with Ghost,
        Post => Valid_Complement'Result = True;


   function Reverse_Compliment_Pattern (Patt: Pattern) return Pattern
     with Post => (for all I in Pattern_Index => Complement_Nucleotide (Patt(K-I+1)) = Reverse_Compliment_Pattern'Result(I));

end Oric;

