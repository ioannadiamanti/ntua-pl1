import re
import sys
import numpy as np
import copy

class team:
    def __init__(self,b,a,g,n):
        self.name = n
        self.num_games = g	        
        self.in_favor = a
        self.against = b
        self.played=0
  	
class game:
    def __init__(self,n1,n2,r1,r2):
        self.winnername = n1
        self.name = n1+ '-' +n2
        self.result = r1+'-'+r2
 
fp = open(sys.argv[1],"r")
temp = list()
teams = list()
games=list()
N =int(fp.readline())
for line in fp:
    for word in line.split():	
        temp.append(word)	
    teams.append(team(int(temp.pop()),int(temp.pop()),int(temp.pop()),temp.pop()))

fp.close()
del temp[:]

def calculator (backupwinners,backuplosers,indexlosers,teams,games,k,N,r):
    for i in range(0,len(teams)):
        if(teams[i].num_games == 1 and teams[i].in_favor< teams[i].against and teams[i].played == 0):			
            for j in range(0,len(teams)):
                if (teams[j].num_games > teams[i].num_games and teams[j].in_favor >= teams[i].against and teams[j].against >= teams[i].in_favor and teams[j].played == 0 ):

                    games.append(game(teams[j].name,teams[i].name,str(teams[i].against),str(teams[i].in_favor)))
                    backupwinners.append(copy.copy(teams[j]))
                    teams[j].played = 1
                    teams[j].num_games = teams[j].num_games-1
                    teams[j].in_favor = teams[j].in_favor - teams[i].against
                    teams[j].against = teams[j].against - teams[i].in_favor
                    backuplosers.append(copy.copy(teams[i]))
                    indexlosers.append(i)
                    teams.remove(teams[i])
                    if (len(teams) == k):
                        k = k/2
                        r = r +1
                        for l in range(0,len(teams)):
                            teams[l].played = 0
                   
                    if(k==1):
                        flag=0
                        if(len(teams) == 2):
                            if(teams[0].in_favor == teams[1].against and teams[0].against == teams[1].in_favor):
                                if(teams[0].in_favor > teams[1].in_favor and teams[0].in_favor>0):
                                    flag = 1
                                    games.append(game(teams[0].name,teams[1].name,str(teams[1].against),str(teams[1].in_favor)))
                                elif(teams[0].in_favor < teams[1].in_favor and teams[1].in_favor>0):
                                    flag = 1
                                    games.append(game(teams[1].name,teams[0].name,str(teams[0].against),str(teams[0].in_favor)))
                                if(flag ==1):
                                    for m in range(0,len(games)):
                                        print(games[m].name,end= ' ')
                                        print(games[m].result)
                                    exit()
                                else:
                                    k = k *2
                                    r = r-1
                                    teams.insert(indexlosers.pop(),backuplosers.pop())
                                    for v in range(0,len(teams)):	
                                        if(teams[v].name == backupwinners[len(backupwinners)-1].name):
                                            teams.remove(teams[v])
                                            teams.insert(v,backupwinners.pop())
                                            games.pop()
                                            break;
                            else:
                                k = k *2
                                r=r-1
                                teams.insert(indexlosers.pop(),backuplosers.pop())
                                for v in range(0,len(teams)):	
                                    if(teams[v].name == backupwinners[len(backupwinners)-1].name):
                                        teams.remove(teams[v])
                                        teams.insert(v,backupwinners.pop())
                                        games.pop()
                                        break;								
                    else:			
                        calculator(backupwinners,backuplosers,indexlosers,teams,games,k,N,r)
            teams.insert(indexlosers.pop(),backuplosers.pop())
            for v in range(0,len(teams)):	
                if(teams[v].name == backupwinners[len(backupwinners)-1].name):
                    teams.remove(teams[v])
                    teams.insert(v,backupwinners.pop())
                    games.pop()
                    break;
            index_round = 0
            tempN=N
            for l in range(0,r-1):
                tempN=tempN/2
                index_round = index_round + tempN
            if (r > 1 and len(backuplosers) < index_round-1):
                r=r-1
            if(r==1):
                k=N/2
                for l in range(0,len(teams)):
                    for m in range(0,len(games)):
                        if (teams[l].name == games[m].winnername):
                            teams[l].played = 1
                            break;
            elif (r > 1 and len(backuplosers) < index_round-1):
                index_round=index_round-tempN
                for l in range(0,len(teams)):
                    for m in range(int(index_round),len(games)):
                        if (teams[l].name == games[m].winnername):
                            teams[l].played = 1
                            break;
                k=k*2                
            return;
    teams.insert(indexlosers.pop(),backuplosers.pop())
    for v in range(0,len(teams)):	
        if(teams[v].name == backupwinners[len(backupwinners)-1].name):
            teams.remove(teams[v])
            teams.insert(v,backupwinners.pop())
            games.pop()
            break;
    index_round = 0
    tempN=N
    for l in range(0,r-1):
        tempN=tempN/2
        index_round = index_round + tempN
    if (r>1 and len(backuplosers) < index_round-1):
        r=r-1
    if(r==1):
        k=N/2
        print(r)
        for l in range(0,len(teams)):
            for m in range(0,len(games)):
                if (teams[l].name == games[m].winnername):
                    teams[l].played = 1
                    break;
    if (r>1 and len(backuplosers) < index_round-1):
        index_round=index_round-tempN
        for l in range(0,len(teams)):
            for m in range(int(index_round),len(games)):
                if (teams[l].name == games[m].winnername):
                    teams[l].played = 1
                    break;
        k=k*2
    return;
r=1
k = N/2
backuplosers=[]
backupwinners=[]
indexlosers=[]	
calculator(backupwinners,backuplosers,indexlosers,teams,games,k,N,r)
