(* SML/NJ: простой TCP echo сервер на 127.0.0.1:4000 (один клиент) *)

structure S = Socket
structure IN = INetSock

val port = 4000

fun recvLine (sock : (IN.inet, S.active S.stream) S.sock) : string =
  let
    fun loop (acc : Word8.word list) =
      let
        val v = S.recvVec (sock, 1)
      in
        if Word8Vector.length v = 0 then
          rev acc
        else
          let
            val w = Word8Vector.sub (v, 0)
          in
            if w = 0w10 (* \n *) then rev acc else loop (w :: acc)
          end
      end
  in
    Byte.bytesToString (Word8Vector.fromList (loop []))
  end

fun sendAll (sock : (IN.inet, S.active S.stream) S.sock, vec : Word8Vector.vector) =
  let
    val len = Word8Vector.length vec
    fun put i =
      if i < len then
        put (i + S.sendVec (sock, Word8VectorSlice.slice (vec, i, NONE)))
      else
        ()
  in
    put 0
  end

fun sendLine (sock, s) =
  sendAll (sock, Byte.stringToBytes (s ^ "\n"))

val listener : (IN.inet, S.passive S.stream) S.sock = IN.TCP.socket ()
val () = S.bind (listener, IN.any port)
val () = S.listen (listener, 1)
val () = print ("server listening on 127.0.0.1:" ^ Int.toString port ^ "\n")

val (conn : (IN.inet, S.active S.stream) S.sock, _) = S.accept listener
val line = recvLine conn
val () = print ("server got: " ^ line ^ "\n")
val () = sendLine (conn, line)
val () = S.close conn
val () = S.close listener
val () = print "server sent echo and exits\n"


