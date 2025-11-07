# Processing Lists of Text

## About
In this workshop we will explore the expression and performance of computations on 3 representations of partitioned lists. Partitioned lists often appear in text processing, for example where you might apply an algorithm to individual words in a sentence, but can also be used as an alternative representation to columns in a table. The three representations we will consider are: nested vectors of vectors, matrices, and delimited lists.

Try [the exercises](./exercises.md), using arguments that are nested vectors of vectors, before the first day of the workshop. During the workshop we will introduce conventions and techniques for the other two representations before tackling the problems using them. The test suite runs solutions against various nested vector arguments, including the variable (called `words`) provided

## Test workspace

Get the test workspace contents:

```
]get -u https://github.com/dyalog-training/2025-ListsWorkshop/raw/refs/heads/main/lists-of-words.dws
```

To save bandwith, please erase the words variable before saving your solutions.

This workspace contains a nested list of character vectors, called `words`, and a namespace called `Tests` containing a test suite.

```
      ]map
#                                                                                                                        
·   ~ version words                                                                                                      
·   Tests                                                                                                                
·   ·   ~ length_by_letter                                                                                               
·   ·   ∇ Run Test_01_CountA Test_02_CountGORS Test_03_CountGANDS Test_04_CountELL Test_05_CountCON Test_06_CountITY     
·   ·   ∇ Test_07_CountSandwich Test_08_Substrings Test_09_LongestWords Test_10_LengthDistribution Test_11_LengthByLetter
·   ·   ∇ Test_12_CountPalindromes Test_13_CountAlphabetical Test_14_CountRepeating Test_15_CountAlternating             
·   ·   ∇ Test_16_Reverse Test_17_CountC_T Test_18_CountN_Q Test_19_RemoveVowels Test_20_RemoveInteriorVowels  
```

The `Tests.Run` function takes a namespace of solution functions as its right argument and runs the test suite using those solutions. Your solution functions must be correctly named. You may define your solutions in `#` and run the tests with `Tests.Run #`, or using another namespace that you create.

The optional left argument to `Tests.Run` is a scalar Boolean flag that indicates whether or not to pause execution in the case that a test errors or fails.

All of the words are capitalised alphabetic letters with no punctuation or diacritics. The words were sourced from books in [Project Gutenberg](https://www.gutenberg.org/).
