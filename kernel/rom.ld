MEMORY 
{ 
   rom: org = 0xf80000, len = 0x10000
} 

SECTIONS {
  .text: { *(.text) *(CODE) *(text) } >rom
  .data: { *(.data) *(DATA) *(data) } >rom
  .bss: { *(.bss) *(BSS) *(bss) } >rom
}
