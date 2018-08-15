package com.pandaland.popup {
import flash.display.MovieClip;

public interface IPopup {

    function get content():MovieClip;

    function close():void;

}
}

