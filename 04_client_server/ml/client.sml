(* SML/NJ: TCP echo клиент к 127.0.0.1:4000 *)

structure S = Socket
structure IN = INetSock

val port = 4000
val msg =
  case CommandLine.arguments () of
      [] => "hello"
    | (x :: _) => x

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

val sock : (IN.inet, S.active S.stream) S.sock = IN.TCP.socket ()
val addr = valOf (NetHostDB.fromString "127.0.0.1")
val () = S.connect (sock, IN.toAddr (addr, port))

val () = sendAll (sock, Byte.stringToBytes (msg ^ "\n"))
val resp = recvLine sock
val () = print ("client got: " ^ resp ^ "\n")
val () = S.close sock


