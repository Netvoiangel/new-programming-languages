(defpackage :mt-demo
  (:use :cl))
(in-package :mt-demo)

;; Пример рассчитан на SBCL (sb-thread).
;; Идея: запускаем несколько потоков и ждём их завершения.

(defun worker (id)
  (dotimes (i 5)
    (format t "worker ~a step ~a~%" id (1+ i))
    (sleep 0.1)))

(defun main ()
  (let* ((n 4)
         (threads
           (loop for id from 1 to n
                 collect (sb-thread:make-thread (lambda () (worker id))
                                                :name (format nil "worker-~a" id)))))
    (dolist (th threads)
      (sb-thread:join-thread th))
    (format t "all done~%")))

(main)


