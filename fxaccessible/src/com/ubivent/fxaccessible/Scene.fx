/*
 * Scene.fx
 *
 * Created on Oct 11, 2009, 9:37:09 AM
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

import javafx.stage.Stage;



import com.sun.javafx.tk.swing.WindowStage;



import javax.swing.JFrame;

import javax.swing.JRootPane;

import javax.accessibility.AccessibleRole;

/**
 * @author thomasbutter
 */

public class Scene extends javafx.scene.Scene, Accessible, SceneInterface {


    override public function getDC() {
        return dc;
    }

    var accessibleContext  = null;
    override function getAccessibleContext() {
        if(accessibleContext == null) {
            accessibleContext = new NodeAccessibleContext(this, AccessibleRole.PANEL, "");
            FX.deferAction(function() {
                accessibleContext.setChildren(content);
                    });
        }
        return accessibleContext;
    }

    var accessibleContent = bind content on replace {
        if(accessibleContext != null) accessibleContext.setChildren(content);
    }

    public var dc : DummyContainer;

    var istage : Stage = bind stage on replace {
        if(stage != null) {
            dc = new DummyContainer(this);
            //(((stage.impl_getPeer() as WindowStage).window as JFrame).getGlassPane() as JPanel).setVisible(true);
            (((stage.impl_getPeer() as WindowStage).window as JFrame).getRootPane() as JRootPane).add(dc,0);
            dc.setLocation(0,0);
            dc.setSize(width, height);
        }
    }

    var iwidth = bind width on replace {
        if(dc != null) dc.setSize(width, height);
    }

    var iheight = bind height on replace {
        if(dc != null) dc.setSize(width, height);
    }
}