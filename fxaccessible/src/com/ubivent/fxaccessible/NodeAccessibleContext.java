/*
 *  * Copyright (c) 2009, ubivent GmbH
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

import com.sun.javafx.functions.Function0;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.FocusListener;
import java.util.Locale;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javax.accessibility.Accessible;
import javax.accessibility.AccessibleAction;
import javax.accessibility.AccessibleComponent;
import javax.accessibility.AccessibleContext;
import javax.accessibility.AccessibleEditableText;
import javax.accessibility.AccessibleRole;
import javax.accessibility.AccessibleState;
import javax.accessibility.AccessibleStateSet;

/**
 *
 * @author thomasbutter
 */
public class NodeAccessibleContext extends AccessibleContext implements AccessibleComponent, AccessibleAction {
    public AccessibleRole role = AccessibleRole.PANEL;
    public String name = "no name";
    final Object lock = new Object();
    Accessible children[] = null;
    Accessible component;
    Accessible parent;
    Function0<Void> action = null;
    AccessibleEditableText aet = null;

    public void setAEditableText(AccessibleEditableText aet) {
        this.aet = aet;
    }

    public void setName(String s) {
        firePropertyChange(ACCESSIBLE_NAME_PROPERTY, name, s);
        name = s;
    }

    public void setParent(Accessible parent) {
        this.parent = parent;
    }

    public void setChildren(javafx.scene.Node nodes[]) {
        // count
        Accessible old[]= children;
        int i = 0;
        for(Object n : nodes) {
            if(n instanceof Accessible) i++;
        }
        synchronized(lock) {
            children = new Accessible[i];
            i = 0;
            for(Object n : nodes) {
                if(n instanceof Accessible) children[i++] = (Accessible)n;
                firePropertyChange(ACCESSIBLE_CHILD_PROPERTY, null, n);
            }
        }
        if(old == null) {
            for(javafx.scene.Node n : nodes) {
                if(n instanceof Accessible) {
                    ((NodeAccessibleContext)(((Accessible)n).getAccessibleContext())).setParent(component);
                    firePropertyChange(ACCESSIBLE_CHILD_PROPERTY, null, n);
                }
            }
            return;
        }
        for(Accessible a : old) {
            boolean found = false;
            for(javafx.scene.Node n : nodes) {
                if(n == a) found = true;
            }
            if(found == false) firePropertyChange
                (ACCESSIBLE_CHILD_PROPERTY, a, null);
        }
        for(javafx.scene.Node a : nodes) {
            boolean found = false;
            for(Accessible n : old) {
                if(n == a) found = true;
            }
            if(found == false) {
                if(a instanceof Accessible) {
                    ((NodeAccessibleContext)(((Accessible)a).getAccessibleContext())).setParent(component);
                    firePropertyChange
                    (ACCESSIBLE_CHILD_PROPERTY, null, a);
               }
            }
        }
    }

    public NodeAccessibleContext (Accessible component, AccessibleRole role, String name) {
        this.role = role;
        this.name = name;
        this.component = component;
    }

    @Override
    public boolean contains(Point p) {
        Rectangle bounds = getBounds();
        return bounds.contains(p);
    }

    @Override
    public Point getLocationOnScreen() {
        if(component instanceof Scene) {
            Stage stage = ((Scene)component).get$stage();
            return new Point((int)stage.get$x(), (int)stage.get$y());
        }
        javafx.geometry.Point2D p = ((Node)component).localToScene(((Node)component).get$boundsInLocal().$minX, ((Node)component).get$boundsInLocal().$minY);
        /*AccessibleComponent ac = getAccessibleParent().getAccessibleContext().getAccessibleComponent();
        Point parentl = ac.getLocationOnScreen();
        Point that = getLocation();*/
        Point ret = new Point((int)(p.get$x() + ((Node)component).get$scene().get$stage().get$x()), (int)(p.get$y() + ((Node)component).get$scene().get$stage().get$y()));
        return ret;
    }

    @Override
    public Point getLocation() {
        Point location;
        if(component instanceof Node) {
            location = new Point((int)((Node)component).get$boundsInParent().get$minX(),(int)((Node)component).get$boundsInParent().get$minY());
        } else if(component instanceof Scene) {
            location = new Point((int)((Scene)component).get$x(),(int)((Scene)component).get$y());
        } else {
            location = new Point(0,0);
            System.out.println("Fatal, wrong caller");
        }
        return location;
    }

    @Override
    public void setLocation(Point p) {
        // do nothing
    }

