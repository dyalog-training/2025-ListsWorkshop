# Day 1

## Setup
You should have already attempted the problems using the nested vector format. You can see example solutions to help you.

1. Start Dyalog
1. Download the updated tests
1. Create namespaces `MAT` and `DEL`
1. Define character matrix and delimited character vector foramts

    ```apl
    MAT.words←↑words
    DEL.words←∊,∘';'¨words
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
