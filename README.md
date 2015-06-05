#print-cli

`print-cli` is a command line tool to print document on OSX.

##usage

`print-cli` will print usage and available printers:

````
Usage: printer-cli /path/to/file ["printer name"]
Available printers:
Brother HL-2250DN series
Brother HL-2250DN series @ admin’s Mac mini
Brother HL-L2300D series
````

`print-cli /tmp/badge.pdf` will print the `badge.pdf` file on the default printer.

`print-cli /tmp/badge.pdf "Brother HL-L2300D series"` will print `badge.pdf` on the specified printer.


Document will be printed in standard A4 page.

