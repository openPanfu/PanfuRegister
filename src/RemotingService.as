package {
import com.pandaland.mvc.model.vo.RegisterVO;

import flash.net.NetConnection;
import flash.net.Responder;

public class RemotingService extends NetConnection implements AmfRegistrationService {

    private static var in_count:int = 0;
    private static var out_count:int = 0;
    private static var sInst:RemotingService;

    //private var pServerURL:String = "http://debby2.panfu.de:8090/informationserver-dev/gateway/amf";
    private var pServerURL:String = "http://localhost:7070/";
    private var AppendToGatewayUrl:Object;
    private var pConnected:Boolean;

    public function RemotingService(_arg_1:String = "", _arg_2:uint = 0) {
        this.pConnected = false;
        objectEncoding = _arg_2;
    }

    public static function get inst():RemotingService {
        if (sInst == null) {
            sInst = new (RemotingService)();
        }
        return (sInst);
    }

    public static function get inCount():int {
        return (RemotingService.in_count);
    }

    public static function get outCount():int {
        return (RemotingService.out_count);
    }


    public function set serverURL(tServerURL:String):void {
        if (((tServerURL) && (!((tServerURL == ""))))) {
            this.pServerURL = tServerURL;
        }
    }

    public function registerUser(tHandler:Function, tError:Function, tVO:RegisterVO):void {
        this.callService("amfRegistrationService.register", tHandler, tError, tVO);
    }

    public function checkEmailAddress(tHandler:Function, tError:Function, tEmail:String):void {
        this.callService("amfRegistrationService.checkEmailAddress", tHandler, tError, tEmail);
    }

    public function checkUserName(tHandler:Function, tError:Function, tName:String):void {
        this.callService("amfRegistrationService.checkUserName", tHandler, tError, tName);
    }

    public function loadUsernameSuggestions(tHandler:Function, tError:Function, tName:String, tGender:String, tUnknown:int):void {
        this.callService("amfRegistrationService.loadUsernameSuggestions", tHandler, tError, tName, tGender, tUnknown);
    }

    public function setEmailAddress(tHandler:Function, tError:Function, tUserId:int, tEmail:String):void {
        this.callService("amfConnectionService.setEmailAddress", tHandler, tError, tUserId, tEmail, true);
    }

    private function callService(tCom:String, tHandler:Function, tError:Function, ...tArgs):void {
        if (!this.pConnected) {
            try {
                connect(this.pServerURL);
                this.pConnected = true;
            } catch (e:Error) {
                PanfuRegister.log("Problem connecting to the Information Server", "error", "console");
            }
        }
        RemotingService.out_count++;
        var tResp:Responder = new Responder(tHandler, ((tError) || (this.onFault)));
        call.apply(this, [tCom, tResp].concat(tArgs));
    }

    public function callRemote(tCall:RemoteCall):void {
        if (!this.pConnected) {
            try {
                connect(this.pServerURL);
                this.pConnected = true;
            } catch (e:Error) {
            }
        }
        tCall.error = ((tCall.error) || (this.onFault));
        call.apply(this, tCall.data);
    }

    public function onFault(_arg_1:Object):void {
        var _local_2:String = (((((("onFault calling remote method. " + "code: ") + _arg_1.code) + "description: ") + _arg_1.description) + "details: ") + _arg_1.details);
        PanfuRegister.log(_local_2, _arg_1);
    }

    public function log(_arg_1:String = "", _arg_2:Object = null):void {
        RemotingService.in_count++;
        var _local_3:String = (((_arg_2) == null) ? "" : _arg_2.toString());
    }


}
}

