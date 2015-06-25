#define UART_BASE    0x90000000
#define UART_RX      (*(volatile unsigned char *) (UART_BASE+0x0))
#define UART_TX      (*(volatile unsigned char *) (UART_BASE+0x0))
#define UART_IER     (*(volatile unsigned char *) (UART_BASE+0x1))
#define UART_IIR     (*(volatile unsigned char *) (UART_BASE+0x2))
#define UART_FCR     (*(volatile unsigned char *) (UART_BASE+0x2))
#define UART_LCR     (*(volatile unsigned char *) (UART_BASE+0x3))
#define UART_MCR     (*(volatile unsigned char *) (UART_BASE+0x4))
#define UART_LSR     (*(volatile unsigned char *) (UART_BASE+0x5))
#define UART_MSR     (*(volatile unsigned char *) (UART_BASE+0x6))
#define UART_DLB_LSB (*(volatile unsigned char *) (UART_BASE+0x0))
#define UART_DLB_MSB (*(volatile unsigned char *) (UART_BASE+0x1))

void serial_init()
{
  // Init LCR: 8 bits, 1 stop, no parity, divisor latch access bit = 1
  UART_LCR = 0x83; // 1000_0011

  // Divisor (sys_freq/(16*baud_rate)) = (50e6/(16*115200)) = 27
  UART_DLB_MSB = 0;
  UART_DLB_LSB = 27;

  // LCR: divisor latch access bit = 0
  UART_LCR = 0x03; // 0000_0011
}

void serial_putc(const char c)
{
  while ((UART_LSR & 0x20) == 0);
  UART_TX = c;
}

void serial_puts(const char * str)
{
  while (*str != 0)
    {
      serial_putc(*str);
      str++;
    }
}

int main()
{
  serial_init();

  serial_puts("Hello world!\r\n");

  int a = 0;
  int b = 1;
  
  while(b < 100)
    {
      serial_putc(b);
      serial_puts("\r\n");
      
      b += a;
      a = b-a;
    }
  
  return 0;
}
