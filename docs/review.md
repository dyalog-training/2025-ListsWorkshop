# Exercise Solutions and Commentary

## Primary trade-offs of the 3 formats
In general, the nested format allows us to process words one at a time without having to make special considerations.

```
+/(∨/'A'∘∊)¨words
```

The delimited format can be the most performant in many cases, partly because it is the most efficient in terms of memory access, and techniques keep the array simple throughout the entire process. However, special Boolean techniques or arithmetic processing is usually required.

```
≢∪
```

## Day 1
The first few exercises involve searching for some content, usually returning a Boolean vector that can be summed to count how many words have that content.

```apl
CountA ← {+/(∨/'A'∘∊)¨⍵}
CountGORS ← {+/{∨⌿∨/'GS'∘.=⍵}¨⍵}
CountGANDS ← {+/{∧⌿∨/'GS'∘.=⍵}¨⍵}
CountELL ← {+/'ELL'∘⍷¨⍵}
CountCON ← {+/'CON'∘(⊃⍷)¨⍵}
```

Being very traditional APL, the straightforward outer-product-based solutions using the matrix format tend to be simple and fast.

```apl
CountA ← {+/∨/⍵='A'}
CountGORS ← {+/∨/⍵∊'GS'}
CountGANDS ← {+/∧/∨/'GS'∘.=⍵}
CountELL ← {+/∨/'ELL'⍷⍵}
CountCON ← {+/⊣/'CON'⍷⍵}
```

The delimited vector (AKA segmented string) is also a traditional format for this type of data used before nested arrays were introduced. Techniques using this format can be found by searching ["fast partitioned" in APLCart](https://aplcart.info/?q=fast%20partitioned). In this workshop, we used trailing delimiters, although it is more conventional in APL to have leading delimiters. The practical difference tends to be very small, a bit like having to add or subtract 1 depending on your `⎕IO` setting.

For this first group of problems, there are several reasonable approaches. Let's look at `CountA`; the other problems can all be solved using similar techniques.

```apl
{+/0<¯2-/0,(';'=⍵)/+\'A'=⍵}   ⍝ A
{≢∪(⍵='A')/+\⍵=';'}           ⍝ B
{≢∪(';'=⍵)⍸⍥⍸'A'=⍵}           ⍝ C
{+/(+\';'=⍵){∨/⍵}⌸'A'=⍵}      ⍝ D
{+/'A;'⍷⍵∩'A;'}               ⍝ E
```

Versions **A** and **B** both take "the thing we are looking for" and "the delimiters" and sample counts of one using the other. In **A**, we have a cumulative count of "A"s for the entire list of words.

```
      {↑⍵(';'=⍵)(+\'A'=⍵)}'CART;AND;HORSE;FALAFEL;'
C A R T ; A N D ; H O R S E ; F A L A F E L ;
0 0 0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1
0 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 3 3 4 4 4 4 4
```

Sampling by `';'=⍵` gives us the total count at the end of each word.

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

Version **B** can be seen as a kind of "dual" approach to this. Here, `+\';'=⍵` gives "IDs" that can be used act like keys to group characters as their respective words.

```
      {↑⍵('A'=⍵)(+\';'=⍵)}'CART;AND;HORSE;FALAFEL;'
C A R T ; A N D ; H O R S E ; F A L A F E L ;
0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0
0 0 0 0 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4
```

Selecting gives every ID where an "A" occurs:

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

Of course, since we identified that `+\';'=⍵` gives us keys that group each character by which word they belong to, we can just as well use the key operator `⌸` to perform our query.

```
      {(+\';'=⍵){∨/⍵}⌸'A'=⍵}'CART;AND;HORSE;FALAFEL;'
1 1 0 1 0
```

Key is quite general, so this version has the worst performance out of these solutions.

## Filtering
We actually don't care about most of the data in our words list. For counting "A"s in each word, we only care about the "A" characters and the delimiters.

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

This idea can also be used for `CountGORS`.

```apl
CountGORS ← {+/{0∊⍴'GS'~⍵}¨⍵}
```

Now, if the purpose of using these alternative formats is to improve performance, which expressions should we compare to determine relative performance?

```apl
CountA ← {+/∨/⍵='A'}
CountGORS ← {+/∨/⍵∊'GS'}
CountGANDS ← {+/∧/∨/'GS'∘.=⍵}
CountELL ← {+/∨/'ELL'⍷⍵}
CountCON ← {+/⊣/'CON'⍷⍵}
```

## Inner Product Shortut
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


FIXME remove GS GANDS
FIXME 3↑ CountCON

## Day 2

### CountSandwich
In [`CountSandwich`](./exercises.md#countsandwich), the problem is to compare the first and last characters of each word in our list.

#### Nested
For the nested format, here are some equally reasonable expressions:

```apl
(⊣/=⊢/)¨
(⊃=⊃∘⌽)¨
{⍵[1]=⍵[≢⍵]}¨
```

#### Delimited
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

#### Matrix
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

### CountC_T and CountN_Q
Searching for specific text patterns with wildcards and other ambiguities sits squarely in the domain of regular expressions. And indeed, the regular expressions for these two patterns are not complicated.

```
      'C.T'⎕S'&'⊢'CTA' 'CAT' 'TAC' 'POOF' 'CAAT'
┌───┐
│CAT│
└───┘
      'N.*Q'⎕S'&'⊢'ANTIQUE' 'QUININE' 'NQN' 'QNQ' 'INEQUALITY' 'BANQUET' 'FISH'
┌────┬──┬──┬───┬──┐
│NTIQ│NQ│NQ│NEQ│NQ│
└────┴──┴──┴───┴──┘
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

However, regular expressions are very general, and therefore compute relatively slowly compared to APL solutions.

FIXME CountC_T
FIXME CountN_Q
