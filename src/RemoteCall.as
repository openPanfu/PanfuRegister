package {
import flash.net.Responder;

public class RemoteCall {

    private var pCom:String;
    private var pSuccess:Function;
    private var pError:Function;
    private var pArgs:Array;

    public function RemoteCall(_arg_1:String = "", _arg_2:Function = null, _arg_3:Function = null, ..._args) {
        this.pCom = _arg_1;
        this.pSuccess = _arg_2;
        this.pError = _arg_3;
        this.pArgs = _args;
    }

    public function get com():String {
        return (this.pCom);
    }

    public function get success():Function {
        return (this.pSuccess);
    }

    public function get error():Function {
        return (this.pError);
    }

    public function get args():Array {
        return (this.pArgs);
    }

    public function set com(_arg_1:String):void {
        this.pCom = _arg_1;
    }

    public function set success(_arg_1:Function):void {
        this.pSuccess = _arg_1;
    }

    public function set error(_arg_1:Function):void {
        this.pError = _arg_1;
    }

    public function set args(_arg_1:Array):void {
        this.pArgs = _arg_1;
    }

    public function get data():Array {
        var _local_1:Responder = new Responder(this.pSuccess, this.pError);
        return ([this.pCom, _local_1].concat(this.pArgs));
    }

    public function toString():String {
        return (((("RemoteCall: " + this.com) + " ") + this.args));
    }


}
}

