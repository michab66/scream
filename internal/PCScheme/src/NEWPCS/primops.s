
(DEFINE < (LAMBDA (I J) (< I J)))

(DEFINE <= (LAMBDA (I J) (<= I J)))

(DEFINE <=? (LAMBDA (I J) (<=? I J)))

(DEFINE <> (LAMBDA (I J) (<> I J)))

(DEFINE <>? (LAMBDA (I J) (<>? I J)))

(DEFINE <? (LAMBDA (I J) (<? I J)))

(DEFINE = (LAMBDA (I J) (= I J)))

(DEFINE =? (LAMBDA (I J) (=? I J)))

(DEFINE > (LAMBDA (I J) (> I J)))

(DEFINE >= (LAMBDA (I J) (>= I J)))

(DEFINE >=? (LAMBDA (I J) (>=? I J)))

(DEFINE >? (LAMBDA (I J) (>? I J)))

(DEFINE ABS (LAMBDA (J) (ABS J)))

(DEFINE ASSOC (LAMBDA (I J) (ASSOC I J)))

(DEFINE ASSQ (LAMBDA (I J) (ASSQ I J)))

(DEFINE ASSV (LAMBDA (I J) (ASSV I J)))

(DEFINE ATOM? (LAMBDA (J) (ATOM? J)))

(DEFINE CAAAR (LAMBDA (J) (CAAAR J)))

(DEFINE CAADR (LAMBDA (J) (CAADR J)))

(DEFINE CAAR (LAMBDA (J) (CAAR J)))

(DEFINE CADAR (LAMBDA (J) (CADAR J)))

(DEFINE CADDDR (LAMBDA (J) (CADDDR J)))

(DEFINE CADDR (LAMBDA (J) (CADDR J)))

(DEFINE CADR (LAMBDA (J) (CADR J)))

(DEFINE CAR (LAMBDA (J) (CAR J)))

(DEFINE CDAAR (LAMBDA (J) (CDAAR J)))

(DEFINE CDADR (LAMBDA (J) (CDADR J)))

(DEFINE CDAR (LAMBDA (J) (CDAR J)))

(DEFINE CDDAR (LAMBDA (J) (CDDAR J)))

(DEFINE CDDDR (LAMBDA (J) (CDDDR J)))

(DEFINE CDDR (LAMBDA (J) (CDDR J)))

(DEFINE CDR (LAMBDA (J) (CDR J)))

(DEFINE CEILING (LAMBDA (J) (CEILING J)))

(DEFINE CHAR->INTEGER
  (LAMBDA (J)
    (CHAR->INTEGER J)))

(DEFINE CHAR-CI<? (LAMBDA (I J) (CHAR-CI<? I J)))

(DEFINE CHAR-CI=? (LAMBDA (I J) (CHAR-CI=? I J)))

(DEFINE CHAR-DOWNCASE
  (LAMBDA (J)
    (CHAR-DOWNCASE J)))

(DEFINE CHAR-UPCASE (LAMBDA (J) (CHAR-UPCASE J)))

(DEFINE CHAR<? (LAMBDA (I J) (CHAR<? I J)))

(DEFINE CHAR=? (LAMBDA (I J) (CHAR=? I J)))

(DEFINE CHAR? (LAMBDA (J) (CHAR? J)))

(DEFINE CLOSURE? (LAMBDA (J) (CLOSURE? J)))

(DEFINE COMPLEX? (LAMBDA (J) (COMPLEX? J)))

(DEFINE CONS (LAMBDA (I J) (CONS I J)))

(DEFINE CONTINUATION?
  (LAMBDA (J)
    (CONTINUATION? J)))

(DEFINE ENVIRONMENT-PARENT
  (LAMBDA (J)
    (ENVIRONMENT-PARENT J)))

(DEFINE ENVIRONMENT?
  (LAMBDA (J)
    (ENVIRONMENT? J)))

(DEFINE EQ? (LAMBDA (I J) (EQ? I J)))

(DEFINE EQUAL? (LAMBDA (I J) (EQUAL? I J)))

(DEFINE EQV? (LAMBDA (I J) (EQV? I J)))

(DEFINE EVEN? (LAMBDA (J) (EVEN? J)))

(DEFINE FLOAT (LAMBDA (J) (FLOAT J)))

(DEFINE FLOAT? (LAMBDA (J) (FLOAT? J)))

(DEFINE FLOOR (LAMBDA (J) (FLOOR J)))

(DEFINE GETPROP (LAMBDA (I J) (GETPROP I J)))

(DEFINE INTEGER->CHAR
  (LAMBDA (J)
    (INTEGER->CHAR J)))

(DEFINE INTEGER? (LAMBDA (J) (INTEGER? J)))

(DEFINE LAST-PAIR (LAMBDA (J) (LAST-PAIR J)))

(DEFINE LENGTH (LAMBDA (J) (LENGTH J)))

(DEFINE LIST-TAIL (LAMBDA (I J) (LIST-TAIL I J)))

(DEFINE MAKE-PACKED-VECTOR
  (LAMBDA (H I J)
    (MAKE-PACKED-VECTOR H I J)))

