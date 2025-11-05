# Processing Lists of Text

## About
In this workshop we will explore the expression and performance of computations on 3 representations of partitioned lists. Partitioned lists often appear in text processing, for example where you might apply an algorithm to individual words in a sentence, but can also be used as an alternative representation to columns in a table. The three representations we will consider are: nested vectors of vectors, matrices, and delimited lists.

Try [the exercises](./exercises.md) before the first day of the workshop.

## Test workspace

Download the Dyalog workspace file [lists-of-words.dws](https://github.com/dyalog-training/2025-ListsWorkshop/raw/refs/heads/main/lists-of-words.dws).

This workspace contains a nested list of character vectors, `words`, and a namespace `Tests` containing a test suite.

```
      ]map
#                                                                                                                  
·   ~ version words                                                                                                
·   Tests                                                                                                          
·   ·   ~ length_by_letter                                                                                         
·   ·   ∇ Run Test_CountA Test_CountAlphabetical Test_CountAlternating Test_CountCON Test_CountC_T Test_CountELL   
·   ·   ∇ Test_CountGANDS Test_CountGORS Test_CountITY Test_CountN_Q Test_CountPalindromes Test_CountRepeating     
·   ·   ∇ Test_LengthByLetter Test_LengthDistribution Test_LongestWords Test_RemoveInteriorVowels Test_RemoveVowels
·   ·   ∇ Test_Reverse Test_Sandwich Test_Substrings  
```

The `Tests.Run` function takes a namespace of solution functions as its right argument and runs the test suite using those solutions. Your solution functions must be correctly named. You may define your solutions in `#` and run the tests with `Tests.Run #`, or in another namespace that you create.

The optional left argument to `Tests.Run` is a scalar Boolean flag that indicates whether or not to pause execution in the case that a test errors or fails.

All of the words are capitalised alphabetic letters with no punctuation or diacritics. The words were sourced from books in [Project Gutenberg](https://www.gutenberg.org/).
