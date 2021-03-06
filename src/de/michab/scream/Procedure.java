/* $Id: Procedure.java 1 2008-09-19 16:30:02Z binzm $
 *
 * Scream / Kernel
 *
 * Released under Gnu Public License
 * Copyright (c) 1998-2000 Michael G. Binz
 */
package de.michab.scream;



/**
 * Represents a scheme procedure or closure.
 *
 * @version $Rev: 1 $
 */
public class Procedure
  extends Operation
{
  /**
   * The name of the type as used by error reporting.
   *
   * @see FirstClassObject#getTypename()
   */
  public static final String TYPE_NAME = "procedure";



  /**
   * This procedure's effective environment.
   *
   * @label effective environment
   */
  private final Environment _closure;



  /**
   * Default constructor.  Used for Java defined specialisations.
   *
   * @param name The symbolic name for the new procedure.
   */
  protected Procedure( Symbol name )
  {
    super( name );
    _closure = null;
  }



  /**
   * Default constructor.  Used for Java defined specialisations.
   *
   * @param name The symbolic name for the new procedure.
   */
  protected Procedure( String name )
  {
    this( Symbol.createObject( name ) );
  }



  /**
   * Constructor used to create Scheme defined procedures.
   *
   * @param e The environment to be used by the new procedure.
   * @param args The list of formal arguments.
   * @param body The body of the new procedure.
   * @throws RuntimeX In case an error occurred.
   */
  public Procedure( Environment e,
                    FirstClassObject args,
                    Cons body  )
    throws RuntimeX
  {
    super( args, body, e );
    _closure = e;
  }



  /**
   * Since we are a procedure the arguments are evaluated and rest of the job
   * is delegated to the apply methods.  The passed argument list has to be
   * proper.  Note that as the final step after bumping through the chain of
   * <code>apply()</code> methods our superclass' <code>activate()</code> will
   * be called for executing the Scheme defined procedure.  A procedure
   * implemented in Java has to override one of the chained
   * <code>apply()</code> methods.
   *
   * @param parent The parent environment.
   * @param argumentList The actually passed argument list.
   * @return The result of the procedure activation.
   * @throws RuntimeX In case of an error.
   */
  public FirstClassObject activate( Environment parent, Cons argumentList )
    throws RuntimeX
  {
    // Check if our argument list is proper.
    if ( argumentList != Cons.NIL && !argumentList.isProperList() )
      throw new RuntimeX( "EXPECTED_PROPER_LIST" );

    FirstClassObject[] evaluatedArgs = _emptyArgArray;

    if ( argumentList != Cons.NIL )
    {
      evaluatedArgs = argumentList.asArray();
      for ( int i = evaluatedArgs.length-1 ; i >= 0 ; i-- )
        evaluatedArgs[i] = evaluate( evaluatedArgs[i], parent );
    }

    return apply( parent, evaluatedArgs );
  }



  /**
   * This is the public available apply procedure that is used from Scheme
   * implemented methods via reflection.
   *
   * @param evaluatedArgs The list of evaluated arguments to be used for the
   *        <code>apply</code> invocation.
   * @return The result of the procedure application.
   * @throws RuntimeX In case of an error.
   */
  public FirstClassObject apply( Cons evaluatedArgs )
    throws RuntimeX
  {
    FirstClassObject[] array;

    if ( Cons.NIL == evaluatedArgs )
      array = _emptyArgArray;
    else
      array = evaluatedArgs.asArray();

    // Just map to the array version of this method.
    return apply( array );
  }



  /**
   * Another point to be overridden.  In this case the parent environment
   * is accessible.
   *
   * @param parent The environment to use for this procedure application.
   * @param evaluatedArgs The list of evaluated arguments to be used for the
   *        <code>apply</code> invocation.
   * @return The result of the procedure application.
   * @throws RuntimeX In case of an error.
   */
  protected FirstClassObject apply( Environment parent,
                                    FirstClassObject[] evaluatedArgs )
    throws RuntimeX
  {
    // Note that this override is only used by the implementations of
    // the %error and evaluate procedures.
    return apply( evaluatedArgs );
  }



  /**
   * If not overridden this method actually executes the Scheme defined
   * procedure.
   *
   * @param evaluatedArgs The list of evaluated arguments to be used for the
   *        <code>apply</code> invocation.
   * @return The result of the procedure application.
   * @throws RuntimeX In case of an error.
   */
  protected FirstClassObject apply( FirstClassObject[] evaluatedArgs )
    throws RuntimeX
  {
    return super.activate( _closure, evaluatedArgs );
  }



  /**
   * Create a string representation of this Procedure.  Procedures can not be
   * read in.
   *
   * @return A string representation of this object.
   */
  public String toString()
  {
    return "<Procedure " + getName() + ">";
  }
}
