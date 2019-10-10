import java.nio.file.Files;
import java.util.*;
import java.io.*;

public class Pistes{
    public static class Pista {
        int nr_keys_required;
        int nr_keys_given;
        int stars;
        List <Integer> which_keys_required = new ArrayList<Integer>();
        List<Integer> which_keys_given = new ArrayList<Integer>();
        public Pista (int a ,int b, int c){
            nr_keys_required=a;
            nr_keys_given = b;
            stars = c;
        }
    };

    public static class State {
        int current_pist;
        List<Integer> visited_pists = new ArrayList<Integer>();
        List<Integer> available_keys  = new ArrayList<Integer>();
        int total_stars,N;
        public State (int n,int p, List<Integer> l, List<Integer> k, int s) {
            current_pist=p;
            visited_pists=l;
            available_keys=k;
            total_stars=s;
            N=n;
        }
        public void myremove(List<Integer> a, List<Integer>b){
            int i=0;			
            while(b.size()>0){
                if((b.get(0)).equals(a.get(i))){
                    a.remove(i);
                    b.remove(0);
                    i=0;
                }
                else i++;
            }
        }
                
        public boolean mycontainsall(List<Integer> a ,List<Integer> b , int c){
            int i =0;
            int sum = 0;
            while(b.size()>0 && i < a.size()){
                if((b.get(0)).equals(a.get(i))){
                    sum++;
                    b.remove(0);
                    a.remove(i);
                    i=0;	
                }
                else i++;				
            }
            if (sum == c) return true; else return false;
        } 


        public List<State> next(List<Pista> mylist) {
            List<State> result= new ArrayList<State> ();
            for (int i=1; i<N+1; i++) {

                    List <Integer> my_available_keys = new ArrayList<Integer>();
                    my_available_keys.addAll(available_keys);

                    List <Integer> new_keys_required= new ArrayList<Integer>();
                    new_keys_required.addAll((mylist.get(i)).which_keys_required);
                    int num_of_keys = (mylist.get(i)).nr_keys_required;

                if (!visited_pists.contains(i) && mycontainsall(my_available_keys,new_keys_required,num_of_keys)) {
                    
                    int n_currentpist=i;
                    List <Integer> n_visitedpists= new ArrayList<Integer>();
                    n_visitedpists.addAll(visited_pists);
                    n_visitedpists.add(i);
                		List<Integer> n_availablekeys= new ArrayList<Integer>();
                    n_availablekeys.addAll(available_keys);
                    List <Integer> n_keys_required= new ArrayList<Integer>();				
                    n_keys_required.addAll((mylist.get(i)).which_keys_required);
                    
                    myremove(n_availablekeys,n_keys_required);
                    n_availablekeys.addAll((mylist.get(i)).which_keys_given);
                    int n_totalstars=total_stars + (mylist.get(i)).stars;
                    State new_state = new State(N,n_currentpist, n_visitedpists, n_availablekeys,n_totalstars);
                    result.add(new_state);
                }
            }
            
            return result;
        }
    };		
            
        
    public static class Player{
        int max_stars,N;
        List<Pista> plist= new ArrayList<Pista>();
        Pista first_pista;
        Queue<State> Q = new LinkedList<State> ();
        public Player (int n,List<Pista> input) {
            N=n;
            max_stars=0;
            plist=input;
             
        }
        public boolean myequal(List<Integer> a,List<Integer> b){
            if (a.size()!=b.size()) return false;
            int temp = a.size();
            int sum = 0;
            int j = 0;
            while(j<b.size()){
                if ((a.get(0)).equals(b.get(j))){
 					sum++;
                    a.remove(0);
                    b.remove(j);
                    j=0;
                                        
                }
                else j++;
            }
            if(sum == temp) return true; else return false;
        }
        public void play() {
            int init_current=0;

            List<Integer> init_visited = new ArrayList<Integer> ();
            init_visited.add(0);

            List<Integer> init_keys = new ArrayList<Integer> ();
            init_keys.addAll((plist.get(0)).which_keys_given); 
            
            int init_stars=(plist.get(0)).stars;
            List<State> seen = new ArrayList<State>();
            State initial = new State (N,init_current,init_visited,init_keys,init_stars);
            Q.add(initial);
            seen.add(initial);
            while(!Q.isEmpty()) {
                State aState = new State(N,0,null,null,0);
                aState = Q.remove();
                if (aState.total_stars>max_stars) max_stars=aState.total_stars;
                List<State> templist = new ArrayList<State>();	
                templist = aState.next(plist);
                
                while (!templist.isEmpty()) {
                    boolean flag = false;
                    State listState = new State(N,0,null,null,0);						
                    listState=templist.get(0);
                    
          				
                    for (int i =0; i <seen.size();i++){
                    
                        List <Integer> seen_visited_pists= new ArrayList<Integer>();
                        seen_visited_pists.addAll((seen.get(i)).visited_pists);
                        List <Integer> seen_available_keys= new ArrayList<Integer>();
                        seen_available_keys.addAll((seen.get(i)).available_keys);
                        List <Integer> my_available_keys= new ArrayList<Integer>();
                        my_available_keys.addAll(listState.available_keys);
                        List <Integer> my_visited_pists= new ArrayList<Integer>();
                        my_visited_pists.addAll(listState.visited_pists);
                    if (myequal(seen_visited_pists,my_visited_pists) && myequal(seen_available_keys,my_available_keys)){
                            flag = true;  break;
                        }
                    }
                    
                    if (!flag){ 
                        Q.add(listState);
                        seen.add(listState);
                        templist.remove(0);
                    }
                    else {
                        templist.remove(0);
                    }
                                
                }			
            }	
    
        }
    };
    

