/* $Id: Syntax.java 197 2009-08-03 21:30:27Z Michael $
 *
 * Scream / Kernel
 *
 * Released under Gnu Public License
 * Copyright (c) 1998-2000 Michael G. Binz
 */
package de.michab.scream;

import de.michab.scream.pops.*;



/**
 * Followed the scheme spec in naming this class.  An alternate name would be
 * 'macro', also common is 'special form'.
 *
 * The implementation of this syntax facility is currently very simple.  All
 * syntactic elements of Scheme are mapped to straightforward method calls.
 * The problem here is that for each use of the 'do' machinery all syntax
 * analysis has to be done over and over again.  Solution is to switch to some
 * sort of primitive notation.  Basically a 'do' is a primitive operation for
 * all kinds of iteration sequences.  Primitives get evaluated (compiled?) once
 * and will be installed in the expression.  Another problem that could be
 * solved with this approach is the switch of the frontend language.  E.g.
 * more C-like notation could be possible then, where all of the special
 * processing is encapsulated in the frontend.  One advantage of Scheme being
 * the first implemented frontend is that this language by design tries to
 * implement the universal superset of language mechanisms so most other
 * languages should map onto this -- at least control structure.<br>
 *
 * Well, to be honest, this is not really new but is standard compiler design
 * since the seventies.  In a nutshell what we need is a compiled intermediate
 * language.<br>
 *
 * TODO: At the moment this class is pretty bare bones.  Only makes sense as a
 * base class for native java syntax implementations.  Will have to look into
 * syntax related scheme sections to implement the functionality specified there.
 *
 * @version $Rev: 197 $
 * @author Michael Binz
 */
