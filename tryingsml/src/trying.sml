fun len(xs) =
	case xs of
		[] => 0
	 | (_::xs') => 1 + len(xs')
fun maximum(xs)=
	 	case xs of
	 	[] => NONE
	 	| (head::[]) => SOME head
	 	| (head::neck::rest) =>	if head > neck
	 				then maximum (head::rest)
	 				else maximum (neck::rest)
fun sum (x::y::xs) = x :: sum (x+y::xs)
  | sum xs = xs

(*An interesting way to leave comments*)
val x = [4, 7, 12, 18, 22];
