import os
import sys


directory = sys.argv[1] # './scene21'
if not os.path.isdir(directory):
    print("error in directory")


filelistA = os.listdir(directory)


replacable = '.tiff'

for filename in filelistA:
    new = filename.replace(replacable,'')
    old = os.path.join(os.path.abspath(directory),filename)
    os.rename(old,os.path.join(os.path.abspath(directory),new))