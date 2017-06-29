import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('infile', type=str, help='input file')

args = parser.parse_args()

newfile = args.infile

oldfile = newfile.replace('>','\>')
oldfile = oldfile.replace('<','\<')

print oldfile
print newfile

if '>' in args.infile:
    newfile = newfile.replace('>','_gt_')

if '<' in args.infile:
    newfile = newfile.replace('<','_lt_')

if newfile != args.infile:
    os.system('mv ' + oldfile + ' ' + newfile) 
