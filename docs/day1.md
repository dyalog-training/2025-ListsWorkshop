# Day 1

## Setup
You should have already attempted the problems using the nested vector format. You can see [example solutions](https://github.com/dyalog-training/2025-ListsWorkshop/blob/main/solutions/NESTED.dyalog) to help you.

1. Start Dyalog
1. Download the updated tests

    ```{ .apl .copy }
    ]get -u -o=Tests https://github.com/dyalog-training/2025-ListsWorkshop/blob/main/lists-of-words.dws
    ```

1. Create namespaces `MAT` and `DEL`

    ```{ .apl .copy }
    'MAT'⎕NS''
    'DEL'⎕NS''
    ```

1. The updated tests contain the `words` list in delimited simple character vector format. For testing, put the words list in the appropriate format into the namespaces containing your solutions for that format.

    ```{ .apl .copy }
    #.words←';'(≠⊆⊢)Tests.Delimited.words   ⍝ If nested solutions are in #
    DEL.words←Tests.Delimited.words
    MAT.words←↑';'(≠⊆⊢)DEL.words
    ```

1. You can now run the test suites for the two new list formats.

    ```{ .apl .copy }
    Tests.Run MAT
    Tests.Run DEL
    ```

## Part 1
Define functions to solve the problems using the new formats. Try to leverage properties of each format to derive the fastest solutions possible.

1. [`CountA`](./exercises.md#counta)
1. [`CountGORS`](./exercises.md#countgors)
1. [`CountGANDS`](./exercises.md#countgands)
1. [`CountELL`](./exercises.md#countell)
1. [`CountCON`](./exercises.md#countcon)

## Part 2
Define functions to solve the following problems using the new formats:

1. [`CountITY`](./exercises.md#countity)
1. [`CountSandwich`](./exercises.md#countsandwich)

## Part 3
Define functions to solve the following problems using the new formats:

1. [`CountC_T`](./exercises.md#countc_t)
1. [`CountN_Q`](./exercises.md#countn_q)
1. [`CountAlphabetical`](./exercises.md#countalphabetical)
1. [`CountAlternating`](./exercises.md#countalternating)
1. [`CountRepeating`](./exercises.md#countrepeating)
