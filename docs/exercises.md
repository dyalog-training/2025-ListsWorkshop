# Exercises

## Submitting Your Solutions
1. Get the [test workspace](./index.md#test-workspace) contents:  

    ```{ .apl .copy }
    ⍝ click to copy ─→
    ]get -u https://github.com/dyalog-training/2025-ListsWorkshop/raw/refs/heads/main/lists-of-words.dws
    ```

1. Set your workspace ID to **list-solutions-[your name].dws** and save the workspace on your system with `)SAVE`.
1. Save your workspace often!
1. Define functions in this workspace according to the specifications below.
1. When you are ready to submit, erase the `words` variable so that your workspace is smaller:  

    ```{ .apl .copy }
    ]expunge words
    ```

    You can get the words variable at any time from the original workspace:  

    ```{ .apl .copy }
    ]get -u -o=words https://github.com/dyalog-training/2025-ListsWorkshop/raw/refs/heads/main/lists-of-words.dws
    ```
    
1. Send your workspace to the email address you were given.

## Arguments and Results
Unless specified otherwise, all functions take a nested list of character vectors as right argument. All words in the right argument consist solely of characters in `⎕A`.

All `Count*` functions should return a simple scalar numeric result.

## Running Tests
The `Tests.Run` function takes a namespace of solution functions as its right argument and runs the test suite using those solutions. Your solution functions must be correctly named. You may define your solutions in `#` and run the tests with `Tests.Run #`, or using another namespace that you create.

The optional left argument to `Tests.Run` is a scalar Boolean flag that indicates whether or not to pause execution in the case that a test errors or fails.

## CountA
Define a function `CountA` that returns the count of words that contain the letter "A".

```
      CountA 'A' 'WORD' 'AT' 'A' 'TIME'
3
```

## CountGORS
Define a function `CountGORS` that returns the count of words that contain the letter "G" or the letter "S".

```
      CountGORS ,¨'G' 'S' 'GS'
3
```

## CountGANDS
Define a function `CountGANDS` that returns the count of words that contain the letter "G" and the letter "S".

```
      CountGANDS ,¨'G' 'S' 'GS'
1
```

## CountELL
Define a function `CountELL` that returns the count of words that contain the substring "ELL".

```
      CountELL 'ELLA' 'BALL' 'BEND' 'BELL' 'BELLY'
3
```

## CountCON
Define a function `CountCON` that returns the count of words that begin with "CON".

```
      CountCON 'CONNOR' 'BACON' 'ANACONDA' 'CONVERT'
2
```

## CountITY
Define a function `CountITY` that returns the count of words that end with "ITY".

```
      CountITY 'CITY' 'PITYING' 'TEST' 'ABILITY' 'DEITY'
3
```

## CountSandwich
Define a function `CountSandwich` that returns the count of words in its right argument that begin and end with the same character.

```
      CountSandwich 'FIFE' 'PEEP' 'TOOT'
2
```

## Substrings
Define a function `Substrings` that returns words from the right argument list that are substrings of the simple character vector left argument. For example, substrings of "CONSIDERATION" include "SIDE" and "RATIO".

```
      ]box on
Was OFF
      'CONSIDERATION' Substrings 'SIDE' 'RAT' 'RATIO' 'HAT' 'PATIO'
┌────┬───┬─────┐
│SIDE│RAT│RATIO│
└────┴───┴─────┘
```

## LongestWords
Define a function `LongestWords` that returns a nested vector of character vectors that are the longest words in its right argument list.

```
      LongestWords 'JUST' 'FOR' 'THESE' 'FIVE' 'WORDS'
┌─────┬─────┐
│THESE│WORDS│
└─────┴─────┘
```

## LengthDistribution
Define a function `LengthDistribution` that returns a two-column matrix. The first column contains integers between 1 and the length of the longest word in the right argument. The second column is the count of words in the right argument that have that length.

```
      LengthDistribution 'JUST' 'FOR' 'THESE' 'FIVE' 'WORDS'
1 0
2 0
3 1
4 2
5 2
```

## LengthByLetter
Define a function `LengthByLetter` that returns a two-column matrix. The first column contains the letters A to Z. The second column contains the average length of words in the right argument list that begin with that letter.

```
      LengthByLetter 'JUST' 'FOR' 'THESE' 'FIVE' 'WORDS'
A 0
B 0
C 0
D 0
E 0
F 3.5
G 0
H 0
I 0
J 4
K 0
L 0
M 0
N 0
O 0
P 0
Q 0
R 0
S 0
T 5
U 0
V 0
W 5
X 0
Y 0
Z 0
```

## CountPalindromes
Define a function `CountPalindromes` that counts the number of words that are identical when reversed.

```
      CountPalindromes 'REED' 'DEED' 'DOG' 'RACECAR'
2
```

## CountAlphabetical
Define a function `CountAlphabetical` that counts how many words have their letters in alphabetical order.

```
      CountAlphabetical 'FEEL' 'ACER' 'SPOON' 'LOOPS' 'CENT'
3
```

## CountRepeating
Define a function `CountRepeating` that counts how many words have consecutive repeated letters. For example, "deep" and "small" do but "special" does not.

```
      CountRepeating 'DEEP' 'SMALL' 'SPECIAL' 'BOB'
2
```

## CountAlternating
Define a function `CountAlternating` that counts how many words have alternating vowels and consonants. For example, "solid" has alternating vowels and consonants, but "read" has two consecutive vowels and "angle" has three consecutive consonants. For this workshop, a vowel is defined as one of the characters "AEIOU".

```
      CountAlternating 'SOLID' 'READ' 'ANGLE'
1
```

## Reverse
Define a function `Reverse` that reverses each word.

```
      Reverse 'SOLID' 'READ' 'ANGLE'
┌─────┬────┬─────┐
│DILOS│DAER│ELGNA│
└─────┴────┴─────┘
```

## CountC_T
Define a function `CountC_T` that counts the number of words that contain the pattern `C_T` where `_` is any single character.

```
      CountC_T 'CALLING' 'CUTTING' 'WALK' 'CAT' 'COT'
3
```

## CountN_Q
Define a function `CountN_Q` that counts the number of words that contain the pattern `N_Q` where `_` may be zero or more characters.

```
      CountN_Q 'ANTIQUE' 'QUININE'  'INEQUALITY' 'BANQUET' 'FISH'
3
```

## RemoveVowels
Define a function `RemoveVowels` that returns the same words as its argument but with all vowels removed.

```
      RemoveVowels 'ALPHABETTY' 'SPAGHETTI'
┌───────┬──────┐
│LPHBTTY│SPGHTT│
└───────┴──────┘
```

## RemoveInteriorVowels
Define a function `RemoveVowels` that returns the same words as its argument but with all interior vowels removed. An interior letter is a letter between, but not including, the first and last letter.

```
      RemoveInteriorVowels 'ALPHABETTY' 'SPAGHETTI'
┌────────┬───────┐
│ALPHBTTY│SPGHTTI│
└────────┴───────┘
```