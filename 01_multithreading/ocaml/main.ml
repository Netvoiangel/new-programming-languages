let () =
  let n = 4 in
  let mutex = Mutex.create () in
  let print s =
    Mutex.lock mutex;
    print_endline s;
    Mutex.unlock mutex
  in
  let worker i () =
    for step = 1 to 5 do
      print (Printf.sprintf "worker %d step %d" i step);
      Thread.delay 0.1
    done
  in
  let threads =
    List.init n (fun idx -> Thread.create (worker (idx + 1)) ())
  in
  List.iter Thread.join threads;
  print_endline "all done"


