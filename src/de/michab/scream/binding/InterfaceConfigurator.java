/* $Id: InterfaceConfigurator.java 1 2008-09-19 16:30:02Z binzm $
 *
 * Scream / JavaBinding
 *
 * Released under Gnu Public License
 * Copyright (c) 2001 Michael G. Binz
 */
package de.michab.scream.binding;

import de.michab.scream.*;
import java.lang.reflect.*;



/**
 * Represents a default interface that is always added to the list of
 * interfaces generated by the interface factory.
 */
public interface InterfaceConfigurator
{
  /**
   * Defines the operation responsible for handling method calls.  To remove an
   * operation call this with a NIL operation.
   *
   * @param m Calls to this operation on the interface will be forwarded.
   * @param o The receiving operation.
   */
  public Operation defineOperation( Method m, Procedure o );
}