    public static void main(String[] args) throws FileNotFoundException {	
        if(args.length < 1) {
                System.out.println("Error, usage: java ClassName filename.txt");
            System.exit(1);
        }
        Scanner scanner = new Scanner(new File(args[0]));
        int N =scanner.nextInt();
        if(N < 1 || N >42 ) {
                System.out.println("Error, usage: Number of pistes must be between 1 and 42");
            System.exit(1);
        }
        int i = 0;
        int k;
        int total_stars=0;
        List<Pista> pistaList = new ArrayList<Pista>();
        while(scanner.hasNextInt()){
            pistaList.add(new Pista(scanner.nextInt(),scanner.nextInt(),scanner.nextInt()));
            
            total_stars = total_stars + (pistaList.get(i)).stars;
            
            if( (pistaList.get(i)).stars <0) {
                	System.out.println("Error, usage: Number of stars aquired from completing a pista can't be negative ");
                System.exit(1);
            }
            
            if( (pistaList.get(i)).nr_keys_required <0 || (pistaList.get(i)).nr_keys_required > 15) {
                	System.out.println("Error, usage: Number of keys required to open a pista must be between 0 and 15 ");
                System.exit(1);
            }
            
            if((pistaList.get(i)).nr_keys_given <0 || (pistaList.get(i)).nr_keys_given > 15) {
                	System.out.println("Error, usage: Number of keys aquired from completing a pista must be between 0 and 15 ");
                System.exit(1);
            }

            for (k = 0; k< (pistaList.get(i)).nr_keys_required; k++){				
                ((pistaList.get(i)).which_keys_required).add(scanner.nextInt());
                
                if (((pistaList.get(i)).which_keys_required).get(k) < 1 || ((pistaList.get(i)).which_keys_required).get(k) > 99999) {
                		System.out.println("Error, usage: Identifier of key must be between 1 and 99999");		
                    System.exit(1);
                }
            }
            
            
            for (k = 0;k< (pistaList.get(i)).nr_keys_given; k++){
                
                ((pistaList.get(i)).which_keys_given).add(scanner.nextInt());
                if (((pistaList.get(i)).which_keys_given).get(k) < 1 || ((pistaList.get(i)).which_keys_given).get(k) > 99999) {
                		System.out.println("Error, usage: Identifier of key must be between 10 and 99999");		
                    System.exit(1);
                }
            }
            i++;
        }
        if( total_stars > 1000000000) {
                System.out.println("Error, usage: Total number of stars must be between 0 and 1000000000 ");
            System.exit(1);
        }
        if( (pistaList.get(0)).nr_keys_required != 0 ) {
                	System.out.println("Error, usage: Pista no 0 must be played first and therefore require 0 keys to enter ");
                System.exit(1);
        }
        
        Player myplayer = new Player(N,pistaList);
        myplayer.play();
        
        System.out.println(myplayer.max_stars);
        
    }
}
