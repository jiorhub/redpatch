module message;

enum MessageType : string {
    Success = "success",
    Error = "error",
    Denied = "denied"
}


class Message(T) {
    string token;
    string hash;
    MessageType type;
}


class ErrorMessage : Message!string {
    string text;

    this(string text) {
        this.text = text;
    }
}

class MessageFactory {

}

//struct ErrorMessage(T) {
//    Message!T _parent;
//    alias _parent this;

//    this(string message) {
//        _parent = Message!T(MessageType.Error, message);
//    }
//}


//struct DeniedMessage(T) {
//    ErrorMessage!T _parent;
//    alias _parent this;

//    this(string message) {
//        _parent = ErrorMessage!T(message);
//        _parent.errorType = ErrorType.Denied;
//    }
//}




