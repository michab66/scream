
;      -*- Mode: Lisp -*-                            Filename:  pdefstr.s

;                     Last Revision:  30-Aug-85 1900ct

;--------------------------------------------------------------------------;
;                                                                          ;
;                         TI SCHEME -- PCS Compiler                        ;
;                  Copyright 1985 (c) Texas Instruments                    ;
;                                                                          ;
;                           Amitabh  Srivastava                            ;
;                                                                          ;
;                  DEFINE-STRUCTURE and Related Routines                   ;
;                                                                          ;
;--------------------------------------------------------------------------;

;;;
;;; - syntax is similar to DEFSTRUCT in Common Lisp
;;;
;;; Syntax : (DEFINE-STRUCTURE name slot1 slot2 ...)
;;;
;;; slots may be given default values by (slot1 init-val)
;;;
;;; e.g (DEFINE-STRUCTURE SHIP (X-VEL 0) Y-VEL)
;;;
;;; objects of this structure can be generated by using
;;; MAKE-SHIP -
;;;
;;; (MAKE-SHIP 'X-VEL 10)
;;;
;;; the predicate SHIP? can be used to check if an object is an
;;; instance of ship.
;;;
;;; (SHIP-X-VEL object) can be used to get the `x-vel' of the object,
;;; which is an instance of `ship'
;;;
;;; (SET! (SHIP-X-VEL object) 11) can be used to set the `x-vel' of the
;;;  object.
;;;
;;; single-inheritance : structures can inherit from other objects by
;;; using the INCLUDE option (similar to Common Lisp DEFSTRUCT)
;;;
;;; e.g. (DEFINE-STRUCTURE (SHIP (INCLUDE FLOATING-OBJECT)) slot ...)
;;;



;;;                         Implementation Note


;;; The Common Lisp definition requires that the slot initialization
;;; expressions be re-evaluated each time a MAKE-name operation is
;;; performed.  For consistency with the spirit of Scheme, these
;;; expressions should be evaluated in the lexical environment surrounding
;;; the DEFINE-STRUCTURE itself.  Thus, DEFINE-STRUCTURE must expand into
;;; at least one LAMBDA that `freezes' the initialization expressions.
;;; This is why %DEFINE-STRUCTURE expands into a BEGIN with an embedded
;;; closure for MAKE-name.  (This is important only if an initialization
;;; expression involves lexical references.)



;;; Global function used to generate predicates for all structures


(define %structure-predicate                            ; %STRUCTURE-PREDICATE
  (lambda (object tag)
    (and (vector? object)
         (positive? (vector-length object))
         (member tag (vector-ref object 0))
         #!true)))


;;; %MAKE-STRUCTURE is used by all structures to create an instance


(define %make-structure                                 ; %MAKE-STRUCTURE
  (lambda (name constructor-name structure init-list)
    (letrec ((slot-number
              (lambda (slot slot-values)
                (apply-if (assq slot slot-values)
                    cadr
                    (error (string-append
                               "Structure component unknown to "
                               (symbol->string constructor-name))
                           slot)))))
      (let ((slots (getprop name '%SLOT-VALUES)))
        (do ((structure structure)
             (init-msg init-list (cddr init-msg)))
            ((null? init-msg) structure)
          (vector-set! structure
                       (slot-number (car init-msg) slots)
                       (cadr init-msg)))))))


;;; %DEFINE-STRUCTURE defines a structure with specified attributes.  This
;;; is the procedure that expands the macro DEFINE-STRUCTURE.


(define %define-structure                               ; %DEFINE-STRUCTURE
  (lambda (e)
    (letrec
     ((make-symbol                                      ; MAKE-SYMBOL
       (lambda args
         (string->symbol (apply string-append args))))

      (generate-slots-loop                              ; GENERATE-SLOTS-LOOP
       (lambda (tail slots n)
         (if (null? slots)
             tail                                       ;;; 2/14/86
             (generate-slots-loop
                 (cons (if (atom? (car slots))
                           (cons (car slots) (cons n '()))
                           (cons (caar slots) (cons n (cadar slots))))
                       tail)
                 (cdr slots)
                 (1+ n)))))

      (generate-slots                                   ; GENERATE-SLOTS
       (lambda (include-struct slots)
         (if include-struct
             (let ((include-slots (getprop include-struct '%SLOT-VALUES)))
               (generate-slots-loop include-slots
                                    slots
                                    (1+ (length include-slots))))
             (generate-slots-loop '() slots 1))))

      (init-slots                                       ; INIT-SLOTS
       (lambda (slots)
         (let loop ((tail '())
                    (slots slots))
           (if (null? slots)
               tail
               (loop (if (member (cddar slots) '(() '()))
                         tail
                         (cons `(vector-set! %DS0001% ,(cadar slots)
                                             ,(cddar slots))
                               tail))
                     (cdr slots))))))

      (access-macros-loop                               ; ACCESS-MACROS-LOOP
       (lambda (name-string slots tail)
         (if (null? slots)
             (reverse! tail)
             (access-macros-loop
                 name-string
                 (cdr slots)
                 (let ((name (make-symbol name-string "-"
                                          (symbol->string (caar slots))))
                       (index (cadar slots)))
                   (cons `(define-integrable ,name
                            (lambda (obj) (vector-ref obj ,index)))
                         tail))))))

      (gen-access-macros                                ; GEN-ACCESS-MACROS
       (lambda (name-string slot-names-pos)
         (access-macros-loop name-string slot-names-pos '())))

      (gen-make-proc                                    ; GEN-MAKE-PROC
       (lambda (name constructor-name slot-names-pos)
         `(define ,constructor-name
            (lambda %DS0002%
              (let ((%DS0001% (make-vector ,(1+ (length slot-names-pos))
                                           '())))
                (vector-set! %DS0001% 0 (getprop ',name '%TAG))
                ,@(init-slots slot-names-pos)
                (if (null? %DS0002%)
                    %DS0001%
                    (%make-structure ',name   ',constructor-name
                                     %DS0001%   %DS0002%)))))))
      )
     (begin
       (pcs-chk-length>= e e 2)
       (let* ((name-options (cadr e))
              (name (let ((n (if (atom? name-options)
                                 name-options
                                 (car name-options))))
                      (pcs-chk-id e n)
                      n))
              (name-string (symbol->string name))
              (constructor-name (make-symbol "MAKE-" name-string))
              (predicate-name (make-symbol name-string "?"))
              (include-struct
                    (cond ((atom? name-options)
                           '())
                          ((and (pair? (cdr name-options))
                                (pair? (cadr name-options))
                                (eq? (car (cadr name-options)) 'INCLUDE)
                                (pair? (cdr (cadr name-options))))
                           (let ((is (cadr (cadr name-options))))
                             (pcs-chk-id e is)
                             is))
                          (else
                           (syntax-error "Invalid option list" e))))
              (slots (cddr e))
              (slot-names-pos (generate-slots include-struct slots))
              (tag (cons '#!STRUCTURE name))
              (complex-tag (if include-struct
                               (cons tag (getprop include-struct '%TAG))
                               (list tag))))
         `(begin
            (putprop ',name ',complex-tag '%TAG)
            (putprop ',name ',slot-names-pos '%SLOT-VALUES)
            ,@(gen-access-macros name-string slot-names-pos)
            (define ,predicate-name
              (lambda (obj)
                (%structure-predicate obj ',tag)))
            ,(gen-make-proc name constructor-name slot-names-pos)
            ',name))))))
