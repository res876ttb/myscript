#!/usr/bin/env python3

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('cr', help='The cr to cnvert', type=str)
args = parser.parse_args()

class Color:
  def __init__(self):
    self.PINK = '\033[95m'
    self.BLUE = '\033[94m'
    self.CYAN = '\033[96m'
    self.GREEN = '\033[92m'
    self.YELLOW = '\033[93m'
    self.RED = '\033[91m'
    self.BRED = '\033[41m'
    self.ENDC = '\033[0m'
    self.BOLD = '\033[1m'
    self.UNDERLINE = '\033[4m'

  def red(self, string):
    return self.RED + string + self.ENDC

  def bred(self, string):
    return self.BRED + string + self.ENDC

  def green(self, string):
    return self.GREEN + string + self.ENDC

  def pink(self, string):
    return self.PINK + string + self.ENDC

  def cyan(self, string):
    return self.CYAN + string + self.ENDC

  def blue(self, string):
    return self.BLUE + string + self.ENDC

  def yellow(self, string):
    return self.YELLOW + string + self.ENDC

  def bold(self, string):
    return self.BOLD + string + self.ENDC

  def underline(self, string):
    return self.UNDERLINE + string + self.ENDC

clr = Color()

# Remove 0x
cr = args.cr
if '0x' == cr[:2] or '0X' == cr[:2]:
  cr = cr[2:]

# Check if CR valid
cr = cr.lower()
validChar = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
charMap = {'0': 0, '1':1, '2':2, '3':3, '4':4, '5':5, '6':6, '7':7, '8':8, '9':9, 'a':10, 'b':11, 'c':12, 'd':13, 'e':14, 'f':15}
for c in cr:
  if c not in validChar:
    print('Invalid CR', cr)
    exit(1)

# Parsing
result = []
line = []
cr = cr[::-1]
for c in cr:
  v = charMap[c]
  mask = 0x1

  byte = ''
  for i in range(4):
    if v & mask:
      byte = clr.red('1') + byte
      line = ['  1 '] + line
    else:
      byte = '0' + byte
      line = ['  0 '] + line
    mask = mask << 1
  # print(c, byte)

  if len(line) == 16:
    result = [line] + result
    line = []

if len(line) > 0:
  result = [line] + result

# Print result
if len(result) > 1:
  width = 16
else:
  width = len(result[0])

for i, line in enumerate(result):
  i = len(result) - 1 - i
  base = 16 * i

  line1 = ''
  line2 = ''

  print('-' * (width * 5 + 1))
  for j, bit in enumerate(line):
    j = len(line) - 1 - j
    nbit = base + j
    nbit = '%3s ' % nbit

    if bit == '  1 ':
      bit = clr.bred(bit)
      nbit = clr.bred(nbit)

    line1 += '|%s' % nbit
    line2 += '|%4s' % bit
  
  line1 += '|'
  line2 += '|'

  if len(line) < width:
    line1 = '|    ' * (width - len(line)) + line1
    line2 = '|    ' * (width - len(line)) + line2

  print(line1)
  print(line2)
  
print('-' * (width * 5 + 1))

