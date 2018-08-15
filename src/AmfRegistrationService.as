package {
import com.pandaland.mvc.model.vo.RegisterVO;

public interface AmfRegistrationService {

    function registerUser(_arg_1:Function, _arg_2:Function, _arg_3:RegisterVO):void;

    function checkEmailAddress(_arg_1:Function, _arg_2:Function, _arg_3:String):void;

    function checkUserName(_arg_1:Function, _arg_2:Function, _arg_3:String):void;

    function loadUsernameSuggestions(_arg_1:Function, _arg_2:Function, _arg_3:String, _arg_4:String, _arg_5:int):void;

}
}

