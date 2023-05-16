import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Iter "mo:base/Iter";

actor theVerifier {

    //-->2vxsx-fae caller
    //-->rkud7-dquma-3foxi-heben-4qhfe-qcsl5-bco2f-6qtea-cgqpe-xxv4b-zae
    //PART-1: Storing the students information (CRUD)
    //

    var now = Time.now();           //for the upgrade hooks
    Debug.print("BEGIN_INIT Time: " # Int.toText(now));

    public type StudentProfile = {
        name : Text;
        team : Text;
        graduate : Bool;
    };

    //1. Define the variables
    type Hash = Hash.Hash;
    func  _hashNat (n : Nat) : Hash {
      Text.hash(Nat.toText(n));
    };
    
    var stdEntries : [(Principal, StudentProfile)] = [];
    let studentProfileStore = HashMap.HashMap<Principal, StudentProfile>(1, Principal.equal, Principal.hash);
      

    //2. Implement addMyProfile funciton
    public shared({caller}) func addMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        
        studentProfileStore.put(caller, profile);
        
        #ok;
    };

    //3. Implement seeAProfile
    public shared query func seeAProfile(p : Principal) : async Result.Result<StudentProfile, Text> {
        let profile = studentProfileStore.get(p);
        switch(profile) {
            case(null) {#err("Not matching Profile with given principal");};
            case(?profile) {let result = studentProfileStore.get(p); #ok(profile)}
        } 
    };

    //4. Implement updateMyProfile
    //If caller does not have a profile, return error
    public shared ({caller}) func updateMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        
       
        let profile = studentProfileStore.get(caller);
      switch(profile) {
        case(null){#err("No profile available");};
        case(?profile){let res = studentProfileStore.put(caller, profile); 
                        
                                #ok(); };
        };
      
    };

    //to be removed
    public shared ({caller}) func callerPrincipal() : async Principal {
        caller;
    };

    //5. Implement deleteMyProfile
    public shared ({caller}) func deleteMyProfile() : async Result.Result<(), Text> {
        let profile = studentProfileStore.get(caller);
      switch(profile) {
        case(null){#err("No profile available");};
        case(?profile){let res = studentProfileStore.remove(caller); 
                        
                                #ok(); };
        };
    };

    //6. Implement "preupgrade" and "postupgrade" hooks to make "studentProfileStore" resistant to upgrades
    system func preupgrade () {
        now := Time.now();

        Debug.print("PREUPGARDE Time: " #Int.toText(now));
        stdEntries := Iter.toArray(studentProfileStore.entries());
    };

    system func postupgrade () {
        now := Time.now();

        Debug.print("POSTUPGARDE Time: " #Int.toText(now));
        for((caller, profile) in stdEntries.vals()) {
            studentProfileStore.put(caller, profile);
        }
    };


    //
    //PART-2: Testing on simple calculator
    //
    public type TestResult = Result.Result<(), TestError>;
    public type TestError = {
        #UnexpectedValue : Text;
        #UnexpectedError : Text;
    };

    //1. Implement test function --> review test results lecture
    public shared func test(canisterId : Principal) : async TestResult {
        let studentsCanister = actor(Principal.toText(canisterId)) : actor {
            add : shared(x : Float) -> async Float;
            sub : shared(x : Float) -> async Float;
            reset: shared() -> async Float;
    };

    try {
        let addCheck = await studentsCanister.add(5);
        if(addCheck != 5) {
            return #err(#UnexpectedValue("The add function did not return the expected result."));
            
        };

        let subCheck = await studentsCanister.sub(3);
        if(subCheck != 2) {
            return #err(#UnexpectedValue("The sub function did not return the expected result."));
        };

        let resetCheck = await studentsCanister.reset();
        if(resetCheck != 0) {
            return #err(#UnexpectedValue("The reset function did not return the expected result."));
        };

        return #ok();
    } catch (e) {
        return  #err(#UnexpectedError("Error. You missed to perform validation"));
    };
    };

    
    //
    //PART-3: Verifying the controller of the calculator
    //
    
    //1. Implement verifyOwnership
    public shared func verifyOwnership(canisterId : Principal, principalId : Principal) : async Bool {
        return true;
    };

    //
    //PART-4: Graduation, let students submit their workd an automatically verify the canister
    //

    //1. Implement verifyWork
    public shared func verifyWork(canisterId : Principal, principalId : Principal) : async Result.Result<(), Text> {
        return #ok;
    };



}   