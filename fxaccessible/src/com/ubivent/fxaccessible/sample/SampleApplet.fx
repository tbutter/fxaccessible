/*
 * SampleApplet.fx
 *
 * Created on Jan 15, 2010, 2:44:20 PM
 */

package com.ubivent.fxaccessible.sample;

import javafx.stage.Stage;
import com.ubivent.fxaccessible.Scene;
import com.ubivent.fxaccessible.Text;

/**
 * @author thomasbutter
 */

public class SampleApplet {

}

function run() {
Stage {
    width: 100
    height: 100
    scene: Scene {
        content: Text {
            x: 20
            y: 20
            content: "Blah"
        }
    }
}
}