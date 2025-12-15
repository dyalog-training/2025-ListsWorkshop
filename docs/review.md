# Exercise Solutions and Commentary

## Primary trade-offs of the 3 formats
In general, the nested format allows us to process words one at a time without having to make special considerations.

```
+/(∨/'A'∘∊)¨words
```

The delimited format can be the most performant in many cases, partly because it is the most efficient in terms of memory access, and techniques keep the array simple throughout the entire process. However, special Boolean techniques or arithmetic processing is usually required.

```
≢∪('A'=words)/+\';'=words
```

The matrix format falls somewhere in between. For certain problems, the direct solutions can be simpler, and faster, than their nested counterparts.

```
+/∨/'A'=words
```

But for other problems you have to deal with the trailing spaces, or otherwise end up using some approach that effectively splits the matrix up into the nested format anyway.

## CountA
The first few exercises involve searching for some content, usually returning a Boolean vector that can be summed to count how many words have that content.

```apl
CountA     ← {+/(∨/'A'∘∊)¨⍵}
CountGORS  ← {+/{∨⌿∨/'GS'∘.=⍵}¨⍵}
CountGANDS ← {+/{∧⌿∨/'GS'∘.=⍵}¨⍵}
CountELL   ← {+/'ELL'∘⍷¨⍵}
CountCON   ← {+/'CON'∘(⊃⍷)¨⍵}
```

Being very traditional APL, the straightforward solutions using the matrix format tend to be simple and fast.

```apl
CountA     ← {+/∨/⍵='A'}
CountGORS  ← {+/∨/⍵∊'GS'}
CountGANDS ← {+/∧/∨/'GS'∘.=⍵}
CountELL   ← {+/∨/'ELL'⍷⍵}
CountCON   ← {+/⊣/'CON'⍷⍵}
```

