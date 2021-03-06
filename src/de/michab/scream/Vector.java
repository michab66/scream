/* $Id: Vector.java 190 2009-07-01 20:53:40Z Michael $
 *
 * Scream / Kernel
 *
 * Released under Gnu Public License
 * Copyright (c) 1998-2009 Michael G. Binz
 */
package de.michab.scream;

import java.util.Arrays;



/**
 * Vectors are heterogeneous structures whose elements are indexed by integers.
 * A vector typically occupies less space than a list of the same length, and
 * the average time required to access a randomly chosen element is typically
 * less for the vector than for the list.  The length of a vector is the number
 * of elements that it contains. This number is a non-negative integer that is
 * fixed when the vector is created. The valid indexes of a vector are the
 * exact non-negative integers less than the length of the vector. The first
 * element in a vector is indexed by zero, and the last element is indexed by
 * one less than the length of the vector.
 */
public class Vector
  extends FirstClassObject
{
  // TODO It is not clear how the constantness is handled for a vector.

  /**
   * The name of the type as used by error reporting.
   *
   * @see FirstClassObject#getTypename()
   */
  public static final String TYPE_NAME = "vector";



  /**
   * The java array that holds the vector elements.
   */
  private FirstClassObject[] _theArray;



  /**
   * Create an array of the specified size.  The array slots are initialized
   * to NIL (the empty list).
   *
   * @param size Size of the array to be created.
   */
  public Vector( long size )
  {
    this( size, Cons.NIL );
  }



  /**
   * Creates an array of the specified size and initializes its slots
   * to the specified value.  Note that each slot is set to the same
   * initial object, so that the elements are equal in the sense of
   * the scheme predicate eqv?.
   *
   * @param size The size of the array to be created.
   * @param initialiser The initial value for the array slots.
   */
  public Vector( long size, FirstClassObject initialiser )
  {
    // Create the array...
    _theArray = new FirstClassObject[ (int)size ];
    // ...and initialize it.
    fill( initialiser );
  }



  /**
   * Create a Scheme vector from the passed array.  The array is copied.
   *
   * @param array The array holding the initial contents of the resulting
   *              vector.
   * @param copyArray In case this is false, the passed array won't be copied
   *                  but used as is for the internal representation of the
   *                  vector.
   */
  public Vector( FirstClassObject[] array, boolean copyArray )
  {
    if ( copyArray )
    {
      _theArray = new FirstClassObject[ array.length ];
      System.arraycopy( array, 0, _theArray, 0, _theArray.length );
    }
    else
      _theArray = array;
  }



  /**
   * Create a Scheme vector from the passed array.  The array is copied.
   *
   * @param array The array holding the initial contents of the resulting
   *              vector.
   */
  public Vector( FirstClassObject[] array )
  {
    this( array, true );
  }



  /**
   * Sets an array slot to the specified value.
   *
   * @param idx The index of the slot to set.
   * @param so The value to set.
   * @throws RuntimeX in case the array index is out of bounds.
   */
  public void setElement( int idx, FirstClassObject so )
    throws RuntimeX
  {
    try
    {
      _theArray[ idx ] = so;
    }
    catch ( ArrayIndexOutOfBoundsException e )
    {
      throw new RuntimeX( "INDEX_OUT_OF_BOUNDS", new Object[]{ "" + idx } );
    }
  }



  /**
   * Access the value of an array slot.
   *
   * @param idx The index of the slot to access.
   * @return The slot's value.
   */
  public FirstClassObject getElement( int idx )
  {
    return _theArray[ idx ];
  }



  /**
   * Get the size of the array.
   *
   * @return The size of the array.
   */
  public long getSize()
  {
    return _theArray.length;
  }



  /**
   * Fill all vector slots with the passed value.  The value is not copied.
   *
   * @param filler The value to be used for filling the vector.
   */
  public void fill( FirstClassObject filler )
  {
    Arrays.fill( _theArray, filler );
  }



  /**
   * The implementation of the scheme equal? procedure.  This is the least
   * efficient one since lists and arrays are deep compared. For other types
   * eqv? is used.
   *
   * @param other The FirstClassObject to compare with.
   */
  public boolean equal( FirstClassObject other )
  {
    if ( other instanceof Vector &&
         _theArray.length == ((Vector)other)._theArray.length )
    {
      Vector otherVector = (Vector)other;

      for ( int i = 0 ; i < _theArray.length ; i++ )
      {
        boolean idxeqv =
          equal( _theArray[i], otherVector._theArray[i] );

        if ( ! idxeqv )
          return idxeqv;
      }

      return true;
    }

    return false;
  }



  /**
   * @see FirstClassObject#toString
   */
  public String toString()
  {
    StringBuilder result = new StringBuilder( "#(" );

    // Add one vector element after the other.
    for ( int i = 0 ; i < _theArray.length ; i++ )
    {
      result.append( stringize( _theArray[i] ) );
      result.append( ' ' );
    }

    // Remove the space at the end added in the above loop.
    if ( _theArray.length > 0 )
      result.setLength( result.length() -1 );

    return result.append( ')' ).toString();
  }



  /**
   * @see FirstClassObject#clone
   */
  public Object clone()
  {
    return new Vector( _theArray );
  }



  /**
   * Converts the vector to an array of <code>java.lang.Object</code>s holding
   * recursively converted entries.
   */
  public Object convertToJava()
  {
    Object[] result = new Object[ _theArray.length ];

    for ( int i = 0 ; i < result.length ; i++ )
      result[i] = _theArray[i].convertToJava();

    return result;
  }
}
