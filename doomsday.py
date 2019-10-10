import re
import sys
import numpy as np
import copy

file_name = sys.argv[1]
fp = open(file_name)
content= fp.readlines()
content = [x.strip() for x in content]
fp.close()
worldmap = list(content)
columns = len(worldmap[0])
rows= len(worldmap)


class element:
    def __init__(self,s,i,j):
        self.symbol = s
        self.x = i
        self.y = j

#class wmap:
 #   def __init__(self,s):
  #      self.symbol = s
   #     self.expand = 0


for i in range(0,rows):
    worldmap[i]='x'+worldmap[i]+'x'

#print(worldmap)

columns=columns+2
rows=rows+2

s = ""
for i in range(0,columns):
    s=s+'x'


worldmap.insert(0,s)
worldmap.append(s)

for i in range(0,rows):
    worldmap[i]=list(worldmap[i])

#print(worldmap)

change=1
doomsday=0
day = 0
backup = list()

while((doomsday==0) and (change==1)):
    change = 0
    day = day +1
    for i in range (0,rows-1):
        for j in range (0,columns-1):
            if ( worldmap[i][j] == '+' or worldmap[i][j] == '-'):
                backup.append(element(worldmap[i][j],i,j))
                
    #print(len(backup))	
    while(len(backup) != 0):
        temp = backup.pop()
        if (temp.symbol == '+'):
            op = '-'
        else:
            op = '+'
        if (worldmap[temp.x+1][temp.y] == op):
            worldmap[temp.x+1][temp.y] ='*' 
            doomsday = 1
        elif (worldmap[temp.x+1][temp.y] == '.'):
            worldmap[temp.x+1][temp.y] =temp.symbol
            change = 1
        if (worldmap[temp.x-1][temp.y] == op):
            worldmap[temp.x-1][temp.y] =  '*' 
            doomsday = 1
        elif (worldmap[temp.x-1][temp.y] == '.'):
            worldmap[temp.x-1][temp.y] =  temp.symbol
            change = 1
        if (worldmap[temp.x][temp.y-1] == op):
            worldmap[temp.x][temp.y-1] = '*'
            doomsday = 1
        elif (worldmap[temp.x][temp.y-1] == '.'):
            worldmap[temp.x][temp.y-1] = temp.symbol
            change = 1
        if (worldmap[temp.x][temp.y+1] == op):
            worldmap[temp.x][temp.y+1] ='*'
            doomsday = 1
        elif (worldmap[temp.x][temp.y+1] == '.'):
            worldmap[temp.x][temp.y+1] =temp.symbol
            change = 1
        
    if ((change==0) and (doomsday==0)):
        print("the world is saved")
        for i in range (1,rows-1):
            for j in range (1,columns-1):
                print(worldmap[i][j],end='')
            print('\n',end='')
    
    if (doomsday == 1):
        print(day)
        for i in range (1,rows-1):
            for j in range (1,columns-1):
                print(worldmap[i][j],end='')
            print('\n',end='')
