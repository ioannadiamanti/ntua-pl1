fun agora filename =

let

fun parse file=
    let
    fun readInt input=
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

        val inStream = TextIO.openIn file
        
    val n = readInt inStream

    fun readInts 0 acc = acc 
      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	  rev(readInts n [])
    end

val xi = map LargeInt.fromInt (parse filename)

fun gcd (a:LargeInt.int,b:LargeInt.int):LargeInt.int =
    if (a=0) then b
    else if (b=0) then a
    else gcd ((b mod a), a)

fun ekp (a:LargeInt.int,b:LargeInt.int):LargeInt.int =
    let 
    val c = a div (gcd (a, b))
    in
    b*c
    end

fun ekp_list [] res = []
  | ekp_list (x::xs) res =   
    case xs of [] => rev res
         | (tx::txs) => ekp_list xs ((ekp (tx, (hd res)))::res)
 
val myres1 = (hd xi)::[]
val ekp1 = ekp_list xi myres1

val yi = rev xi
val myres2 = (hd yi)::[]
val ekp2 = rev (ekp_list yi myres2)

fun totalekp [] y res = raise Empty
   |totalekp [x] y res = raise Empty
   |totalekp x [] res = raise Empty
   |totalekp x [y] res = raise Empty
   |totalekp (x0::(x1::xs)) (y0::(y1::ys)) res =  
    case xs of [] => rev res
        | (tx::txs) => totalekp (x1::xs) (y1::ys) ((ekp (x0, (hd ys)))::res)

val temp = totalekp ekp1 ekp2 []
val mytotalekp =(hd ekp2)::(hd (tl ekp2))::temp@[hd (rev ekp1)]

fun min (list:LargeInt.int list):LargeInt.int =
    case list of [] => raise Empty
              | (head::[]) => head
          | (head::neck::rest) =>  if head < neck
                        then min (head::rest)
                        else min (neck::rest)

val result = min (mytotalekp)

fun mini (list:LargeInt.int list, m:LargeInt.int) =
    case list of [] => raise Empty
              | [x] => x
          | (x::xs) => if x=m then 0 else (1+mini(xs,m))

val minindex = mini (mytotalekp, result)

in

print (LargeInt.toString(result)^" "^LargeInt.toString(minindex)^"\n")

end

