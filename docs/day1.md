# Day 1

## Setup
You should have already attempted the problems using the nested vector format. Now we will try to solve the problems again, taking advantage of the flat array formats to create faster solutions.

1. Download the updated tests workspace

    ```{ .apl .copy }
    ]get -u https://github.com/dyalog-training/2025-ListsWorkshop/blob/main/lists-of-words.dws
    ```

    It contains 4 namespaces:

    ```
    DEL MAT NEST Tests
    ```

    `NEST` includes [example solutions](https://github.com/dyalog-training/2025-ListsWorkshop/blob/main/solutions/NEST.dyalog) using the nested vector format that you can use as a starting point.

    `MAT` contains the character matrix format of the words list:

    ```
          ⍴MAT.words
    43189 20
    ```

    `DEL` contains the delimited character vector format of the words list:

    ```
          ⍴DEL.words
    385552
    ```

1. For the exercises, define new solution functions in the workspaces `MAT` and `DEL`:

    ```{.apl .copy}
    MAT.CountA ← { your solution here }
    ```

    While developing, you can check your answer against a nested solution:

    ```
          MAT.(CountA words)
    21313
          NEST.(CountA words)
    21313
    ```

    You can also run the test suite to check your answers:

    ```
          Tests.Run MAT
    **Error running test: Test_01_CountA
    **Solution not found: CountGORS
    **Solution not found: CountGANDS
    ···
    **Solution not found: RemoveInteriorVowels
    ```

## Exercises
Define functions to solve the problems using the new formats. Try to leverage properties of each format to derive the fastest solutions possible.

1. [`CountA`](./exercises.md#counta)
1. [`CountGORS`](./exercises.md#countgors)
1. [`CountGANDS`](./exercises.md#countgands)
1. [`CountELL`](./exercises.md#countell)
1. [`CountCON`](./exercises.md#countcon)