public class Syntax
  extends Operation
{
  /**
   * The name of the type as used by error reporting.
   *
   * @see FirstClassObject#getTypename()
   */
  public static final String TYPE_NAME = "syntax";



  /**
   *
   */
  private static final Symbol ELSE = Symbol.createObject( "else" );



  /**
   * Default constructor.  Used for Java-defined specializations.
   *
   * @param name The new syntax' symbolic name.
   */
  private Syntax( Symbol name )
  {
    super( name );
  }



  /**
   * Constructor for Java-defined specializations.  The passed string names
   * the symbol bound to this syntax.
   *
   * @param name The string name of the symbol bound to the new syntax.  Used
   *        for error reporting.
   */
  protected Syntax( String name )
  {
    this( Symbol.createObject( name ) );
  }



  /**
   *
   * @param e
   * @param args
   * @param body
   * @throws RuntimeX
   */
  protected Syntax( Environment e,
                    FirstClassObject args,
                    Cons body  )
    throws RuntimeX
  {
    super( args, body, e );
  }



  /**
   * TODO fix comment
   * Activate, receives an array of FirstClassObjects instead of a Cons.  May
   * be handier for native java syntax implementations.<br>
   * Note that the different <code>activate</code> calls implement a chain of
   * responsibility -- one of them has to be overridden and implement the
   * actual functionality.  The default behavior of this final part in the
   * chain is to throw an <code>InternalError</code>.
   *
   * @param parent The parent environment.
   * @param arguments The argument list.
   * @return The result of the activation.
   * @throws RuntimeX In case an error occured.
   * @throws InternalError In case this method is not overridden.
   */
  protected FirstClassObject activate( Environment parent,
                                       FirstClassObject[] arguments )
    throws RuntimeX
  {
    // TODO Below is the only reference to body from a subclass of Operation.
    // This is really a HACK since i have no better idea currently how to
    // differentiate btw Java and Scheme implemented Syntaxes/Operations.
    // Think.  We should get rid of the _body reference and set body as private
    // to Operation.
    if ( _body == Cons.NIL )
      return evaluate( compile( parent, arguments ), parent );

    return super.activate( parent, arguments );
  }



  /**
   * @return A string representation for this syntax.
   * @see FirstClassObject#toString
   */
  public String toString()
  {
    return "<Syntax " + getName() + ">";
  }



  /**
   * Interprets a tail sequence.  A tail sequence is represented by a list of
   * expressions whose last one will be evaluated as trailing context.
   *
   * @param seq The list of expressions.
   * @param env The environment used for expression evaluation.
   * @return The result of the last expression in the list.
   * @throws RuntimeX If an error occurs while evaluating the expressions.
   */
  protected static FirstClassObject interpretTailSequence(
    FirstClassObject[] seq,
    Environment env )
  throws
    RuntimeX
  {
    return interpretTailSequence( seq, 0, env );
  }



  /**
   * Interprets a tail sequence.  A tail sequence is represented by a list of
   * expressions whose last one will be evaluated as trailing context.
   *
   * @param seq The list of expressions.
   * @param startIdx The index of the first expression to evaluate.
   * @param env The environment used for expression evaluation.
   * @return The result of the last expression in the list.
   * @throws RuntimeX If an error occurs while evaluating the expressions.
   */
  protected static FirstClassObject interpretTailSequence(
    FirstClassObject[] seq,
    int startIdx,
    Environment env )
  throws
    RuntimeX
  {
    for ( int i = startIdx ; i < seq.length -1 ; i++ )
      evaluate( seq[i], env );

    return evaluateTrailingContext( seq[ seq.length-1 ], env );
  }



  /**
   * Switch off evaluation for the single passed argument.
   *
   * (quote <datum>) syntax; r5rs 8
   */
  static private Syntax quoteSyntax = new Syntax( "quote" )
  {
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkArgumentCount( 1, args );

      FirstClassObject result = args[0];

      setConstant( result, true );

      return new Quote( result );
    }
  };



  /**
   * (lambda <formals> <body>) syntax; r5rs 9
   */
  static private Syntax lambdaSyntax = new Syntax( "lambda" )
  {
    public FirstClassObject activate( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );

      return new Procedure( parent, args[0], Cons.create( args, 1 ) );
    }
  };



  /**
   * <code>
   * (if <test> <consequent> <alternate>)<br>
   * (if <test> <consequent>)<br>
   * </code><br>
   * Syntax: <Test>, <consequent>, and <alternate> may be arbitrary
   * expressions.<br>
   * Semantics: An if expression is evaluated as follows:  First, <test> is
   * evaluated. If it yields a true value (see section 6.3.1), then
   * <consequent> is evaluated and its value(s) is(are) returned. Otherwise
   * <alternate> is evaluated and its value(s) is(are) returned. If <test>
   * yields a false value and no <alternate> is specified, then the result of
   * the expression is unspecified.
   */
  static private Syntax ifSyntax = new Syntax( "if" )
  {
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );
      checkMaximumArgumentCount( 3, args );

      // Compile referenced nodes.
      for ( int i = 0 ; i < args.length ; i++ )
        args[i] = compile( args[i], parent );

      FirstClassObject condition = args[0];
      FirstClassObject onTrue = args[1];
      // Handle optional 'else' branch.
      FirstClassObject onFalse = args.length == 3 ? args[2] : Cons.NIL;

      // Optimisation of constant sub expressions.  If this is sth like
      // (if #t ...) no 'if' node is needed at all.
