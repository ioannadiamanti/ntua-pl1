import java.nio.file.Files;
import java.util.*;
import java.io.*;

public class Doomsday2{

    public static class State{
        public	boolean doomsday=false,change=true;
    };
    public static class myelements{
        char mysymbol;
        boolean expanded;
        public myelements(char a,boolean flag){
            mysymbol =a;
            expanded = flag;
        }
    };
    public static class Element {
        
        private	int x,y;
        private	char symbol;
        //public myelements worldmap[][];
            public Element (int a, int b, char c /*,myelements d[][]*/) {
                x=a;
                y=b;
                symbol=c;
                /*worldmap=d;*/}
            public void expand (State a,myelements[][] worldmap) throws NullPointerException{
                
                char temp ;				
                if (symbol == '+') temp = '-';
                else temp = '+';

                if(worldmap[x-1][y].mysymbol == temp){
                    worldmap[x-1][y].mysymbol='*';
                    a.doomsday=true;}
                else if(worldmap[x-1][y].mysymbol=='.'){
                    worldmap[x-1][y].mysymbol=symbol;
                    a.change=true;}

                if(worldmap[x+1][y].mysymbol== temp){
                    worldmap[x+1][y].mysymbol='*';					
                    a.doomsday=true;}
                else if(worldmap[x+1][y].mysymbol=='.'){
                    worldmap[x+1][y].mysymbol=symbol;
                    a.change=true;}

                if (worldmap[x][y-1].mysymbol== temp){
                    worldmap[x][y-1].mysymbol='*';
                    a.doomsday=true;}
                else if(worldmap[x][y-1].mysymbol=='.'){
                    worldmap[x][y-1].mysymbol=symbol;
                    a.change=true;}

                if (worldmap[x][y+1].mysymbol==temp){
                    worldmap[x][y+1].mysymbol='*';
                    a.doomsday=true;}
                else if(worldmap[x][y+1].mysymbol=='.'){
                    worldmap[x][y+1].mysymbol=symbol;
                    a.change=true;}

            }
    };

    public static class map {
        public	myelements worldmap [][];
        private	int columns, rows;
        public map (myelements input[][], int a, int b) {
                worldmap=input;
                rows=a;
                columns=b;}
        public Queue<Element> maptoqueue (Queue<Element> q) {
            
            for (int i=1; i<rows-1; i++){
                for (int j=1; j<columns-1; j++){
        if (((worldmap[i][j]).mysymbol =='+' || (worldmap[i][j]).mysymbol =='-') && ((worldmap[i][j]).expanded == false)){ 
                    q.add(new Element(i,j,worldmap[i][j].mysymbol/*,worldmap*/));}
                }
            }
            //System.out.println(q.size());
            return q;
            }
        
        public void nextday (State state) throws NullPointerException{
            int count=0;
            Queue<Element> q = new LinkedList<Element>();
            while (state.change==true && state.doomsday==false) {
            Queue<Element> myqueue = maptoqueue (q);
            state.change=false;
                while(!myqueue.isEmpty()) {
                    Element temp = myqueue.remove();
                    temp.expand(state,worldmap);
                    (worldmap[temp.x][temp.y]).expanded = true;
                }
                count++;
            }
            if (state.doomsday==true) {
                System.out.println(count);
                for (int i =1;i<rows-1;i++){
                    for (int j=1;j<columns-1;j++){
                        System.out.print(worldmap[i][j].mysymbol);		
                    }
                    System.out.println();
                }
            }
            else if (state.change==false) {
                    System.out.println("the world is saved");
                for (int i =1;i<rows-1;i++){
                    for (int j=1;j<columns-1;j++){
                        System.out.print(worldmap[i][j].mysymbol);		
                    }
                    System.out.println();
                }
            }
        }
    };			

    public static void main(String[] args) throws FileNotFoundException{
        if(args.length < 1) {
                System.out.println("Error, usage: java ClassName filename.txt");
            System.exit(1);
        }
        String theString = "";

    
        Scanner scanner = new Scanner(new File(args[0]));

        theString = 'x'+ scanner.nextLine()+'x';
        int rows=1;
        int columns=0;
        
        while (scanner.hasNextLine()) {
            rows++;       			
            theString = theString + 'x'+scanner.nextLine()+'x';
                    
        }
        
        columns = theString.length();
        columns = columns/rows;
        rows=rows+2;
        /*System.out.println(rows);*/
        /*System.out.println(columns);*/
        
        char[] charArray = theString.toCharArray();
        theString = "";
        myelements [][] world = new myelements[rows][columns];
        int k=0;
        for (int i =1;i<rows-1;i++){
            for (int j=0;j<columns;j++){
                world[i][j] = new myelements(charArray[k],false);
                k++;		
            }
        }
        charArray = null;
        for (int j =0; j<columns;j++){
            world[0][j] = new myelements('x',false);
        }
        
        for (int j =0; j<columns;j++){
            world[rows-1][j] = new myelements('x',false);
        }
        
                
        /*for (int i =0;i<rows;i++){
            for (int j=0;j<columns;j++){
                System.out.print(world[i][j]);		
            }
            System.out.println();
        }*/
        
        State Worldstate = new State();
        map Mymap = new map (world, rows, columns);
        Mymap.nextday(Worldstate);		
    }
    
}
