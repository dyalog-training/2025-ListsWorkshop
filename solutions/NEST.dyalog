:Namespace NEST
    (⎕IO ⎕ML ⎕WX)←1 1 3

⍝ A collection of sample solutions.

    CountA←{+/'A'∊¨⍵}

    CountGORS←{+/∨/¨⍵∊¨⊂'GS'}

    CountGANDS←+/{∧/∨/'GS'∘.=⍵}¨   ⍝ +/{0∊⍴'GS'~⍵}¨

    CountELL←{+/'ELL'∘(∨/⍷)¨⍵}

    CountCON←{+/'CON'∘(⊃⍷)¨⍵}      ⍝ +/{'CON'≡3↑⍵}¨

    CountITY←+/{3⊃⌽'ITY'⍷⍵}¨

    CountSandwich←+/(⊣/≡⊢/)¨       ⍝ +/(⊃≡⊃∘⌽)¨

    Substrings←{⍵⌿⍨∨/¨⍵⍷¨⊂⍺}

    LongestWords←{⍵⌿⍨(⊢=⌈/)≢¨⍵}

    LengthDistribution←{,∘(¯1+≢)⌸(⍳⌈/)⍛,≢¨⍵}

    LengthByLetter←{(⎕A,⊃¨⍵),∘(+⌿÷1⌈¯1+≢)⌸(0⍨¨⎕A),≢¨⍵}

    CountPalindromes←{+/(⌽≡⊢)¨⍵}   ⍝ +/⌽⍛≡¨ in v20.0+

    CountAlphabetical←{+/{⍵≡⍵[⍋⍵]}¨⍵}

    CountRepeating←{+/∨/¨2=/¨⍵}

      CountAlternating←{
          vowel←⍵∊¨⊂'AEIOU'
          +/~∨/¨2=/¨vowel
      }

    Reverse←⌽¨

    CountC_T←+/{∨/1 3 2⍷'CT'⍳⍵}¨   ⍝ +/'.*C.T.*'⎕S{1}

    CountN_Q←+/{∨/'NQ'⍷⍵∩'NQ'}¨    ⍝ +/'NQ'∘(∨/⊣⍷∩⍨)¨

    RemoveVowels←{⍵~¨⊂'AEIOU'}

      RemoveInteriorVowels←{
          interior←{3∧/' '≠' ',' ',⍨⍵}¨⍵
          vowel←⍵∊¨⊂'AEIOU'
          ⍵⌿¨⍨interior⍲vowel
      }

:EndNamespace
