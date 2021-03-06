; $Id: math.s 8 2008-09-14 14:23:20Z binzm $
;
; Scream / Math runtime
;
; Comments contain text from R5RS
; Released under Gnu Public License
; Copyright (c) 1998-2004 Michael G. Binz

;;
;; Keep your environment tidy!
;;
(define %class-Math (make-object java.lang.Math))
(define (%to-float x) (+ 0.0 x))



;;
;; (number? obj) procedure; r5rs 30
;;
(define number?
  (typePredicateGenerator "de.michab.scream.Number" #f))



;;
;; (real? obj) procedure; r5rs 21
;;
;; This is not in compliance with R5RS since an integer is also a real.  To get
;; compliant real? had to be equal to number?.  To be cool we would then need
;; automatic numeric type promotion that we don't have currently.
;;
(define real?
  (typePredicateGenerator "de.michab.scream.SchemeDouble" #t))



;;
;; (integer? obj) procedure; r5rs 21
;;
(define integer?
  (typePredicateGenerator "de.michab.scream.SchemeInteger" #t))



;;
;; (even? x)
;;
(define (even? x)
  ; Return whether twice the half of x is x.  This works because of integer
  ; division.
  (eqv? x (* 2 (/ x 2))))



;;
;; (odd? x)
;;
(define (odd? x)
  ; Well, if we aren't even, we seem to be a little odd.
  (not (even? x)))



;;
;; (max n1 ...)
;;
(define (max n . rest)
  (if (null? rest)
    n
    (let ((c (car rest)))
      (apply max (if (> n c) n c) (cdr rest)))))



;;
;; (min n1 ...)
;;
(define (min n . rest)
  (if (null? rest)
    n
    (let ((c (car rest)))
      (apply min (if (< n c) n c) (cdr rest)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Preallocate the TLE slots that will be filled in the closure below.
(define = ())
(define < ())
(define > ())
(define <= ())
(define >= ())



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open a special closure holding the precomputed Number class reference for
;; better efficiency.
(let ((numberClass (make-object de.michab.scream.Number)))

;;
;; (= n1 .. nn)
;;
(set! = (lambda args
  (if (not (null? args))
      (numberClass (compare (list->vector args) (numberClass EQ)))
      #f)))

;;
;; (< n1 .. nn)
;;
(set! < (lambda args
  (if (not (null? args))
      (numberClass (compare (list->vector args) (numberClass LT)))
      #f)))

;;
;; (<= n1 .. nn)
;;
(set! <= (lambda args
  (if (not (null? args))
      (numberClass (compare (list->vector args) (numberClass LET)))
      #f)))

;;
;; (> n1 .. nn)
;;
(set! > (lambda args
  (if (not (null? args))
      (numberClass (compare (list->vector args) (numberClass GT)))
      #f)))

;;
;; (>= n1 .. nn)
;;
(set! >= (lambda args
  (if (not (null? args))
      (numberClass (compare (list->vector args) (numberClass GET)))
      #f)))

;; Finish number class closure.
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;
;; exact?
;;
(define (exact? x)
  (if (number? x)
      ((object x) (isExact))
      (error "TYPE_ERROR"
             %type-number
             ((object x) (getTypename)))))



;;
;; inexact?
;;
(define (inexact? x)
  (not (exact? x)))



;;
;; zero?
;;
(define (zero? x)
  (if (number? x)
      (equal? 0 x)
      (error "TYPE_ERROR" %type-number (%typename x))))



;;
;; positive? - library procedure - r5rs p. 22
;;
(define (positive? x) (> x 0))

;;
;; negative? - library procedure - r5rs p. 22
;;
(define (negative? x) (< x 0))

;;
;; Set up dummy bindings in the global TLE.  The actual method definitions
;; will be done in the following let expression.
;;
(define abs ())

(define exp ())
(define log ())
(define sin ())
(define cos ())
(define tan ())
(define asin ())
(define acos ())
(define atan ())

(define floor ())
(define ceiling ())

(define round ())
(define sqrt ())
(define expt ())

;;
;; Open a special scope to keep the java.lang.Math instance in the local
;; closures.  Replace the TLE bindings with the function implementations in the
;; let expression.
;;
(let ((math (make-object java.lang.Math))
      (to-float (lambda (x) (+ 0.0 x)))
     )
  ;;
  ;; abs - library procedure - r5rs p. 22
  ;;
  (set! abs (lambda (x) (math (abs x))))

  ;;
  ;; exp - procedure - r5rs p. 23
  ;;
  (set! exp (lambda (x) (math (exp x))))

  ;;
  ;; log - procedure - r5rs p. 23
  ;;
  (set! log (lambda (x) (math (log x))))

  ;;
  ;; sin - procedure - r5rs p. 23
  ;;
  (set! sin (lambda (x) (math (sin x))))

  ;;
  ;; cos - procedure - r5rs p. 23
  ;;
  (set! cos (lambda (x) (math (cos x))))

  ;;
  ;; tan - procedure - r5rs p. 23
  ;;
  (set! tan (lambda (x) (math (tan x))))

  ;;
  ;; asin - procedure - r5rs p. 23
  ;;
  (set! asin (lambda (x) (math (asin x))))

  ;;
  ;; acos - procedure - r5rs p. 23
  ;;
  (set! acos (lambda (x) (math (acos x))))

  ;;
  ;; atan - procedure - r5rs p. 23
  ;;
  (set! atan
    (lambda x
      (if (= 1 (length x))
        (math (atan (car x)))
        (math (atan2 (car x) (cadr x))))))

  ;;
  ;; round - procedure - r5rs p. 23
  ;;
  (set! round
    (lambda (x) 
      (math (round x))))

  ;;
  ;; floor - procedure - r5rs p. 23
  ;;
  (set! floor 
    (lambda (x) 
      (round (math (floor x)))))

  ;;
  ;; ceiling - procedure - r5rs p. 23
  ;;
  (set! ceiling 
  	(lambda (x) 
  	  (round (math (ceil x)))))

  ;;
  ;; sqrt - procedure - r5rs p. 24
  ;;
  (set! sqrt (lambda (x) (math (sqrt x))))

  ;;
  ;; expt - procedure - r5rs p. 24
  ;;
  (set! expt (lambda (x y) (math (pow (to-float x) (to-float y)))))
)



;;
;; truncate - procedure - r5rs p. 23
;;
(define (truncate x)
  (if (positive? x)
    (floor x)
    (ceiling x)))



;;
;; remainder - procedure - r5rs p. 22
;;
(define (remainder x y)
  ; Well that guy behaves magically.  Maps to the range of smallest abs
  ; values. Uh.
  (let ((result (round (%class-Math (IEEEremainder (%to-float x)
                                                   (%to-float y))))))
    (cond ((and (positive? x) (negative? result))
           (+ result (abs y)))
          ((and (negative? x) (positive? result))
           (- result (abs y)))
          (else
           result))))



;;
;; (modulo n1 n2)
;;
(define (modulo x y)
  ; Well that guy behaves magically.  Maps to the range of smallest abs
  ; values. Uh.
  (let ((result (round (%class-Math (IEEEremainder (%to-float x)
                                                   (%to-float y))))))
    (cond ((and (positive? y) (negative? result))
           (+ result (abs y)))
          ((and (negative? y) (positive? result))
           (- result (abs y)))
          (else
           result))))



;;
;; (gcd a b)
;;
(define (gcd . rest)
  (letrec ((positive-gcd
             (lambda (a b)
               (cond ((= a b)
                      a)
                     ((> a b)
                      (positive-gcd (- a b) b))
                     (else
                      (positive-gcd a (- b a)))))))

          (if (null? rest)
            0
            ; Take the argument list, run the abs procedure on each element and
            ; feed that into the locally defined procedure implementation.
            (apply positive-gcd (map abs rest)))))



;;
;;  static long lcm(Object args) {
;;    long L = 1, g = 1;
;;    while (isPair(args)) {
;;      long n = Math.abs((long)toInt(first(args)));
;;      g = gcd(n, L);
;;      L = (g == 0) ? g : (n / g) * L;
;;     args = toList(rest(args));
;;    }
;;    return L;
;;  }
(define (lcm . args)
  ;; TODO it must be possible to implement this simpler.
  (do ((k 1)
       (g 1)
       (n 0))
      ((null? args) k)
      (set! n (abs (car args)))
      (set! g (gcd n k))
      (set! k (if (= g 0)
                  g
                  (* k (/ n g))))
      (set! args (cdr args))))



;;
;; (quotient n1 n2) -- Integer division.
;;
(define (quotient n1 n2)
  (/ n1 n2))


; string->number supports a radix argument up to the number of entries
; in this vector.
(define %character-table
  #( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\A #\B #\C #\D #\E #\F #\G))

(define (%number->string number char-list radix)
  (if (> radix (vector-length %character-table))
  	(error "RADIX_NOT_SUPPORTED" radix (vector-length %character-table)))
  (if (zero? number)
    ; If we received an empty character list...
    (if (null? char-list)
      ; ...we actually return a zero character.
      (cons (vector-ref %character-table 0) char-list)
      ; ...in the other case we return only the character
      ; list that we computed yet.
      char-list)
    (%number->string
      (quotient number radix)
      (cons
         (vector-ref %character-table (modulo number radix))
         char-list)
      radix)))

;;
;; TODO handle floating point
;;
(define (number->string number . opt-radix)
  (let* (
         (radix
           (cond
             ; If no optional radix was defined...
             ((null? opt-radix)
                ; ...we use the human 10 as default.
                10)
             ((= 1 (length opt-radix))
                (car opt-radix))
             (else
               (error "TOO_MANY_ARGUMENTS" 2))))

         (abs-character-list
           (%number->string (abs number) () radix))
       )
       (if (negative? number)
         (set! abs-character-list
         	(cons #\- abs-character-list)))
       (list->string abs-character-list)))
