with Ada.Containers.Ordered_Sets;
with Oric; use Oric;

-- 'Unsafe functions and procedures'
-- There is a bug in GNATprover GPL 2016 and proof obligations
-- are not generated in case of Formal Ordered Set container.
---Exit with status 1 instead.
-- Hence the implementetation using sets is not verified by SPARK.
-- Consider to move it to verified by SMT solvers part in future


package Oric_Unsafe is

package Neighbors is new  Ada.Containers.Ordered_Sets(Pattern);

function Pattern_To_String (Patt: Gene) return String;

procedure Print_Pattern (Patt: Gene);

procedure Print_Pattern_Set (S: Neighbors.Set);

 function Hamming_DistanceS (Patt1, Patt2: Pattern; S: Pattern_Index) return Natural;

   -- Neighbors

function Neighborhoods (Patt: Pattern; D: D_Range; Size: Pattern_Index) return Neighbors.Set
     with Pre => Patt'First = 1 and Patt'Last <= K and D<4;

function Neighborhood (Patt: Pattern; D: D_Range) return Neighbors.Set;

function Frequent_Words_Mismatches (Text: Gene; D: D_Range) return Neighbors.Set;

function Frequent_Words_M_RC (Text: Gene; D: D_Range) return Neighbors.Set;

end Oric_Unsafe;