    @Override
    public Rectangle getBounds() {
        Rectangle bounds = new Rectangle(getLocation(), getSize());
        return bounds;
    }

    @Override
    public void setBounds(Rectangle r) {
        // do nothing
    }
    
    @Override
    public Dimension getSize() {
        Dimension dim;
        if(component instanceof Node) {
            dim = new Dimension((int)((Node)component).get$boundsInParent().get$width(),(int)((Node)component).get$boundsInParent().get$height());
        } else if(component instanceof Scene) {
            dim = new Dimension((int)((Scene)component).get$width(),(int)((Scene)component).get$height());
        } else {
            dim = new Dimension(0,0);
            System.out.println("Fatal, wrong caller");
        }
        return dim;
    }

    @Override
    public void setSize(Dimension d) {
        // do nothing
    }
    
    @Override
    public String getAccessibleName() {
        return name;
    }

    @Override
    public Accessible getAccessibleAt(Point p) {
        synchronized(lock) {
            for(int i = children.length-1; i >= 0; i--) {
                Accessible child = children[i];
                AccessibleContext ac = child.getAccessibleContext();
                if(ac != null) {
                    AccessibleComponent acc = ac.getAccessibleComponent();
                    if(acc != null && acc.contains(p)) {
                        return child;
                    }
                }
            }
        }
        return component;
    }

    @Override
    public boolean isFocusTraversable() {
        return ((javafx.scene.Node)component).get$focusTraversable();
    }

    @Override
    public void requestFocus() {
        //if(component instanceof javafx.scene.Node)
        //    ((javafx.scene.Node)component).requestFocus();
    }

    @Override
    public void addFocusListener(FocusListener listener) {
    }

    @Override
    public void removeFocusListener(FocusListener listener) {
        // TODO
        }
    
    @Override
    public AccessibleComponent getAccessibleComponent() {
        return this;
    }

    @Override
    public AccessibleRole getAccessibleRole() {
        return role;
    }

    @Override
    public AccessibleStateSet getAccessibleStateSet() {
        AccessibleStateSet ss = new AccessibleStateSet();
        ss.add(AccessibleState.VISIBLE);
        ss.add(AccessibleState.ENABLED);
        ss.add(AccessibleState.SHOWING);
        return ss;
    }

    @Override
    public Locale getLocale() {
        return Locale.getDefault();
    }

    @Override
    public Accessible getAccessibleChild(int index) {
        synchronized(lock) {
            if(index >= children.length) return null;
            //if(children[index].getAccessibleContext() instanceof NodeAccessibleContext)
            //    ((NodeAccessibleContext)children[index].getAccessibleContext()).setParent(component);
            return children[index];
        }
    }

    @Override
    public int getAccessibleChildrenCount() {
        if(children == null) return 0;
        return children.length;
    }

    @Override
    public int getAccessibleIndexInParent() {
        Accessible parent = getAccessibleParent();
        if(parent == null) return 0;
        AccessibleContext ac = parent.getAccessibleContext();
        for(int i = 0; i < ac.getAccessibleChildrenCount(); i++) {
            if(ac.getAccessibleChild(i) == component) return i;
        }
        return -1;
    }

    @Override
    public Accessible getAccessibleParent() {
        return parent;
    }

    @Override
    public Color getBackground() {
        return Color.WHITE;
    }

    @Override
    public void setBackground(Color c) {
    }

    @Override
    public Color getForeground() {
        return Color.BLACK;
    }

    @Override
    public void setForeground(Color c) {
    }

    @Override
    public Cursor getCursor() {
        return null;
    }

    @Override
    public void setCursor(Cursor cursor) {
    }

    @Override
    public Font getFont() {
        return null;
    }

    @Override
    public void setFont(Font f) {
    }

    @Override
    public FontMetrics getFontMetrics(Font f) {
        return null;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public void setEnabled(boolean b) {
    }

    @Override
    public boolean isVisible() {
        return true;
    }

    @Override
    public void setVisible(boolean b) {
    }

    @Override
    public boolean isShowing() {
        return true;
    }

    public void setAction(Function0<Void> action) {
        this.action = action;
    }

    @Override
    public AccessibleAction getAccessibleAction() {
        if(action != null) return this;
        return null;
    }

    @Override
    public int getAccessibleActionCount() {
        return 1;
    }

    @Override
    public String getAccessibleActionDescription(int i) {
        return "Click "+name;
    }

    @Override
    public boolean doAccessibleAction(int i) {
        action.invoke();
        return true;
    }
}
