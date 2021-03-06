# ASM

x86, arm, RISC-V

CISC v.s. RISC

# RISC-V

## registers

32 registers which has 32 bytes (a word)

## assembler directives

| Directive | Effect                                                       |
| --------- | ------------------------------------------------------------ |
| `.data`   | Store subsequent items in the static segment at the next available address. |
| `.text`   | Store subsequent instructions in the text segment at the next available address. |
| `.byte`   | Store listed values as 8-bit bytes.                          |
| `.asciiz` | Store subsequent string in the data segment and add null-terminator. |
| `.word`   | Store listed values as unaligned 32-bit words.               |
| `.globl`  | Makes the given label global.                                |
| `.float`  | Reserved.                                                    |
| `.double` | Reserved.                                                    |
| `.align`  | Reserved.                                                    |

```assembly
.data
source:
	.word 3
	.word 1
	.word 4
.text
main:
	la t1,source
	lw t2, 0(t1)
	lw t3, 4(t1)
```

## Endianness

**RISC-V is little endian**

## extend

**All base RISC-V instructions sign extend when needed**

sign-extend: `0b11`=>`0b1111`

zero-pad: `0b11`=>`0b0011`

one-pad: `0b11`=>`0b1111`

# operators

- `op dst src1,src2`
- add `add dst src1 src2`
- add immediately `addi t1 s1,5`
- no `subi` for simplicity

## data transfer

- `memop reg, off(bAddr)`

- `lw reg, off(bAddr)` `sw reg, off(bAddr)`

- example

  ```assembly
  lw  t0,12(s3)
  add t0,s2,t0
  sw  t0,40(s3)
  ```

## byte instructions

- `sb` save least significant byte
- `lb` load leat significant byte with sign-extend

```assembly
# s0 = 0x00000180
lb s1,1(s0) # s1=0x00000001
lb s2,0(s0) # s2=0xFFFFFF80
sb sb,2(s0) # s0=0x00800180
```

- `lh` load half, load upper 2 byte with sign-extend
- `sh` save half, save uppter 2 byte
- `lhu` `lbu` load falf and byte filled with zero-pad
- `s(h/b)u` is equivelant to `s(h/b)`

## control flow

`beq` `bne` `j`

`blt` `bge`

## shifting

shift left|right logical|arithmetic [imm]

take 0-31 

## other

multiplication `mul` `mulh`

division `div` `rem`

bitwise op `and` `or` `xor`

comparation `slt` `slti`

environment call `ecall`

## functions

1. prepare arguments

   `a0`-`a7` in value

   `a0`-`a1` out value

   if need more, use memory

2. transfer control

   `jal dst label` set dst register with proper vaue and jump to label

3. acquire storage

4. run the task

   `s0`-`s11` saved registers `sp`, must be the same before and after callee

   `t0`-`t6` `a0`-`a7` `ra` can be used freely by callee

5. prepare return values

6. get control back

   `jr src`

```assembly
func_label:
	addi sp,sp, -framesize # "allocate" local space
	sw ra, <framesize-4>(sp) # save ra
	# store other callee saved registers
	# do sth
	lw ra,<framesize-4>(sp) # retrieve ra
	addi sp,sp, framesize(sp) # "delete" space
	jr ra # ret
```



caller must save `t0`-`t6` `a0`-`a7` `ra`

callee must save `s0`-`s11`



### choose registers

- use less registers, saving as less as possible
- use `t0`-`t6` when a single function
- use `s0`-`s11` then `t0`-`t6`, when a function calls other functions

# RISC-V instruction formats

R: instructions with 3 registers

I: instructions with immediates

S: store

SB: branch

U: upper immediates,`lui` `addi`

UJ: jal

