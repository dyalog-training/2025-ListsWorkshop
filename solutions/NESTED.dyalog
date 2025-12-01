:Namespace NESTED
    (⎕IO ⎕ML ⎕WX)←1 1 3

⍝ A collection of sample solutions.

    CountA←{+/'A'∊¨⍵}

    CountAlphabetical←{+/{⍵≡⍵[⍋⍵]}¨⍵}   ⍝ Can trigger idiom with {+/⍵≡{⍵[⍋⍵]}}

      CountAlternating←{
          vowel←⍵∊¨⊂'AEIOU'
          +/~∨/¨2=/¨vowel
      }

    CountCON←{+/'CON'∘(⊃⍷)¨⍵}

    CountC_T←+/{∨/1 3 2⍷'CT'⍳⍵}¨   ⍝ +/'.*C.T.*'⎕S{1}

    CountELL←{+/'ELL'∘(∨/⍷)¨⍵}

    CountGANDS←+/{∧/∨/'GS'∘.=⍵}¨   ⍝ +/{0∊⍴'GS'~⍵}¨

    CountGORS←{+/∨/¨⍵∊¨⊂'GS'}

    CountITY←{+/3⊃∘⌽¨'ITY'∘⍷¨⍵}

    CountN_Q←{+/{∨/1 ¯1⍷0~⍨-⌿'NQ'∘.=⍵}¨⍵}

    CountPalindromes←{+/⌽⍛≡¨⍵}

    CountRepeating←{+/∨/¨2=/¨⍵}

    CountSandwich←{+/(⊃≡⊃∘⌽)¨⍵}

    LengthByLetter←{(⎕A,⊃¨⍵),∘(+⌿÷1⌈¯1+≢)⌸(0⍨¨⎕A),≢¨⍵}

    LengthDistribution←{,∘(¯1+≢)⌸(⍳⌈/)⍛,≢¨⍵}

    LetterDistribution←{(⎕A,⊃¨⍵){⍺,(+⌿÷≢)⍵}⌸(0⍨¨⎕A),≢¨⍵}

    LongestWords←{⍵⌿⍨(⊢=⌈/)≢¨⍵}

      RemoveInteriorVowels←{
          interior←{3∧/' '≠' ',' ',⍨⍵}¨⍵
          vowel←⍵∊¨⊂'AEIOU'
          ⍵⌿¨⍨interior⍲vowel
      }

    RemoveVowels←{⍵~¨⊂'AEIOU'}



    Substrings←{⍵⌿⍨∨/¨⍵⍷¨⊂⍺}

:EndNamespace
