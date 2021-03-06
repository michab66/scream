; $Id: basic.s 8 2008-09-14 14:23:20Z binzm $
;
; Scream / Common extensions
;
; Released under Gnu Public License
; Copyright (c) 1998-2000 Michael G. Binz



;;
;; Define a symbol holding the current jdk-version.
;;
(define %jdk-version
  ((make-object java.lang.System) (getProperty "java.version")))
  
  
  
;;
;; Displays a debug message without carriage return.
;;
(define (%print message)
  ((object ((make-object de.michab.scream.SchemeInterpreter) (getErrorPort)))
   (display message)))



;;
;; (proc-2 a b) -> (proc-n a b ...)
;; (proc-2 (proc-2 a b) c)
;;
(define (%mk-transitive proc2)
  (letrec
    ((transitiver
       (lambda (a b . rest)
         (if (null? rest)
           (proc2 a b)
           (apply transitiver (proc2 a b) rest)))))
    transitiver))



;;
;; Displays a debug message with carriage return.
;;
(define (%println message)
  (%print message)
  (%print #\newline))



;;
;; Exits the interpreter.  Note that this implementation is *very* straight-
;; forward: On calling (exit) the system will be shut down by System.exit(0)
;; which is definitely no good strategy in case a fancy user interface is
;; installed in front of Scream, so in this case this implementation has to be
;; overridden.
;;
(define (exit)
  ((make-object java.lang.System) (exit 0)))



;;
;;
;; @proc typePredicateGenerator
;;
;; Is used for generating most of the type predicate procedures like vector?,
;; char?, etc. in the system.
;;
;; @arg string-type-name : string
;;   The java type name that has to be tested against.
;;
;; @arg exact-match : boolean
;;   if #T the generated predicate checks for an
;;   exact type match.  If #F it is allowed that
;;   the object passed to the resulting predicate
;;   is assignable to an element of the type
;;   passed to this procedure.
;;
;; @returns A procedure that has the standard type predicate signature,
;; accepting any single argument and returning a boolean.
;;
(define (typePredicateGenerator string-type-name exact-match)
  (let ((classObject ((make-object java.lang.Class) (forName string-type-name))))
    (lambda (obj)
      (cond
        ;; If this is NIL false is returned.
        ((null? obj) #f)
        ;; Exact match test.
        (exact-match
          (classObject (equals ((object obj) (getClass)))))
        ;; Assignable match test.
        (else
          (classObject (isAssignableFrom ((object obj) (getClass)))))))))



;;
;; (transitiveBoolean proc)
;;
;; Accepts a procedure (proc arg1 arg2) that evaluates to a boolean.  Returns
;; a procedure that implements (proc arg1 arg2 ...).  The passed procedure
;; has to be transitive.
;;
(define (transitiveBoolean proc)
  (lambda (first second . rest)

    (do ((args
           ; Init - we just create a homogenous list of our arguments.  We have our
           ; arguments defined as they are to get automatic parameter checking for
           ; the at least required two params.
           (append (list first second) rest)
           ; Step - just remove the first entry from the arg list.
           (cdr args))
         ; Our break flag.
         (result #T))

        ; The test expression.
        ((or
            ; Either the remaining list length is less than two...
            (< (length args) 2)
            ; ..or the last evaluation of our procedure was false.
            (not result))
         ; We return our result.
         result)

        ; For each loop iteration we call our passed procedure with the first
        ; two entries of the remaining argument list.
        (set! result (proc (car args) (cadr args))))))


;;
;;
;;
(define (%typename x)
  (%fco-class (getTypename x)))



;;
;; A reference to the FirstClassObject's class.  This has to be used for
;; access to the static methods in the runtime implementations.
;;
(define %fco-class (make-object de.michab.scream.FirstClassObject))



;;
;; Regression test support.
;;
(%syntax (%positive-test src-fil number expression expected-result)
  (if (not (equal? (evaluate expression) expected-result))
    (error "TEST_FAILED" (evaluate src-fil) (evaluate number))))

(%syntax (%negative-test src-fil number expression expected-error)
  (if (not (equal? (%error-catch (evaluate expression)) expected-error))
    (error "TEST_FAILED" (evaluate src-fil) (evaluate number))))

;;
;;
;;
(define %type-symbol
  ((make-object de.michab.scream.Symbol) TYPE_NAME))
(define %type-cons
  ((make-object de.michab.scream.Cons) TYPE_NAME))
(define %type-vector
  ((make-object de.michab.scream.Vector) TYPE_NAME))
(define %type-string
  ((make-object de.michab.scream.SchemeString) TYPE_NAME))
(define %type-char
  ((make-object de.michab.scream.SchemeCharacter) TYPE_NAME))
(define %type-number
  ((make-object de.michab.scream.Number) TYPE_NAME))
(define %type-integer
  ((make-object de.michab.scream.SchemeInteger) TYPE_NAME))
(define %type-real
  ((make-object de.michab.scream.SchemeDouble) TYPE_NAME))
(define %type-bool
  ((make-object de.michab.scream.SchemeBoolean) TYPE_NAME))
(define %type-port
  ((make-object de.michab.scream.Port) TYPE_NAME))

