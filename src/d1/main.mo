import Float "mo:base/Float";
import Text   "mo:base/Text";

actor Counter {
    var counter : Float = 0;

    public func add(x : Float) : async Float {
        counter += x;
        counter;
    };

    public func sub(x : Float) : async Float {
        counter -= x;
        counter;
    };

    public func mul(x : Float) : async Float {
        counter *= x;
        counter;
    };
    
    public func div(x : Float) : async Float {
        if(x != 0) {
            counter /= x;
            return (counter);    
        } else {
            return (0);
        }
    };

    public func reset() : async Float {
        counter := 0;
        counter;
    };

    public query func see() : async Float {
        counter;
    };

    public func power(x : Float) : async Float {
        counter **= x;
        counter;
    };

    public func sqrt() : async Float {
        counter := Float.sqrt(counter);
        counter;
    };

    public func floor() : async Float {
        counter := Float.floor(counter);
        counter;
    };
   
};

//try using assert for checking or capturing 0 dividends