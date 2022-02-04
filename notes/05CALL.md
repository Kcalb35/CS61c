# CALL
|           | input               | output                                       |                                                              |
| --------- | ------------------- | -------------------------------------------- | ------------------------------------------------------------ |
| compiler  | high level language | assembly language                            | may contain pseudo-instructions                              |
| assembler | assembly language   | object code(true asm and information tables) | pseudo-instruction replacement<br />produce machine language |
| linker    | object code         | executable code                              |                                                              |
| loader    | executable code     | run                                          |                                                              |

# assembler

## symbol table

- labels

- labels: function calling
- data: `.data`

## relocation table

- places where need address
- `jal` `jalr`

- something reference to `.data` 

## object file

1. object file header
2. text segment
3. data segment
4. reloacation table
5. symol table
6. debugging information

# linker

1. combine `text` segment
2. combine `data` segment
3. go through reloaction table, fill all absolute address

three type of address

- pc-relative address: beq,bne,bge,blt,jal **no-relocate**
- external function: jal->**relocate**
- static data reference: ->**relocate**

jal and lw/sw to static data need relocation editing	
