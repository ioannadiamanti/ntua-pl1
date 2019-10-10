#include <iostream>
#include <fstream>
#include <queue> 

using namespace std;

struct pixel { 
    char symbol;
    int t;
    int pi, pj; 
    };


int main (int argc, char **argv) {
    
    

    ifstream myReadFile;

    myReadFile.open(argv[1]);

    char worldmap[1000][1000], temp;
    int i=1, j=1, N, M;

    if (myReadFile.is_open()) {
        temp = myReadFile.get();
        while (temp!=EOF) {
            j=1;
            while (temp!='\n') {
                worldmap[i][j] = temp;
                temp = myReadFile.get();
                j++;
                M=j;
            }
            temp = myReadFile.get();
            i++;
        }
    }

    M++;
    N=i+1;
    
    /*cout << N << ' ' <<M <<endl;*/
    myReadFile.close();

    
    for (i=0;i<N;i++){
        worldmap[i][0]='x';
    }
    for (i=0;i<N;i++){
        worldmap[i][M-1]='x';
    }
    for (j=0;j<M;j++){
        worldmap[0][j]='x';
    }
    for (j=0;j<M;j++){
        worldmap[N-1][j]='x';
    }
        



    int current_t=0;
    bool doomsday=false, change=true;

    queue<pixel> myqueue;
    
    while((doomsday == false) && (change ==true)){
        for (i=1;i<N-1;i++){
            for (j=1;j<M-1;j++){
                if ((worldmap[i][j]=='+')||(worldmap[i][j]=='-')) {
                    pixel temp;
                    temp.symbol=worldmap[i][j];
                    temp.t=current_t;
                    temp.pi=i;
                    temp.pj=j;
                    myqueue.push(temp);
                }	
            }
        }
        change=false;
        
        while(!myqueue.empty()){
            pixel temp = myqueue.front();
            myqueue.pop();
            if(temp.symbol=='+'){
                if(worldmap[temp.pi-1][temp.pj]=='-'){
                    worldmap[temp.pi-1][temp.pj]='*';
                    doomsday=true;}
                else if(worldmap[temp.pi-1][temp.pj]=='.'){
                    worldmap[temp.pi-1][temp.pj]='+';
                    change=true;}

                if(worldmap[temp.pi+1][temp.pj]=='-'){
                    doomsday=true;
                    worldmap[temp.pi+1][temp.pj]='*';}
                else if(worldmap[temp.pi+1][temp.pj]=='.'){
                    worldmap[temp.pi+1][temp.pj]='+';
                    change=true;}

                if (worldmap[temp.pi][temp.pj-1]=='-'){
                    worldmap[temp.pi][temp.pj-1]='*';
                    doomsday=true;}
                else if(worldmap[temp.pi][temp.pj-1]=='.'){
                    worldmap[temp.pi][temp.pj-1]='+';
                    change=true;}

                if (worldmap[temp.pi][temp.pj+1]=='-'){
                    worldmap[temp.pi][temp.pj+1]='*';
                    doomsday=true;}
                else if(worldmap[temp.pi][temp.pj+1]=='.'){
                    worldmap[temp.pi][temp.pj+1]='+';
                    change=true;}
            }
            else {
                if(worldmap[temp.pi-1][temp.pj]=='+'){
                    worldmap[temp.pi-1][temp.pj]='*';
                    doomsday=true;}
                else if(worldmap[temp.pi-1][temp.pj]=='.'){
                    worldmap[temp.pi-1][temp.pj]='-';
                    change=true;}

                if(worldmap[temp.pi+1][temp.pj]=='+'){
                    doomsday=true;
                    worldmap[temp.pi+1][temp.pj]='*';}
                else if(worldmap[temp.pi+1][temp.pj]=='.'){
                    worldmap[temp.pi+1][temp.pj]='-';
                    change=true;}

                if (worldmap[temp.pi][temp.pj-1]=='+'){
                    worldmap[temp.pi][temp.pj-1]='*';
                    doomsday=true;}
                else if(worldmap[temp.pi][temp.pj-1]=='.'){
                    worldmap[temp.pi][temp.pj-1]='-';
                    change=true;}

                if (worldmap[temp.pi][temp.pj+1]=='+'){
                    worldmap[temp.pi][temp.pj+1]='*';
                    doomsday=true;}
                else if(worldmap[temp.pi][temp.pj+1]=='.'){
                    worldmap[temp.pi][temp.pj+1]='-';
                    change=true;}
            }
            
        }
        /*cout<< '\n';
            for (i=1;i<N-1;i++){
                for (j=1;j<M-1;j++){
                    cout<< worldmap[i][j];
                }
            cout<< '\n';
            }*/
        if ((change == false) && (doomsday == false)){
            cout << "the world is saved";
            cout<< '\n';
            for (i=1;i<N-1;i++){
                for (j=1;j<M-1;j++){
                    cout<< worldmap[i][j];
                }
            cout<< '\n';
            }
            
        }
        current_t++;
        if (doomsday == true){
            cout << current_t;
            cout<< '\n';
            for (i=1;i<N-1;i++){
                for (j=1;j<M-1;j++){
                    cout<< worldmap[i][j];
                }
            cout<< '\n';
            }
        }

    }
    
    
    return 0;
}
