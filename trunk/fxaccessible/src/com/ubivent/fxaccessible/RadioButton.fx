/*
 * RadioButton.fx
 *
 * Created on Oct 13, 2009, 2:20:54 PM
  * Copyright (c) 2009, ubivent GmbH
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this
 * list of conditions and the following disclaimer in the documentation and/or other
 * materials provided with the distribution.
 * Neither the name of ubivent nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.ubivent.fxaccessible;

import javax.accessibility.Accessible;

import javax.accessibility.AccessibleRole;

/**
 * @author thomasbutter
 */

public class RadioButton extends javafx.scene.control.RadioButton, Accessible {
    public var itext : String = bind text on replace {
        if(accessibleContext != null) accessibleContext.setName(text);
    }

    public var action : function(c : ClickableRectangle) = null;

    var accessibleContext : NodeAccessibleContext = null;
    override function getAccessibleContext() {
        if(accessibleContext == null) {
            accessibleContext = new NodeAccessibleContext(this, AccessibleRole.RADIO_BUTTON, itext);
            accessibleContext.setAction(function() {
                        fire();
                    });
        }
        return accessibleContext;
    }
}
