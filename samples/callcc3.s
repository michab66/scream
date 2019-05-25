;; $Id: callcc2.s 23 2008-09-21 19:20:15Z binzm $
;;
;; Scream / samples
;;
;; call-with-current-continuation test case.
;;
;;
;; Released under Gnu Public License
;; Copyright (c) 2008 Michael G. Binz

(define call/cc call-with-current-continuation)

(define (hefty-computation do-other-stuff)
    (let loop ((n 5))
      (display "Hefty computation: ")
      (display n)
      (newline)
      (set! do-other-stuff (call/cc do-other-stuff))
      (display "Hefty computation (b)")
      (newline)
      (set! do-other-stuff (call/cc do-other-stuff))
      (display "Hefty computation (c)")
      (newline)
      (set! do-other-stuff (call/cc do-other-stuff))
      (if (> n 0)
          (loop (- n 1)))))

;; notionally displays a clock
 (define (superfluous-computation do-other-stuff)
    (let loop ()
      (for-each (lambda (graphic)
                  (display graphic)
                  (newline)
                  (set! do-other-stuff (call/cc do-other-stuff)))
                '("Straight up." "Quarter after." "Half past."  "Quarter til."))
      (loop)))


;; Call with:
;; (hefty-computation superfluous-computation)
