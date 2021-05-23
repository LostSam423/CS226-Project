# CS226-Project
## IITB-Proc: 16-bit RISC based multi-cycle processor

The directory ``IITB_PROC/`` contains all the vhdl files of different components of the CPU. The main entity file is ``IITB_Proc.vhd`` whereas the testbench is ``testbench.vhd``. The testbench reads instructions from the file ``bin.txt`` and stores them into the memory, after that CPU executes those instructions maintaining its registers internally as per the instructions. Note that ``bin.txt`` is required to be in binary format. Instructions in Assembly language can be converted to binary by the script ``assmtobin.py``. Supported instructions are specified in the documentation ``Final Report.pdf``.

**Team Members**:
1. Aakriti - 190050002
2. Abhinav Gupta - 190050003
3. Sambit Behera - 190050104
4. Tulip Pandey - 190050125
