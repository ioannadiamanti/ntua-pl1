fun pistes filename =

let

fun parse file=
    let 
        val inStream = TextIO.openIn file	

        (*function that reads an int*) 
        fun readInt input=
            Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    
        (*function that reads an amount of ints and puts them in acc*) 
        fun readInts 0 acc = acc 
     	      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    

        (*function that reads an amount of pists and puts them in acc*) 
        fun readPistes 0 acc n = rev acc 
              | readPistes i acc n = 
            let
                val pista_number = n-i
                val nr_keys_req = readInt inStream
                val nr_keys_given = readInt inStream
                val stars = readInt inStream
                val keys_req = readInts nr_keys_req []
                val keys_given = readInts nr_keys_given []
                val pista = (pista_number, nr_keys_req, nr_keys_given, stars, keys_req, keys_given)
            in
                readPistes (i - 1) (pista :: acc) n
            end

        

        (*read N*)
        val n = readInt inStream 

        (*create a list of pists*) 
            val pistalist = readPistes (n+1) [] (n+1)

    in
       (n, pistalist)
    end
    
val result = parse filename
val N = #1 result
val list = #2 result

fun pista_number (a,_,_,_,_,_) = a
fun nr_keys_req (_,b,_,_,_,_) = b
fun nr_keys_given (_,_,c,_,_,_) = c
fun stars (_,_,_,d,_,_) = d
fun keys_req (_,_,_,_,e,_) = e
fun keys_given (_,_,_,_,_,f) = f



fun create_initial_state pistalist =
    let
        val current_pist = 0
        val visited_pists = [0]
        val available_keys = keys_given (hd pistalist)
        val total_stars = stars (hd pistalist)
    in
        (current_pist, visited_pists, available_keys, total_stars)
    end

val initial_state = create_initial_state list

fun current_pist (a,_,_,_) = a
fun visited_pists (_,a,_,_) = a
fun available_keys (_,_,a,_) = a
fun total_stars (_,_,_,a) = a



(*function that checks if the element a exists in a list*)
fun exists a []  = false
  | exists a (x::xs) = if (a=x) then true else (exists a xs)



(*function that checks if the element a exists in a list and removes it*)
fun removeifexists a [] res = res
  | removeifexists a (x::xs) res = if (a=x) then (res@xs) else (removeifexists a xs (rev(x::res)))



(*function that checks if the elements of list x exist in the list y and removes them ---> y-x*)
fun removelist [] y = y 
  | removelist (x::xs) y = 
    let
        val temp = removeifexists x y [] 
    in
        removelist xs temp
    end


(*function that checks if the elements of the list y::ys are contained in the list x*)
fun contains x [] = true
  | contains x (y::ys) = if ((exists y x)=false) then false else 
            let
        		   val temp = removeifexists y x [] 
                    in
               (contains temp ys)
            end


fun next_state state pista =
    let
        val new_pista_number = pista_number pista
        val new_keys_req = keys_req pista
        val new_keys_given = keys_given pista
        val new_stars = stars pista
        val visited_pists = visited_pists state
        val available_keys = available_keys state
        val stars = total_stars state

    in
        if (((exists new_pista_number visited_pists) = false) andalso ((contains available_keys new_keys_req)=true)) 
            then 
                 let
                val new_available_keys = removelist new_keys_req available_keys@new_keys_given
                 in
                (true,(new_pista_number, rev (new_pista_number::visited_pists), new_available_keys, stars+new_stars))
                 end
        else (false,state)
    end

fun status (a,_) = a
fun nextstate (_,a) = a

fun list_of_next_states state [] res = res
  | list_of_next_states state pistalist res = 
    let
        val newstatestatus = next_state state (hd pistalist)
        val status = status newstatestatus
        val newstate = nextstate newstatestatus
    in
        if (status=true) then (list_of_next_states state (tl pistalist) (newstate::res))
        else (list_of_next_states state (tl pistalist) res)
    end
    

val q = Queue.mkQueue():((int*int list*int list*int)Queue.queue)

val enq = Queue.enqueue (q,initial_state)

fun enqueuelist queue [] = queue
  | enqueuelist queue (x::xs) = 
    let
        val temp = Queue.enqueue (queue,x)
    in
        enqueuelist queue xs
    end	

fun play queue pistalist res = 
    if (Queue.isEmpty queue) 
        then res
    else
        let
        val astate = Queue.dequeue queue
        val newstatelist = list_of_next_states astate pistalist []
        val qq = enqueuelist queue newstatelist
        val newstars = total_stars astate
        in
        if (newstars>res) then (play queue pistalist newstars) else (play queue pistalist res)
        end


val maxstars = play q list 0

in

print (Int.toString(maxstars)^"\n")

end
