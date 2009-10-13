/*
 * TextBox.fx
 *
 * Created on Oct 13, 2009, 8:19:13 PM
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

import javax.swing.text.AttributeSet;
import javax.accessibility.AccessibleText;
import javax.accessibility.AccessibleEditableText;

import java.awt.Rectangle;

/**
 * @author thomasbutter
 */

public class TextBox extends javafx.scene.control.TextBox, Accessible {
    public var icontent : String = bind text on replace {
        if(accessibleContext != null) accessibleContext.setName(icontent);
    }

    var accessibleContext : NodeAccessibleContext = null;
    override function getAccessibleContext() {
        if(accessibleContext == null) {
            accessibleContext = new NodeAccessibleContext(this, AccessibleRole.LABEL, text);
            accessibleContext.setAEditableText(AEditableText {});
        }
        return accessibleContext;
    }
}

class AEditableText extends AccessibleEditableText {
    
    override public function setAttributes(startIndex : Integer, endIndex : Integer, a : AttributeSet ) {
    }

    override public function cut(startIndex : Integer, endIndex : Integer) {
        text = "{text.substring(0, startIndex)}{text.substring(endIndex+1)}";
    }

    override public function delete(startIndex : Integer, endIndex : Integer) {
        text = "{text.substring(0, startIndex)}{text.substring(endIndex+1)}";
    }

    override public function getTextRange(startIndex : Integer, endIndex : Integer) {
        return text.substring(startIndex, endIndex);
    }

    override public function insertTextAtIndex(index : Integer, str : String) {
        text = "{text.substring(0, index)}{str}{text.substring(index)}";
    }

    override public function selectText(startIndex : Integer, endIndex : Integer) {
        // do nothing
    }

    override public function replaceText(startIndex : Integer, endIndex : Integer, s : String) {
        text = "{text.substring(0, startIndex)}{s}{text.substring(endIndex)}";
    }

    override public function paste(index : Integer) {
        // not supported
    }

    override public function setTextContents(str : String) {
        text = str;
    }

    override public function getSelectedText() {
        return "";
    }

    override public function getSelectionEnd() {
        return 0;
    }

    override public function getSelectionStart() {
        return 0;
    }

    override public function getCharacterAttribute(i : Integer) {
        return null;
    }

    override public function getBeforeIndex(part : Integer, index : Integer) {
        if(part == AccessibleText.CHARACTER) return text.substring(index-1, index);
        return text.substring(0, index);
    }

    override public function getAfterIndex(part : Integer, index : Integer) {
        if(part == AccessibleText.CHARACTER) return text.substring(index, index+1);
        return text.substring(index);
    }
    
    override public function getAtIndex(part : Integer, index : Integer) {
        if(part == AccessibleText.CHARACTER) return text.substring(index, index+1);
        return text.substring(index);
    }

    override public function getCaretPosition() {
        return 0;
    }

    override public function getCharCount() {
        return text.length();
    }

    override public function getCharacterBounds(i : Integer) {
        return new Rectangle(0,0,0,0);
    }

    override public function getIndexAtPoint(p) {
        return 0;
    }
}
