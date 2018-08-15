package com.pandaland.popup {
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

public class HorizontalScrollButtonsDecorator extends PopupDecorator {

    private var up:MovieClip;
    private var down:MovieClip;
    private var bar:MovieClip;
    private var tfToScroll:TextField;

    public function HorizontalScrollButtonsDecorator(_arg_1:IPopup) {
        super(_arg_1);
        this.up = (_arg_1.content["up"] as MovieClip);
        this.down = (_arg_1.content["down"] as MovieClip);
        this.bar = (_arg_1.content["bar"] as MovieClip);
        this.tfToScroll = (_arg_1.content["txtDesc"] as TextField);
        this.up.buttonMode = true;
        this.up.mouseChildren = false;
        this.down.buttonMode = true;
        this.down.mouseChildren = false;
        this.bar.buttonMode = true;
        this.bar.mouseChildren = false;
        this.tfToScroll.selectable = false;
        if (!this.up.hasEventListener(MouseEvent.MOUSE_DOWN)) {
            this.up.addEventListener(MouseEvent.MOUSE_DOWN, this.onUpClicked, false, 0, true);
        }
        if (!this.down.hasEventListener(MouseEvent.MOUSE_DOWN)) {
            this.down.addEventListener(MouseEvent.MOUSE_DOWN, this.onDownClicked, false, 0, true);
        }
        if (!this.bar.hasEventListener(MouseEvent.MOUSE_DOWN)) {
            this.bar.addEventListener(MouseEvent.MOUSE_DOWN, this.onStartDrag, false, 0, true);
        }
        if (!this.bar.hasEventListener(MouseEvent.MOUSE_UP)) {
            this.bar.addEventListener(MouseEvent.MOUSE_UP, this.onStopDrag, false, 0, true);
        }
    }

    private function onStartDrag(_arg_1:MouseEvent):void {
        this.bar.startDrag(false, new Rectangle(250, -60, 0, 90));
        this.bar.addEventListener(MouseEvent.MOUSE_MOVE, this.updateTextScroll);
    }

    private function onStopDrag(_arg_1:MouseEvent):void {
        this.bar.stopDrag();
        this.bar.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateTextScroll);
    }

    private function updateTextScroll(_arg_1:MouseEvent):void {
        var _local_2:Number = ((30 - this.bar.y) / 90);
        var _local_3:int = (1 + int(((1 - _local_2) * this.tfToScroll.maxScrollV)));
        this.tfToScroll.scrollV = _local_3;
    }

    private function onUpClicked(_arg_1:MouseEvent):void {
        if (this.tfToScroll.scrollV > 0) {
            this.tfToScroll.scrollV--;
        }
    }

    private function onDownClicked(_arg_1:MouseEvent):void {
        this.tfToScroll.scrollV++;
    }


}
}