The delimited vector (AKA segmented string) is also a traditional format, for this type of data, used before nested arrays were introduced. Techniques using this format can be found by searching ["fast partitioned" in APLCart](https://aplcart.info/?q=fast%20partitioned). In this workshop, we used trailing delimiters, although it is more conventional in APL to have leading delimiters. The practical difference tends to be very small, a bit like having to add or subtract 1 depending on your `⎕IO` setting.

For this first group of problems, there are several reasonable approaches. Let's look at `CountA`; the other problems can all be solved using similar techniques.

```apl
{+/0<¯2-/0,(';'=⍵)/+\'A'=⍵}   ⍝ A
{≢∪(⍵='A')/+\⍵=';'}           ⍝ B
{+/(+\';'=⍵){∨/⍵}⌸'A'=⍵}      ⍝ C
{≢∪(';'=⍵)⍸⍥⍸'A'=⍵}           ⍝ D
{+/'A;'⍷⍵∩'A;'}               ⍝ E
```

### Sampling of Cumulative Sums

Versions **A** and **B** both take "the thing we are looking for" and "the delimiters" and sample cumulative counts of one using the other. In version **A**, we have a cumulative count of "A"s for the entire list of words.

```
      {↑⍵(';'=⍵)(+\'A'=⍵)}'CART;AND;HORSE;FALAFEL;'
C A R T ; A N D ; H O R S E ; F A L A F E L ;
0 0 0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1
0 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 3 3 4 4 4 4 4
```

Sampling by `';'=⍵` gives us the cumulative count at the end of each word.

```
      {(';'=⍵)/+\'A'=⍵}'CART;AND;HORSE;FALAFEL;'
1 2 2 4
```

We then do a pairwise difference to get the counts within each word.

```
      {¯2-/0,(';'=⍵)/+\'A'=⍵}'CART;AND;HORSE;FALAFEL;'
1 1 0 2
```

And finally count those words where the count is positive.

```
      {+/0<¯2-/0,(';'=⍵)/+\'A'=⍵}DEL.words
21313
```

Version **B** can be seen as a kind of ["dual"](https://en.wikipedia.org/wiki/Duality_(mathematics)) approach to this. Here, `+\';'=⍵` gives "IDs" that act like keys which group characters into their respective words.

```
      {↑⍵('A'=⍵)(+\';'=⍵)}'CART;AND;HORSE;FALAFEL;'
C A R T ; A N D ; H O R S E ; F A L A F E L ;
0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0
0 0 0 0 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4
```

We then select every ID where an "A" occurs:

```
      {('A'=⍵)/+\';'=⍵}'CART;AND;HORSE;FALAFEL;'
0 1 3 3
```

The count of unique IDs is our answer:

```
      {≢∪('A'=⍵)/+\';'=⍵}DEL.words
21313
```

It turns out that taking the unique cumulative counts and taking the unique IDs gives the same result:

```
      {+/≠(';'=⍵)/+\'A'=⍵}DEL.words   ⍝ +/≠ ←→ ≢∪
21313
```

### Key

Of course, since we identified that `+\';'=⍵` gives us keys that group each character by which word they belong to, we can just as well use the key operator `⌸` to perform our query. This is the technique used in version **C**.

```
      {(+\';'=⍵){∨/⍵}⌸'A'=⍵}'CART;AND;HORSE;FALAFEL;'
1 1 0 1 0
```

Key is quite general, so unfortunately this version has the worst performance out of these solutions.

### Interval-index

Version **D** takes an arithmetic approach. Using Where `⍸`, we can find indices that mark boundaries of each word, and the indices of occurrences of "A":

```
      {⍪(⍸';'=⍵)(⍸'A'=⍵)}'CART;AND;HORSE;FALAFEL;'
┌─────────┐
│5 9 15 23│
├─────────┤
│2 6 17 19│
└─────────┘
```

Interval-index `⍸` then tells us which word each occurrence of "A" belongs to:

```
      ]box off
Was ON
      {↑(⍵)((⍸b)⍸⍳≢⍵)(b\⍕¨⍸b←';'=⍵)(a\⍕¨⍸a←'A'=⍵)}'CART;AND;HORSE;FALAFEL;'
 C  A  R  T  ;  A  N  D  ;  H  O  R  S  E   ;  F   A  L   A  F  E  L   ;
 0  0  0  0  1  1  1  1  2  2  2  2  2  2   3  3   3  3   3  3  3  3   4
             5           9                 15                         23
    2           6                                 17     19             

      {(⍸';'=⍵)⍸(⍸'A'=⍵)}'CART;AND;HORSE;FALAFEL;'
0 1 3 3
```

Notice the repeated use of Where `⍸`, this is the Over `⍥` pattern.

```
      {(';'=⍵)⍸⍥⍸('A'=⍵)}'CART;AND;HORSE;FALAFEL;'
0 1 3 3
```

We can also factor out `=⍵`:

```
      {';'⍸⍥(⍸=∘⍵)'A'}'CART;AND;HORSE;FALAFEL;'
0 1 3 3
```

The extent that this is helpful is a matter of debate. In any case, from here we just count unique buckets:

```
      {≢∪';'⍸⍥(⍸=∘⍵)'A'}DEL.words
21313
```

### Filter and Find

And lastly there is version **E**. We actually don't care about most of the data in our words list. For counting "A"s in each word, we only care about the "A" characters and the delimiters.

```
      {⍵∩'A;'}'CART;AND;HORSE;FALAFEL;'
A;A;;AA;
```

Then we just need the number of occurrences of `'A;'`:

```
      {+/'A;'⍷⍵∩'A;'}DEL.words
21313
```

For some small left arguments to find `⍷`, it's actually a little faster to do an outer product, shift the rows of the resulting matrix, and see where occurrences overlap. Of course, we have to be careful with wrap-around, so we'll use drop `↓` with the rank operator `⍤` instead of rotate `⌽`.

```
      {'A;'⍷⍵∩'A;'}'CART;AND;HORSE;FALAFEL;'
1 0 1 0 0 0 1 0
      {∧⌿0 1(↓⍤0 1)'A;'∘.=⍵∩'A;'}'CART;AND;HORSE;FALAFEL;'
1 0 1 0 0 0 1 0
```

### Inner Product Shortut
The inner product `∨.=` can be used in place of `∨/'A'=⍵` for the nested and matrix formats. This has a potential advantage because `∨.=` will stop searching each word as soon as it finds a match.

```
      ]runtime -c "{+/⍵∨.='A'}MAT.words" "{+/∨/'A'=⍵}MAT.words"
                                                                                
  {+/⍵∨.='A'}MAT.words → 1.9E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
  {+/∨/'A'=⍵}MAT.words → 4.4E¯5 | -77% ⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
```

Well, for our data the words are quite short, so the shortcut isn't helping enough compared to the interpretive overhead of inner product. See the difference when we use a list of long words:

```
      MAT.long_words←↑1000⍴¨NEST.words
      ]runtime -c "{+/⍵∨.='A'}MAT.long_words" "{+/∨/'A'=⍵}MAT.long_words"
                                                                                     
  {+/⍵∨.='A'}MAT.long_words → 1.9E¯3 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕                   
  {+/∨/'A'=⍵}MAT.long_words → 3.3E¯3 | +78% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
```

## CountGORS and CountGANDS
The outer-product spelling makes a clear relationship between `CountGORS` and `CountGANDS`.

```apl
CountGORS  ← {+/∨⌿∨/'GS'∘.=⍵}
CountGANDS ← {+/∧⌿∨/'GS'∘.=⍵}
```

The idea of removing unwanted data is inverted in the following expression, using the nested representation, for `CountGANDS`.

```apl
CountGANDS ← {+/{0∊⍴'GS'~⍵}¨⍵}
```

## CountCON
This is another instance where we get better performance by reducing the search space. A simple "find first" solution is quite easy to understand:

```apl
CountCON ← {+/'CON'∘(⊃⍷)¨⍵}
```

But here, find `⍷` will search the entirety of every word. We know we only care about the first three characters, so why don't we only look at those?

```
CountCON ← {+/'CON'∘≡¨3↑¨⍵}
```

## CountSandwich
In [`CountSandwich`](./exercises.md#countsandwich), the problem is to compare the first and last characters of each word in our list.

### Nested
For the nested format, here are some reasonable expressions:

```apl
(⊣/=⊢/)¨
(⊃=⊃∘⌽)¨
{⍵[1]=⍵[≢⍵]}¨
```

### Delimited
For the delimited format, there is only really one approach which is best.

```
      {⍵⌿⍤1⍨¯1 1(⌽⍤0 1)';'=⍵}'FIFE;ONO;PEEP;CHEAT;TOOT;ALPHA;'
FOPCTA
EOPTTA
```

There are other valid ways to spell it, and indeed a version without the rank operator is faster in current Dyalog:

```
      {=⌿⍵⌿⍤1⍨¯1 1(⌽⍤0 1)';'=⍵}'FIFE;ONO;PEEP;CHEAT;TOOT;ALPHA;'
0 1 1 0 1 1
      {(⍵/⍨¯1⌽b)=⍵/⍨1⌽b←';'=⍵}'FIFE;ONO;PEEP;CHEAT;TOOT;ALPHA;'    ⍝ Faster in Dyalog v20.0
0 1 1 0 1 1
```

But in any case, the optimal idea is using rotations on the delimiter mask `';'=⍵` to select the first and last letters. You could try other methods, such as using arithmetic on indices, but there really isn't any benefit to doing so in this case.

### Matrix
For the matrix format, selecting the first letter of each word is trivial:

```
      {⊣/⍵}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
FOPCTA
      {⍵[;1]}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
FOPCTA
```

The main problem is to identify the last letter of each word. This is the last non-space character in each row.

```
      {⍵(' '=⍵)}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
┌─────┬─────────┐
│FIFE │0 0 0 0 1│
│ONO  │0 0 0 1 1│
│PEEP │0 0 0 0 1│
│CHEAT│0 0 0 0 0│
│TOOT │0 0 0 0 1│
│ALPHA│0 0 0 0 0│
└─────┴─────────┘
```

We can use the less-than-scan `<\` to keep the first 1 in each row. We need to append 1s to keep the last letters of the longest words.

```
      {⍵(last)(⍵,[1.5]last←1↓⍤1<\1,⍨' '=⍵)}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
┌─────┬─────────┬─────────┐
│FIFE │0 0 0 1 0│F I F E  │
│ONO  │0 0 1 0 0│0 0 0 1 0│
│PEEP │0 0 0 1 0│         │
│CHEAT│0 0 0 0 1│O N O    │
│TOOT │0 0 0 1 0│0 0 1 0 0│
│ALPHA│0 0 0 0 1│         │
│     │         │P E E P  │
│     │         │0 0 0 1 0│
│     │         │         │
│     │         │C H E A T│
│     │         │0 0 0 0 1│
│     │         │         │
│     │         │T O O T  │
│     │         │0 0 0 1 0│
│     │         │         │
│     │         │A L P H A│
│     │         │0 0 0 0 1│
└─────┴─────────┴─────────┘
```

Then we can get the last letters with compress-over-ravel:

```
      {⍵⌿⍥,⍨1↓⍤1<\1,⍨' '=⍵}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
EOPTTA
```

Another approach is to compute the length, and therefore the index of the last letter, of each word. One method is to sum the non-space characters in each row:

```
      {+/' '≠⍵}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
4 3 4 5 4 5
```

Another approach is to use index-of `⍳` to find the index of the first space in each row.

```
      {¯1+⍵⍳⍤1⊢' '}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
4 3 4 5 4 5
```

We can then use indexing to select the last letters.

```
      {(¯1+⍵⍳⍤1⊢' ')(⌷⍤0 1)⍵}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
EOPTTA
```

```
      {(⊣/⍵)=(¯1+⍵⍳⍤1⊢' ')(⌷⍤0 1)⍵}↑'FIFE' 'ONO' 'PEEP' 'CHEAT' 'TOOT' 'ALPHA'
0 1 1 0 1 1
```

Index-of with rank and index with rank have been optimised for these cases.

```
      ]runtime -c "{+/(⊣/⍵)=(¯1+⍵⍳⍤1⊢' ')(⌷⍤0 1)⍵}MAT.words" "{+/(⊣/⍵)=⍵⌿⍥,⍨1↓⍤1<\1,⍨' '=⍵}MAT.words"
                                                                                                     
  {+/(⊣/⍵)=(¯1+⍵⍳⍤1⊢' ')(⌷⍤0 1)⍵}MAT.words → 3.7E¯4 |    0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕                         
  {+/(⊣/⍵)=⍵⌿⍥,⍨1↓⍤1<\1,⍨' '=⍵}MAT.words   → 9.0E¯4 | +144% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
```

## CountC_T
Searching for specific text patterns with wildcards and other ambiguities sits squarely in the domain of regular expressions. And indeed, the regular expression for this pattern is not complicated.

```
      'C.T'⎕S'&'⊢'CTA' 'CAT' 'TAC' 'POOF' 'CAAT'
┌───┐
│CAT│
└───┘
```

We have to be careful that we do not count a word twice just because it contains the pattern twice:

```
      'C.T'⎕S '&'⊢'CTA' 'CAT' 'TAC' 'CUTCUTTING' 'POOF' 'CAAT'
┌───┬───┬───┐
│CAT│CUT│CUT│
└───┴───┴───┘
```

We can ask `⎕S` to stop after one match using the Match Limit (ML) variant option:

```
      'C.T'⎕S'&'⍠'ML' 1⊢'CTA' 'CAT' 'TAC' 'CUTCUTTING' 'POOF' 'CAAT'
┌───┬───┐
│CAT│CUT│
└───┴───┘
```

However, regular expressions are very general and therefore compute relatively slowly compared to APL solutions.

We can try to use index-of `⍳` to identify "C" and "T" characters, and get a placeholder for "any other character":

```
      {'CT'⍳⍵}¨'CTA' 'CAT' 'TAC' 'CUTCUTTING' 'POOF' 'CAAT'
┌─────┬─────┬─────┬───────────────────┬───────┬───────┐
│1 2 3│1 3 2│2 3 1│1 3 2 1 3 2 2 3 3 3│3 3 3 3│1 3 3 2│
└─────┴─────┴─────┴───────────────────┴───────┴───────┘
```

So then the pattern `1 3 2` means "C" and "another character" then "T", but then we have two edge cases:

```
      {'CT'⍳⍵}¨'C*T' 'CCT' 'CTT'
┌─────┬─────┬─────┐
│1 3 2│1 1 2│1 2 2│
└─────┴─────┴─────┘
```

```
      {+/{∨/∨/¨(1 1 2)(1 2 2)(1 3 2)⍷¨⊂'CT'⍳⍵}¨⍵}NEST.words
654
```

Instead, we can look for the "C" characters and then shift the mask by two places and see whether it identifies "T" characters. Remember to use drop `↓` instead of rotate `⌽` to avoid wraparound issues.

```
      {↑(⍵)('C'=⍵)(0 0,¯2↓'C'=⍵)}¨'CTA' 'CAT' 'TAC' 'CUTCUTTING' 'POOF' 'CAAT'
┌─────┬─────┬─────┬───────────────────┬───────┬───────┐
│C T A│C A T│T A C│C U T C U T T I N G│P O O F│C A A T│
│1 0 0│1 0 0│0 0 1│1 0 0 1 0 0 0 0 0 0│0 0 0 0│1 0 0 0│
│0 0 1│0 0 1│0 0 0│0 0 1 0 0 1 0 0 0 0│0 0 0 0│0 0 1 0│
└─────┴─────┴─────┴───────────────────┴───────┴───────┘
```

Our pattern is found where the shifted "C" is in the location of a "T":

```
      {⍵,[.5](-≢⍵)↑(2↓'T'=⍵)∧(¯2↓'C'=⍵)}¨'CTA' 'CAT' 'TAC' 'CUTCUTTING' 'POOF' 'CAAT'
┌─────┬─────┬─────┬───────────────────┬───────┬───────┐
│C T A│C A T│T A C│C U T C U T T I N G│P O O F│C A A T│
│0 0 0│0 0 1│0 0 0│0 0 1 0 0 1 0 0 0 0│0 0 0 0│0 0 0 0│
└─────┴─────┴─────┴───────────────────┴───────┴───────┘
      {+/{∨/(2↓'T'=⍵)∧(¯2↓'C'=⍵)}¨⍵}NEST.words
654
```

This technique maps well to the matrix format as well:

```
      {+/∨/(2↓[2]'T'=⍵)∧(¯2↓[2]'C'=⍵)}MAT.words
654
```

Let's compare runtimes. To make the comparison more fair, we refactor the nested approach to move the loops (eaches `¨`) inside the dfn. Moving loops closer to primitives is generally better for performance in interpreted Dyalog APL, even though it makes the code look "peppery" (littered with eaches) and unpleasant.

Even so, the matrix format wins out in both memory usage and compute time:

```
      ]runtime -c "{+/∨/(2↓[2]'T'=⍵)∧(¯2↓[2]'C'=⍵)}MAT.words" "{+/∨/¨(2↓¨'T'=⍵)∧(¯2↓¨'C'=⍵)}NEST.words"
                                                                                                       
  {+/∨/(2↓[2]'T'=⍵)∧(¯2↓[2]'C'=⍵)}MAT.words → 1.4E¯3 |     0% ⎕⎕⎕                                      
  {+/∨/¨(2↓¨'T'=⍵)∧(¯2↓¨'C'=⍵)}NEST.words   → 1.6E¯2 | +1070% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
```

The delimited vector approach is much the same, except now we have an edge case at the boundaries of words. Notice the pattern is found between "MANIC" and "TOUCAN":

```
      {⍵,[.5]0 0,(2↓'T'=⍵)∧(¯2↓'C'=⍵)}'ABC;CAT;MANIC;TOUCAN;CUTCUTTING;ABC;'
A B C ; C A T ; M A N I C ; T O U C A N ; C U T C U T T I N G ; A B C ;
0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0
```

To mitigate this, we only keep patterns found outside of delimiters (`';'≠⍵`):

```
      {⍵,[.5]0 0,(1↓¯1↓';'≠⍵)∧(2↓'T'=⍵)∧(¯2↓'C'=⍵)}'ABC;CAT;MANIC;TOUCAN;CUTCUTTING;ABC;'
A B C ; C A T ; M A N I C ; T O U C A N ; C U T C U T T I N G ; A B C ;
0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0
```

## CountN_Q
This pattern is also simple as a regular expression.

```
      'N.*Q'⎕S'&'⊢'ANTIQUE' 'QUININE' 'INEQUALITY' 'BANQUET' 'FISH'
┌────┬───┬──┐
│NTIQ│NEQ│NQ│
└────┴───┴──┘
```

Here the main trick to APL solutions is to remove irrelevant characters, as we saw with [`CountA`](#filter-and-find), then we can use find `⍷` to look for just the pattern of interest:

```
      {⍵,∨/'NQ'⍷⍵∩'NQ'}¨'ANTIQUE' 'QUININE' 'INEQUALITY' 'BANQUET' 'FISH'
┌─────────┬─────────┬────────────┬─────────┬──────┐
│ANTIQUE 1│QUININE 0│INEQUALITY 1│BANQUET 1│FISH 0│
└─────────┴─────────┴────────────┴─────────┴──────┘
```

This method applies best to the delimited format. However, we have to watch out for edge cases with repeated "Q"s and "N"s:

```
      {w,[0.5]'NQ;'⍷w←⍵∩'NQ;'}'NQQQN;QNNNQ;ANTIQUE;'
N Q Q Q N ; Q N N N Q ; N Q ;
0 0 0 0 0 0 0 0 0 1 0 0 1 0 0
```

We can always use the fast partitioned techniques from before:

```
      {≢∪(+\';'=w)/⍨'NQ'⍷w←⍵∩'NQ;'}DEL.words
118
```

Or we could try to filter away the bad stuff:

```
      {(~'N;'⍷w)/w←(2≠/'x',w)/w←⍵∩'NQ;'}'NQQQN;QNNNQ;QUEEN;ANTIQUE;'
NQ;QNQ;Q;NQ;
```

Now we can count occurrences of `'NQ;'` to find our answer. An opportunity to use the "filter" pattern with behind `F⍛/` in version 20.0.

```
      {+/'NQ'⍷('N;'~⍤⍷⊢)⍛/(2≠/'x',⊢)⍛/⍵∩'NQ;'}DEL.words
118
```

These two approaches seem to perform similarly. It appears that the extra processing in the filtering version is offset by the reduced amount of data after each filtering step. At the end `'NQ'⍷` is doing far less searching in the second version.

As for the matrix format, we could use a similar technique applied to rows with the rank operator:

```
      {+/∨/'NQ'⍷⍵∩⍤1⊢'NQ'}↑MAT.words
118
```

A more interesting approach is to or-scan occurrences of "N", thereby making a mask of characters that come after "N".

```
      {∨\'N'=⍵}↑'ANTIQUE' 'QUININE' 'INEQUALITY' 'BANQUET' 'FISH'
0 1 1 1 1 1 1 1 1 1
0 0 0 1 1 1 1 1 1 1
0 1 1 1 1 1 1 1 1 1
0 0 1 1 1 1 1 1 1 1
0 0 0 0 0 0 0 0 0 0
```

Any "Q" that falls in that range indicates that our pattern was found:

```
      {⍵,⍪∨/(∨\'N'=⍵)∧'Q'=⍵}↑'ANTIQUE' 'QUININE' 'INEQUALITY' 'BANQUET' 'FISH'
ANTIQUE    1
QUININE    0
INEQUALITY 1
BANQUET    1
FISH       0
```

It's much faster if we can avoid set operations like intersection `∩`:

```
      ]runtime -c "{+/∨/(∨\'N'=⍵)∧'Q'=⍵}MAT.words" "{+/∨/'NQ'⍷⍵∩⍤1⊢'NQ'}MAT.words"
                                                                                            
  {+/∨/(∨\'N'=⍵)∧'Q'=⍵}MAT.words → 1.5E¯4 |     0% ⎕                                        
  {+/∨/'NQ'⍷⍵∩⍤1⊢'NQ'}MAT.words  → 4.2E¯3 | +2696% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
