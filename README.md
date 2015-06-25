# Hardware-Based Buffer Overflow Protection

This repository contributes to my Master's thesis in Electronic and Information Engineering at Imperial College London under the above title. This project was done during an Erasmus year in France. Thanks to Guillaume Duc from the Digital Electronics Systems (SEN) Department of Télécom ParisTech for his input and guidance as my supervisor for this project.

## Notes for markers

The `thesis` directory contains the documentation of this project including initial research and the project report. Also found there is the software written.

The other directories in the root of this repo belong to mor1kx, and remain so that the core can still be built from this repository, though the project is centred entirely on the DMMU, which can be found at rtl/verilog/mor1kx_dmmu.v

Below follows the original readme for this repo.

# _mor1kx_ - an OpenRISC processor IP core

## The Basics

This repository contains an OpenRISC 1000 compliant processor IP core.

It is written in Verilog HDL.

This repository only contains the IP source code and some documentation. For
a verification environment, please see other projects.

## Documentation

The documentation is located in the doc/ directory.

It is asciidoc format, and there's a makefile in there to build HTML or PDF. To
build the HTML documentation, run the following in the doc/ directory:

  make html

# License

It is licensed under the Open Hardware Description License (OHDL). For
details please see the LICENSE file or http://juliusbaxter.net/ohdl/