(DEFINE MEMBER (LAMBDA (I J) (MEMBER I J)))

(DEFINE MEMQ (LAMBDA (I J) (MEMQ I J)))

(DEFINE MEMV (LAMBDA (I J) (MEMV I J)))

(DEFINE MINUS (LAMBDA (J) (MINUS J)))

(DEFINE NEGATIVE? (LAMBDA (J) (NEGATIVE? J)))

(DEFINE NOT (LAMBDA (J) (NOT J)))

(DEFINE NUMBER? (LAMBDA (J) (NUMBER? J)))

(DEFINE OBJECT-HASH (LAMBDA (J) (OBJECT-HASH J)))

(DEFINE OBJECT-UNHASH
  (LAMBDA (J)
    (OBJECT-UNHASH J)))

(DEFINE ODD? (LAMBDA (J) (ODD? J)))

(DEFINE PAIR? (LAMBDA (J) (PAIR? J)))

(DEFINE PORT? (LAMBDA (J) (PORT? J)))

(DEFINE POSITIVE? (LAMBDA (J) (POSITIVE? J)))

(DEFINE PRINT-LENGTH
  (LAMBDA (J)
    (PRINT-LENGTH J)))

(DEFINE PROC? (LAMBDA (J) (PROC? J)))

(DEFINE PROPLIST (LAMBDA (J) (PROPLIST J)))

(DEFINE PUTPROP (LAMBDA (H I J) (PUTPROP H I J)))

(DEFINE QUOTIENT (LAMBDA (I J) (QUOTIENT I J)))

(DEFINE RATIONAL? (LAMBDA (J) (RATIONAL? J)))

(DEFINE REAL? (LAMBDA (J) (REAL? J)))

(DEFINE REMAINDER (LAMBDA (I J) (REMAINDER I J)))

(DEFINE REMPROP (LAMBDA (I J) (REMPROP I J)))

(DEFINE RESET (LAMBDA () (RESET)))

(DEFINE REVERSE! (LAMBDA (J) (REVERSE! J)))

(DEFINE ROUND (LAMBDA (J) (ROUND J)))

(DEFINE SCHEME-RESET (LAMBDA () (SCHEME-RESET)))

(DEFINE SET-CAR! (LAMBDA (I J) (SET-CAR! I J)))

(DEFINE SET-CDR! (LAMBDA (I J) (SET-CDR! I J)))

(DEFINE STRING->SYMBOL
  (LAMBDA (J)
    (STRING->SYMBOL J)))

(DEFINE STRING->UNINTERNED-SYMBOL
  (LAMBDA (J)
    (STRING->UNINTERNED-SYMBOL J)))

(DEFINE STRING-FILL!
  (LAMBDA (I J)
    (STRING-FILL! I J)))

(DEFINE STRING-LENGTH
  (LAMBDA (J)
    (STRING-LENGTH J)))

(DEFINE STRING-REF
  (LAMBDA (I J)
    (STRING-REF I J)))

(DEFINE STRING-SET!
  (LAMBDA (H I J)
    (STRING-SET! H I J)))

(DEFINE STRING? (LAMBDA (J) (STRING? J)))

(DEFINE SUBSTRING
  (LAMBDA (H I J)
    (SUBSTRING H I J)))

(DEFINE SUBSTRING-FIND-NEXT-CHAR-IN-SET
  (LAMBDA (G H I J)
    (SUBSTRING-FIND-NEXT-CHAR-IN-SET G H I J)))

(DEFINE SUBSTRING-FIND-PREVIOUS-CHAR-IN-SET
  (LAMBDA (G H I J)
    (SUBSTRING-FIND-PREVIOUS-CHAR-IN-SET G H I J)))

(DEFINE SYMBOL->STRING
  (LAMBDA (J)
    (SYMBOL->STRING J)))

(DEFINE SYMBOL? (LAMBDA (J) (SYMBOL? J)))

(DEFINE THE-ENVIRONMENT
  (LAMBDA ()
    (THE-ENVIRONMENT)))

(DEFINE TRUNCATE (LAMBDA (J) (TRUNCATE J)))

(DEFINE VECTOR-FILL!
  (LAMBDA (I J)
    (VECTOR-FILL! I J)))

(DEFINE VECTOR-LENGTH
  (LAMBDA (J)
    (VECTOR-LENGTH J)))

(DEFINE VECTOR-REF
  (LAMBDA (I J)
    (VECTOR-REF I J)))

(DEFINE VECTOR-SET!
  (LAMBDA (H I J)
    (VECTOR-SET! H I J)))

(DEFINE VECTOR? (LAMBDA (J) (VECTOR? J)))

(DEFINE WINDOW-SAVE-CONTENTS
  (LAMBDA (J)
    (WINDOW-SAVE-CONTENTS J)))

(DEFINE WINDOW-RESTORE-CONTENTS
  (LAMBDA (I J)
    (WINDOW-RESTORE-CONTENTS I J)))

(DEFINE ZERO? (LAMBDA (J) (ZERO? J)))
