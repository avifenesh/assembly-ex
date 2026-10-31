# assembly-ex

MIPS assembly exercises from Maman 12, written for the MARS simulator in 2022.

## Files

- `Q2.asm`: walks a linked list of half-word values in the data segment. It prints the sum of all values, the sum of the positive values divisible by 4, and each value in base 4 (with a leading `-` for negatives).
- `Q3.asm`: counts how often each capital letter appears in `CharStr`. It prints the ASCII code of the most frequent letter and its count, prints each letter repeated by its count, removes that letter from the string, and asks whether to run again.

## Run

Open a file in [MARS](https://github.com/dpetersanderson/MARS), assemble it and run. `Q3.asm` uses syscall 50 (confirm dialog), which is specific to MARS.