//      if ( isConstant( condition ) )
//      {
//        System.err.println( "removed 'if'" );
//
//        if ( condition != SchemeBoolean.F )
//          return onTrue;
//        else
//          return onFalse;
//      }

      // Now create the compiled node.
      return new If( condition, onTrue, onFalse );
    }
  };



  /**
   * (cond <clause1> <clause2> ...)  syntax r5rs, 10
   */
  static private Syntax condSyntax = new Syntax( "cond" )
  {
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 1, args );

      Cons[] clausesTmp = new Cons[ args.length ];
      // Check if all the clauses are actually lists.  The do-while loop is
      // used to keep 'i' in a local scope.  'i' in turn is needed in the try
      // and catch scope to create a meaningful error message.
      do
      {
        int i = 0;
        try
        {
          for ( i = 0 ; i < args.length ; i++ )
          {
            clausesTmp[i] = (Cons)args[i];
            if ( Cons.NIL == clausesTmp[i] )
              throw new ClassCastException();
          }
        }
        catch ( ClassCastException e )
        {
          throw new RuntimeX( "BAD_CLAUSE",
                              new Object[]{ stringize( args[i] ) } );
        }
      } while ( false );

      // Everything is fine so far.  Convert the lists into arrays that can be
      // handled much more efficiently.
      FirstClassObject[][] clauses = new FirstClassObject[ args.length ][];
      for ( int i = 0 ; i < clauses.length ; i++ )
        clauses[i] = clausesTmp[i].asArray();

      if ( eqv( ELSE, clauses[ args.length-1 ][0] ) )
        clauses[ args.length-1 ][0] = SchemeBoolean.T;

      // Finally compile all the subexpressions.
      for ( int i = 0 ; i < clauses.length ; i++ )
        for ( int j = 0 ; j < clauses[i].length ; j++ )
          clauses[i][j] = compile( clauses[i][j], parent );

      // TODO Remove static subexpressions.

      return new Cond( clauses );
    }
  };



  /**
   * (case <key> <clause1> <clause2> ...) syntax; r5rs 10
   */
  static private Syntax caseSyntax = new Syntax( "case" )
  {
    public FirstClassObject activate( Environment parent,
                                      FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );

      // Evaluate the key.
      FirstClassObject key = evaluate( args[0], parent );

      // Now try to find the key in one of the clauses
      for ( int j = 1 ; j < args.length ; j++ )
      {
        if ( !( args[j] instanceof Cons ) )
          throw new RuntimeX( "BAD_CLAUSE",
                              new Object[]{ stringize( args[j] ) } );

        FirstClassObject[] clause = ((Cons)args[j]).asArray();

        if ( clause.length < 2 )
          throw new RuntimeX( "BAD_CLAUSE",
                              new Object[]{ stringize( args[j] ) } );

        // If this is the last clause and there is an 'else' clause...
        if ( j == args.length-1 && eqv( clause[0], ELSE ) )
          // ...make sure, that we are eqv to the key.
          clause[0] = new Cons( key, Cons.NIL );
        else if ( !( clause[0] instanceof Cons ) )
          throw new RuntimeX( "BAD_CLAUSE",
                              new Object[]{ stringize( args[j] ) } );

        FirstClassObject[] clauseData = ((Cons)clause[0]).asArray();

        for ( int i = 0 ; i < clauseData.length ; i++ )
        {
          if ( eqv( key, clauseData[i] ) )
            return interpretTailSequence( clause, 1, parent );
        }
      }

      // Unspecified according to the standard.
      return Cons.NIL;
    }
  };



  /**
   * (and <test1> ...) syntax; r5rs 11
   *
   * The test expressions are evaluated from left to right, and the value of
   * the first expression that evaluates to a false value (see section 6.3.1)
   * is returned. Any remaining expressions are not evaluated. If all the
   * expressions evaluate to true values, the value of the last expression is
   * returned.  If there are no expressions then #t is returned.
   */
  static private Syntax andSyntax = new Syntax( "and" )
  {
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      // Constant expression optimization.
      if ( args.length == 0 )
        return SchemeBoolean.T;

      // Compile all passed expressions.
      for ( int i = args.length-1 ; i >= 0 ; i-- )
        args[i] = compile( args[i], parent );

      return new ShortcutAnd( args );
    }
  };



  /**
   * (or <test1> ... ) syntax; r5rs 11
   *
   * The test expressions are evaluated from left to right, and the value of
   * the first expression that evaluates to a true value (see section 6.3.1) is
   * returned. Any remaining expressions are not evaluated. If all expressions
   * evaluate to false values, the value of the last expression is returned. If
   * there are no expressions then #f is returned.
   */
  static private Syntax orSyntax = new Syntax( "or" )
  {
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      // Constant expression optimisation.
      if ( args.length == 0 )
        return SchemeBoolean.F;

      // Compile all passed expressions.
      for ( int i = args.length-1 ; i >= 0 ; i-- )
        args[i] = compile( args[i], parent );

      return new ShortcutOr( args );
    }
  };



  /**
   *
   */
  static abstract class LetSyntax
    extends Syntax
  {
    public LetSyntax( String name )
    {
      super( name );
    }

    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );

      FirstClassObject exceptionInfo = Cons.NIL;

      Symbol[] variables = null;
      FirstClassObject[] inits = null;

      // If there are bindings...
      if ( args[0] != Cons.NIL )
      {
        // ...decompose them.  As soon something is wrong a ClassCastException
        // is thrown, resulting in an error message.
        try
        {
          exceptionInfo = args[0];
          // CCEx here if bindings was no Cons.
          FirstClassObject[] bindings = ((Cons)args[0]).asArray();
          variables = new Symbol[ bindings.length ];
          inits = new FirstClassObject[ bindings.length ];

          for ( int i = 0 ; i < bindings.length ; i++ )
          {
            exceptionInfo = bindings[i];
            // CCEx here if a single binding was no cons.
            Cons binding = (Cons)bindings[i];
            if ( Cons.NIL == binding )
              throw new ClassCastException();
            // Check whether the single binding is a proper two element list
            // and throw an artificial CCEx to get in the BAD_BINDING handler.
            if ( !binding.isProperList() || binding.length() != 2 )
              throw new ClassCastException();
            // Decompose the single binding.  CCEx here if the first element in
            // the list is no symbol.
            variables[i] = (Symbol)binding.listRef( 0 );
            // CCEx here is not really possible.
            inits[i] = compile( binding.listRef( 1 ), parent );
          }
        }
        catch ( ClassCastException e )
        {
          throw new RuntimeX(
              "BAD_BINDING",
              new Object[]{ stringize( getName() ),
                            stringize( exceptionInfo ) } );
        }
      }
      else
      {
        // We received no bindings.
        variables = new Symbol[0];
        inits = new FirstClassObject[0];
      }

      FirstClassObject[] body = new FirstClassObject[ args.length - 1 ];
      System.arraycopy( args, 1, body, 0, body.length );
      for ( int i = body.length-1 ; i >= 0 ; i-- )
        body[i] = compile( body[i], parent );

      return createPop( variables, inits, body );
    }



    /**
     * Create the actual primitive operation that implements the let syntax.
     * This is a template method to be overridden by the concrete let
     * implementations.
     *
     * @param variables
     * @param inits
     * @param body
     * @return The newly created primitive.
     */
    abstract FirstClassObject createPop( Symbol[] variables,
                                         FirstClassObject[] inits,
                                         FirstClassObject[] body );
  };



  /**
   * (let <bindings> <body>) syntax r5rs, 11
   * where bindings is ((variable1 init1) ...) and body is a sequence of
   * expressions.
   */
  static private Syntax letSyntax = new LetSyntax( "let" )
  {
    FirstClassObject createPop( Symbol[] variables,
                                FirstClassObject[] inits,
                                FirstClassObject[] body )
    {
      return new Let( variables, inits, body );
    }
  };



  /**
   * (let* <bindings> <body>) syntax r5rs, 11
   * where bindings is ((variable1 init1) ...) and body is a sequence of
   * expressions.
   */
  static private Syntax letAsteriskSyntax = new LetSyntax( "let*" )
  {
    FirstClassObject createPop( Symbol[] variables,
                                FirstClassObject[] inits,
                                FirstClassObject[] body )
    {
      return new LetAsterisk( variables, inits, body );
    }
  };


  /**
   * (letrec <bindings> <body>) syntax r5rs, 11
   * where bindings is ((variable1 init1) ...) and body is a sequence of
   * expressions.
   */
  static private Syntax letrecSyntax = new LetSyntax( "letrec" )
  {
    FirstClassObject createPop( Symbol[] variables,
                                FirstClassObject[] inits,
                                FirstClassObject[] body )
    {
      return new Letrec( variables, inits, body );
    }
  };



  /**
   * (begin exp1 exp2 ...) library syntax; r5rs 12
   */
  static private Syntax beginSyntax = new Syntax( "begin" )
  {
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 1, args );

      for ( int i = args.length-1 ; i >= 0 ; i-- )
        args[i] = compile( args[i], parent );

      return new Sequence( args );
    }
  };



  /**
   * <code>
   * (do ((<variable1> <init1> <step1>)
   *      ... )
   *     (<test> <expression> ... )
   *     command ... )
   * </code><br>
   * Do is an iteration construct. It specifies a set of variables to be bound,
   * how they are to be initialized at the start, and how they are to be
   * updated on each iteration. When a termination condition is met, the loop
   * exits after evaluating the <code>expression</code>s.<br>
   * Do expressions are evaluated as follows: The <code>init</code> expressions
   * are evaluated (in some unspecifed order), the <code>variable</code>s are
   * bound to fresh locations, the results of the <code>init</code> expressions
   * are stored in the bindings of the <code>variable</code>s, and then the
   * iteration phase begins.<br>
   * Each iteration begins by evaluating <code>test</code>; if the result is
   * false (see section 6.3.1), then the <code>command</code> expressions are
   * evaluated in order for effect, the <code>step</code> expressions are
   * evaluated in some unspecified order, the <code>variable</code>s are bound
   * to fresh locations, the results of the <code>step</code>s are stored in
   * the bindings of the <code>variable</code>s, and the next iteration
   * begins.<br>
   * If <code>test</code> evaluates to a true value, then the
   * <code>expression</code>s are evaluated from left to right and the value(s)
   * of the last <code>expression<code> is(are) returned. If no
   * <code>expression<code>s are present, then the value of the do expression
   * is unspecified.<br>
   * The region of the binding of a <code>variable</code> consists of the
   * entire do expression except for the <code>init<code>s. It is an error for
   * a <code>variable<code> to appear more than once in the list of do
   * variables.<br>
   * A <code>step<code> may be omitted, in which case the effect is the same as
   * if <code>(<variable> <init> <variable>)</code> had been written instead of
   * <code>(<variable> <init>)</code>.
   */
  static private Syntax doSyntax = new Syntax( "do" )
  {
    /**
     * Checks if the passed argument is a <code>Cons</code>, is not NIL and is
     * a proper list.  Transforms the list into an array and returns that.
     */
    private FirstClassObject[] isNonNilAndProper( FirstClassObject fco )
    {
      if ( Cons.NIL == fco )
        throw new ClassCastException();
      if ( ! ((Cons)fco).isProperList() )
        throw new ClassCastException();
      return ((Cons)fco).asArray();
    }



    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );

      try
      {
        FirstClassObject[] bindings = isNonNilAndProper( args[0] );

        Symbol[] vars = new Symbol[ bindings.length ];
        FirstClassObject[] inits = new FirstClassObject[ vars.length ];
        FirstClassObject[] steps = new FirstClassObject[ vars.length ];

        for ( int i = 0 ; i < vars.length ; i++ )
        {
          FirstClassObject[] binding = isNonNilAndProper( bindings[i] );

          if ( Cons.NIL == binding[0] )
            throw new ClassCastException();

          switch ( binding.length )
          {
            case 2:
              vars[i] = (Symbol)binding[0];
              inits[i] = compile( binding[1], parent );
              steps[i] = vars[i];
              break;
            case 3:
              vars[i] = (Symbol)binding[0];
              inits[i] = compile( binding[1], parent );
              steps[i] = compile( binding[2], parent );
              break;

            default:
              throw new ClassCastException();
          }
        }

        FirstClassObject[] testSequence = isNonNilAndProper( args[1] );
        for ( int i = 0 ; i < testSequence.length ; i++ )
          testSequence[i] = compile( testSequence[i], parent );

        FirstClassObject test = testSequence[0];

        FirstClassObject[] exps = new FirstClassObject[ testSequence.length -1 ];
        System.arraycopy( testSequence, 1, exps, 0, exps.length );

        FirstClassObject[] cmds = new FirstClassObject[ args.length -2 ];
        System.arraycopy( args, 2, cmds, 0, cmds.length );
        for ( int i = 0 ; i < cmds.length ; i++ )
          cmds[i] = compile( cmds[i], parent );

        return new Loop( vars, inits, steps, test, exps, cmds );
      }
      catch ( ClassCastException e )
      {
        throw new RuntimeX( "BAD_BINDING" );
      }
    }
  };



  /**
   * (define <variable> <expression>) syntax; r5rs 16
   * (define (<variable> <formals>) <body>) syntax; r5rs 16
   * (define (<variable> . <formal>) <body>) syntax; r5rs 16
   */
  static private Syntax defineSyntax = new Syntax( "define" )
  {
    public FirstClassObject activate( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );

      // Type check.
      if ( args[0] instanceof Symbol )
      {
        if ( args.length > 2 )
          throw new RuntimeX( "TOO_MANY_SUBEXPRESSIONS",
                              new Object[]{ "define" } );
        // Get the value.
        FirstClassObject value = evaluate( args[1], parent );
        // At last bind it.
        parent.set( (Symbol)args[0], value );
      }
      else if ( args[0] instanceof Cons && ((Cons)args[0]).length() > 0 )
      {
        FirstClassObject symbol = ((Cons)args[0]).getCar();
        if ( ! (symbol instanceof Symbol) )
          throw new RuntimeX( "DEFINE_ERROR" );

        Procedure procToBind = new Procedure( parent,
                                              ((Cons)args[0]).getCdr(),
                                              Cons.create( args, 1 ) );
        procToBind.setName( (Symbol)symbol );
        parent.set( (Symbol)symbol, procToBind );
      }
      else
        throw new RuntimeX( "SYNTAX_ERROR" );

      // This is unspecified.
      return Cons.NIL;
    }
  };



  /**
   * (set! <variable> <expression>) syntax; r5rs 16
   */
  static private Syntax setBangSyntax = new Syntax( "set!" )
  {
    private Class<?>[] formalArglist =
      new Class[]{ Symbol.class,
                   FirstClassObject.class };



    /**
     *
     */
    public FirstClassObject compile( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkArguments( formalArglist, args );
      return new Assignment( (Symbol)args[0], compile( args[1], parent ) );
    }
  };



  /**
   * (%time exp)
   *
   * Returns a pair, where the car part holds the time that <code>exp</code>
   * needed to execute and the cdr holds the result of <code>exp</code>.
   */
  static private Syntax timeSyntax = new Syntax( "%time" )
  {
    public FirstClassObject activate( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkArgumentCount( 1, args );

      // Trigger an explicit garbage collection before starting with the time
      // measurements.
      System.gc();

      // Get the start time...
      long startTime = System.currentTimeMillis();
      // ...do the actual evaluation...
      FirstClassObject resultCdr = evaluate( args[0], parent );
      // ...and compute the time that was needed for the evaluation.
      FirstClassObject resultCar = SchemeInteger.createObject(
        System.currentTimeMillis() - startTime );

      return new Cons( resultCar, resultCdr );
    }
  };



  /**
   * (%syntax exp)
   *
   * Very similar to 'define'.  Generates macros whose body gets called
   * with not evaluated arguments.
   */
  static private Syntax syntaxSyntax = new Syntax( "%syntax" )
  {
    public FirstClassObject activate( Environment parent, FirstClassObject[] args )
      throws RuntimeX
    {
      checkMinimumArgumentCount( 2, args );

      // Type check.
      if ( args[0] instanceof Cons && ((Cons)args[0]).length() > 0 )
      {
        FirstClassObject symbol = ((Cons)args[0]).getCar();
        if ( ! (symbol instanceof Symbol) )
          throw new RuntimeX( "DEFINE_ERROR" );

        Syntax procToBind = new Syntax( parent,
                                              ((Cons)args[0]).getCdr(),
                                              Cons.create( args, 1 ) );
        procToBind.setName( (Symbol)symbol );
        parent.set( (Symbol)symbol, procToBind );
      }
      else
        throw new RuntimeX( "SYNTAX_ERROR" );

      // This is unspecified.
      return Cons.NIL;
    }
  };



  /**
   * Base operations setup.
   *
   * @param tle A reference to the top level environment to be extended.
   * @return The extended environment.
   */
  static Environment extendTopLevelEnvironment( Environment tle )
  {
    tle.setPrimitive( quoteSyntax );
    tle.setPrimitive( lambdaSyntax );
    tle.setPrimitive( ifSyntax );
    tle.setPrimitive( condSyntax );
    tle.setPrimitive( caseSyntax );
    tle.setPrimitive( andSyntax );
    tle.setPrimitive( orSyntax );
    tle.setPrimitive( letSyntax );
    tle.setPrimitive( letAsteriskSyntax );
    tle.setPrimitive( letrecSyntax );
    tle.setPrimitive( beginSyntax );
    tle.setPrimitive( doSyntax );
    tle.setPrimitive( defineSyntax );
    tle.setPrimitive( setBangSyntax );
    tle.setPrimitive( syntaxSyntax );

    tle.setPrimitive( timeSyntax );

    return tle;
  }
}
