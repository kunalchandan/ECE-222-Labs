import os

print("Programming...")

os.system('C:\\Software\\Altera\\15.1\\quartus\\bin64\\quartus_cdb --update_mif LogicalStep')
os.system('C:\\Software\\Altera\\15.1\\quartus\\bin64\\quartus_asm LogicalStep')
os.system('C:\\Software\\Altera\\15.1\\quartus\\bin64\\quartus_pgm  --cable="USB-Blaster [USB-0]" -m JTAG -o p;output_files\\LogicalStep.sof')

print("Done")
