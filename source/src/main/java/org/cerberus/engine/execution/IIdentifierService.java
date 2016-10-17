/*
 * Cerberus  Copyright (C) 2013  vertigo17
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This file is part of Cerberus.
 *
 * Cerberus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Cerberus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Cerberus.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.cerberus.engine.execution;

import org.cerberus.engine.entity.Identifier;
import org.cerberus.exception.CerberusEventException;

/**
 *
 * @author bcivel
 */
public interface IIdentifierService {
    
     public Identifier convertStringToIdentifier(String input);
     
     public Identifier convertStringToSelectIdentifier(String input);
     
     public void checkSelectOptionsIdentifier(String identifier) throws CerberusEventException;

     public void checkWebElementIdentifier(String identifier) throws CerberusEventException;

    public void checkSQLIdentifier(String identifier) throws CerberusEventException;
     }
