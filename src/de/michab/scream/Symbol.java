/* $Id: Symbol.java 788 2015-01-10 23:07:11Z Michael $
 *
 * Scream / Kernel
 *
 * Released under Gnu Public License
 * Copyright (c) 1998-2000 Michael G. Binz
 */
package de.michab.scream;

import de.michab.scream.util.WeakValueMap;


/**
 * Represents the Scheme symbol type.
 */
public final class Symbol
  extends FirstClassObject
{
  /**
   * The name of the type as used by error reporting.
   *
   * @see FirstClassObject#getTypename()
   */
  public static final String TYPE_NAME = "symbol";



  /**
   * This symbol's name.
   */
  private String _name;



  /**
   *
   */
  private static final WeakValueMap<String, Symbol> _flyweightMap =
      new WeakValueMap<String, Symbol>();



  /**
   * The symbol factory.  This has to be used to create new symbols.
   *
   * @param name The new symbol's name.
   * @return The newly created symbol.
   */
  public static synchronized Symbol createObject( String name )
  {
    Symbol result = _flyweightMap.get( name );

    if ( null == result )
    {
      result = new Symbol( name );
      _flyweightMap.put( name, result );
    }

    return result;
  }



  /**
   * The private constructor.  To create new symbols the static factory method
   * createObject has to be used.
   *
   * @param name The new symbol's name.
   * @see #createObject
   */
  private Symbol( String name )
  {
    _name = name;
    setConstant( true );
  }



  /**
   * Evaluates this symbol, i.e. looks up the symbol in the passed environment
   * and returns its value.
   *
   * @param e The environment to use for evaluation of this symbol.
   * @return The result of the evaluation.
   * @throws RuntimeX In case this symbol couldn't be evaluated.
   * @see FirstClassObject#evaluate
   */
  @Override
public FirstClassObject evaluate( Environment e )
    throws RuntimeX
  {
    return e.get( this );
  }



  /**
   * Tests equivalence to another object.
   *
   * @param other The other object used for the comparison.
   * @return <code>true</code> if the objects were equal.
   * @see FirstClassObject#eq
   */
  @Override
public boolean eq( FirstClassObject other )
  {
    return equals( other );
  }



  /**
   * Transform this symbol to its string representation.
   *
   * @return A string representation for this object.
   * @see FirstClassObject#toString
   */
  @Override
public String toString()
  {
    return _name;
  }



  /**
   * Convert this object into the Java type system.  Symbols are converted into
   * a string equivalent.
   *
   * @return This symbol as a string.
   */
  @Override
public Object convertToJava()
  {
    return toString();
  }



  /**
   * The implementation of the standard <code>java.lang.Object.hashCode()</code>
   * method.
   *
   * @return An hashcode for the object instance.
   */
  @Override
public int hashCode()
  {
    return _name.hashCode();
  }



  /**
   *
   */
  @Override
public boolean equals( Object other )
  {
      try
      {
          return _name.equals( ((Symbol)other)._name );
      }
      catch ( ClassCastException e )
      {
          return false;
      }
  }
}
