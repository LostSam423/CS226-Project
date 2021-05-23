import sys
from bitstring import Bits

f = open('in.txt', 'r')
g = open('bin.txt', 'w')

lines = f.readlines()
for line in lines:
	ins = line.split(' ')

	if (ins[0] == "add" or ins[0] == "adc" or ins[0] == "adz" or ins[0] == "ndu" or ins[0] == "ndc" or ins[0] == "ndz"):
		if ins[0][0] == 'a':
			bin = "0000"
		else:
			bin = "0010"
		bin = bin + '{0:03b}'.format(int(ins[2][1])) + '{0:03b}'.format(int(ins[3][1])) + '{0:03b}'.format(int(ins[1][1])) + "0"
		if ins[0][2] == 'c':
			bin = bin + "01"
		elif ins[0][2] == 'z':
			bin = bin + "10"
		else:
			bin = bin + "00"
			
	elif ins[0] == "adi":
		imm = int(ins[3])
		b = Bits(int = imm, length=6)
		bin = "0001" + '{0:03b}'.format(int(ins[2][1])) + '{0:03b}'.format(int(ins[1][1])) + b.bin

	elif ins[0] == "lhi":
		imm = int(ins[2])
		b = Bits(int = imm, length=9)
		bin = "0011" + '{0:03b}'.format(int(ins[1][1])) + b.bin

	elif ins[0] == "lw":
		imm = int(ins[3])
		b = Bits(int = imm, length=6)
		bin = "0100" + '{0:03b}'.format(int(ins[1][1])) + '{0:03b}'.format(int(ins[2][1])) + b.bin

	elif ins[0] == "sw":
		imm = int(ins[3])
		b = Bits(int = imm, length=6)
		bin = "0101" + '{0:03b}'.format(int(ins[1][1])) + '{0:03b}'.format(int(ins[2][1])) + b.bin

	elif ins[0] == "lm":
		bin = "0110" + '{0:03b}'.format(int(ins[1][1])) + "000000000"

	elif ins[0] == "sm":
		bin = "0111" + '{0:03b}'.format(int(ins[1][1])) + "000000000"

	elif ins[0] == "beq":
		imm = int(ins[3])
		b = Bits(int = imm, length=6)
		bin = "1100" + '{0:03b}'.format(int(ins[1][1])) + '{0:03b}'.format(int(ins[2][1])) + b.bin

	elif ins[0] == "jalr":
		if ins[2][0] == 'r':
			bin = "1001" + '{0:03b}'.format(int(ins[1][1])) + '{0:03b}'.format(int(ins[2][1])) + "000000"
		else:
			imm = int(ins[2])
			b = Bits(int = imm, length=9)
			bin = "1000" + '{0:03b}'.format(int(ins[1][1])) + b.bin

	else:
		sys.exit("Instruction is invalid")

	g.write(bin + "\n")