```

Perhaps we can take a similar approach for the nested format using those fast partitioned idioms from APLCart?

```apl
 CountN_Q←{
⍝ ⍵: trailing-delimiter-separated words :: simple character vector
⍝ ←: count of words in ⍵ that have a 'Q' anywhere after an 'N' :: simple numeric vector (≢←)=(+/';'=⍵)
     OrScan←{≠\b\2≠/0,⍵⌿⍨b←⍺∨⍵}         ⍝ ∨\ of bits in each partition of ⍵ marked by 1s in ⍺
     FirstOne←{(⍺∧⍵)∨b\2</0,⍵/⍨b←⍺∨⍵}   ⍝ <\ of bits in each partition of ⍵ marked by 1s in ⍺
     del←¯1⌽';'=⍵
     +/del FirstOne('Q'=⍵)∧del OrScan'N'=⍵
 }
```

As is often the case, for the cost of extra code complexity we get a significant boost in performance:

```
      ]runtime -c "DEL.(CountN_Q words)" "{≢∪(+\';'=w)/⍨'NQ'⍷w←⍵∩'NQ;'}DEL.words"
                                                                                                   
  DEL.(CountN_Q words)                   → 1.9E¯4 |    0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕                               
  {≢∪(+\';'=w)/⍨'NQ'⍷w←⍵∩'NQ;'}DEL.words → 7.2E¯4 | +287% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕ 
```

## Conclusion

Performance is not typically a primary goal of writing production code. However, when performance is important, there are no blanket rules or techniques that always speed things up, but instead there are heuristics and general advice. What is most important is understanding your use case and data so that you can understand which approaches are most likely to give the biggest benefit.
