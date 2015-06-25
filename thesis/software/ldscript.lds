MEMORY
{
	ram (!rx) : ORIGIN = 0x0, LENGTH = 8M
	empty (!rx) : ORIGIN = 0, LENGTH = 0
}

ENTRY(_start)

SECTIONS
{


	.text :
	{
		crt0.o(.text);
		*(.text);
		. = ALIGN(4);
	} >ram

	.rodata :
	{
		*(.rodata*);
		. = ALIGN(4);
	} >ram

	.data :
	{
		*(.data);
	} >empty

	.bss :
	{
		*(.bss) *(*COMMON*);
	} >empty
}

_stack = ORIGIN(ram) + LENGTH(ram);
