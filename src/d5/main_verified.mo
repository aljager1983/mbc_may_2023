// import HashMap "mo:base/HashMap";
// import Principal "mo:base/Principal";
// import Hash "mo:base/Hash";
// import Error "mo:base/Error";
// import Result "mo:base/Result";
// import Array "mo:base/Array";
// import Text "mo:base/Text";
// import Nat "mo:base/Nat";
// import Int "mo:base/Int";
// import Timer "mo:base/Timer";
// import Debug "mo:base/Debug";
// import Buffer "mo:base/Buffer";
// import Time "mo:base/Time";
// import Iter "mo:base/Iter";

// import IC "Ic";
// import HTTP "Http";
// import Type "Types";

// actor class theVerifier() {
//   public type StudentProfile = {
//     name : Text;
//     Team : Text;
//     graduate : Bool;
//   };

//   var now = Time.now();           //for the upgrade hooks
//     Debug.print("BEGIN_INIT Time: " # Int.toText(now));

    
//     //1. Define the variables
//     type Hash = Hash.Hash;
//     func  _hashNat (n : Nat) : Hash {
//       Text.hash(Nat.toText(n));
//     };
    
//     stable var stdEntries : [(Principal, StudentProfile)] = [];
//     let studentProfileStore = HashMap.HashMap<Principal, StudentProfile>(1, Principal.equal, Principal.hash);
      

//     //2. Implement addMyProfile funciton
//     public shared({caller}) func addMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        
//         studentProfileStore.put(caller, profile);
        
//         #ok;
//     };

//     //3. Implement seeAProfile
//     public shared query func seeAProfile(p : Principal) : async Result.Result<StudentProfile, Text> {
//         let profile = studentProfileStore.get(p);
//         switch(profile) {
//             case(null) {#err("Not matching Profile with given principal");};
//             case(?profile) {let result = studentProfileStore.get(p); #ok(profile)}
//         } 
//     };

//     //4. Implement updateMyProfile
//     //If caller does not have a profile, return error
//     public shared ({caller}) func updateMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
        
       
//         let profile = studentProfileStore.get(caller);
//       switch(profile) {
//         case(null){#err("No profile available");};
//         case(?profile){let res = studentProfileStore.put(caller, profile); 
                        
//                                 #ok(); };
//         };
      
//     };

//     //to be removed
//     public shared ({caller}) func callerPrincipal() : async Principal {
//         caller;
//     };

//     //5. Implement deleteMyProfile
//     public shared ({caller}) func deleteMyProfile() : async Result.Result<(), Text> {
//         let profile = studentProfileStore.get(caller);
//       switch(profile) {
//         case(null){#err("No profile available");};
//         case(?profile){let res = studentProfileStore.remove(caller); 
                        
//                                 #ok(); };
//         };
//     };

//     //6. Implement "preupgrade" and "postupgrade" hooks to make "studentProfileStore" resistant to upgrades
//     system func preupgrade () {
//         now := Time.now();

//         Debug.print("PREUPGARDE Time: " #Int.toText(now));
//         stdEntries := Iter.toArray(studentProfileStore.entries());
//     };

//     system func postupgrade () {
//         now := Time.now();

//         Debug.print("POSTUPGARDE Time: " #Int.toText(now));
//         for((caller, profile) in stdEntries.vals()) {
//             studentProfileStore.put(caller, profile);
//         }
//     };


//     //
//     //PART-2: Testing on simple calculator
//     //
//     public type TestResult = Result.Result<(), TestError>;
//     public type TestError = {
//         #UnexpectedValue : Text;
//         #UnexpectedError : Text;
//     };

//     //1. Implement test function --> review test results lecture
//     public shared func test(canisterId : Principal) : async TestResult {
//         let studentsCanister = actor(Principal.toText(canisterId)) : actor {
//             add : shared(x : Int) -> async Int;
//             sub : shared(x : Int) -> async Int;
//             reset: shared() -> async Int;
//     };

//     try {
//         let addCheck = await studentsCanister.add(5);
//         if(addCheck != 5) {
//             return #err(#UnexpectedValue("The add function did not return the expected result."));
            
//         };

//         let subCheck = await studentsCanister.sub(3);
//         if(subCheck != 2) {
//             return #err(#UnexpectedValue("The sub function did not return the expected result."));
//         };

//         let resetCheck = await studentsCanister.reset();
//         if(resetCheck != 0) {
//             return #err(#UnexpectedValue("The reset function did not return the expected result."));
//         };

//         return #ok();
//     } catch (e) {
//         return  #err(#UnexpectedError("Error. You missed to perform validation"));
//     };
//     };

//   // STEP 3 - BEGIN
//   // NOTE: Not possible to develop locally,
//   // as actor "aaaa-aa" (aka the IC itself, exposed as an interface) does not exist locally
//   public func verifyOwnership(canisterId : Principal, p : Principal) : async Result.Result<Bool, Text> {

//     let ManagementCanister : IC.ManagementCanister = actor("aaaa-aa") : actor {
//           canister_status() : async Principal;

      
//       try {
//         let status = await ManagementCanister.canister_status(canisterId);

//       } catch(e){
//         let lines = Iter.toArray(Text.split(error, #text("\n")));
//         let words = Iter.toArray(Text.split(line[1], #text("")));
//         var i = 2;
//         let controllers = Buffer.Buffer<Principal>(0);
//         while (i < words.size()) {
//           controllers.add(Principal.fromText(words[i]));
//           i += 1;
//         }
//       }
    
//     }
//   };
//   // STEP 3 - END

//   // STEP 4 - BEGIN
//   public shared ({ caller }) func verifyWork(canisterId : Principal, p : Principal) : async Result.Result<Bool, Text> {
//     return #err("not implemented");
//   };
//   // STEP 4 - END

//   // STEP 5 - BEGIN
//   public type HttpRequest = HTTP.HttpRequest;
//   public type HttpResponse = HTTP.HttpResponse;

//   // NOTE: Not possible to develop locally,
//   // as Timer is not running on a local replica
//   public func activateGraduation() : async () {
//     return ();
//   };

//   public func deactivateGraduation() : async () {
//     return ();
//   };

//   public query func http_request(request : HttpRequest) : async HttpResponse {
//     return ({
//       status_code = 200;
//       headers = [];
//       body = Text.encodeUtf8("");
//       streaming_strategy = null;
//     });
//   };
//   // STEP 5 - END
// };
//////////////////////////////////////////////////
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Error "mo:base/Error";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Timer "mo:base/Timer";
import Buffer "mo:base/Buffer";

import Type "Types";
import Ic "Ic";

actor class Verifier() {
  type StudentProfile = Type.StudentProfile;

  let studentProfileStore = HashMap.HashMap<Principal, StudentProfile>(0, Principal.equal, Principal.hash);

  private func isRegistered(p : Principal) : Bool {
    var xProfile : ?StudentProfile = studentProfileStore.get(p);

    switch (xProfile) {
      case null { 
        return false;
      };

      case (?profile) {
        return true
      };
    }
  };

  // STEP 1 - BEGIN

  public shared ({ caller }) func addMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
    if (Principal.isAnonymous(caller)) {
      return #err "You must be Logged In"
    };

    if (isRegistered(caller)) {
      return #err ("You are already registered (" # Principal.toText(caller) # ") ")
    };

    studentProfileStore.put(caller, profile);
    return #ok ();
  };

  public shared query ({ caller }) func seeAProfile(p : Principal) : async Result.Result<StudentProfile, Text> {
    var xProfile : ?StudentProfile = studentProfileStore.get(p);

    switch (xProfile) {
      case null { 
        return #err ("There is no profile registered with the received account");
      };

      case (?profile) {
        return #ok profile
      };
    }
  };

  public shared ({ caller }) func updateMyProfile(profile : StudentProfile) : async Result.Result<(), Text> {
    if (Principal.isAnonymous(caller)) {
      return #err "You must be Logged In"
    };
    
    if (not isRegistered(caller)) {
      return #err ("You are not registered");
    };

    ignore studentProfileStore.replace(caller, profile);

    return #ok ();
  };

  public shared ({ caller }) func deleteMyProfile() : async Result.Result<(), Text> {
    if (Principal.isAnonymous(caller)) {
      return #err "You must be Logged In"
    };
    
    if (not isRegistered(caller)) {
      return #err ("You are not registered");
    };

    studentProfileStore.delete(caller);

    return #ok ();
  };

  // STEP 2 - BEGIN
  public type TestResult = Type.TestResult;
  public type TestError = Type.TestError;

  public func test(canisterId : Principal) : async TestResult {
    let calculatorInterface = actor(Principal.toText(canisterId)) : actor {
      reset : shared () -> async Int;
      add : shared (x : Nat) -> async Int;
      sub : shared (x : Nat) -> async Int;
    };

    try {
      let x1 : Int = await calculatorInterface.reset();
      if (x1 != 0) {
        return #err(#UnexpectedValue("After a reset, counter should be 0!"));
      };

      let x2 : Int = await calculatorInterface.add(2);
      if (x2 != 2) {
        return #err(#UnexpectedValue("After 0 + 2, counter should be 2!"));
      };

      let x3 : Int = await calculatorInterface.sub(2);
      if (x3 != 0) {
        return #err(#UnexpectedValue("After 2 - 2, counter should be 0!"));
      };

      return #ok ();
    } catch (e) {
      return #err(#UnexpectedError("Something went wrong!"));
    } 
  };


  // STEP 3 - BEGIN
  public func verifyOwnership(canisterId : Principal, p : Principal) : async Bool {
    try {
      let controllers = await Ic.getCanisterControllers(canisterId);

      var isOwner : ?Principal = Array.find<Principal>(controllers, func prin = prin == p);
      
      if (isOwner != null) {
        return true;
      };

      return false;
    } catch (e) {
      return false;
    }
  };

  // STEP 4 - BEGIN
  public shared ({ caller }) func verifyWork(canisterId : Principal, p : Principal) : async Result.Result<(), Text> {
    try {
      let isApproved = await test(canisterId); 

      if (isApproved != #ok) {
        return #err("The current work has no passed the tests");
      };

      let isOwner = await verifyOwnership(canisterId, p); 

      if (not isOwner) {
        return #err ("The received work owner does not match with the received principal");
      };

      var xProfile : ?StudentProfile = studentProfileStore.get(p);

      switch (xProfile) {
        case null { 
          return #err("The received principal does not belongs to a registered student");
        };

        case (?profile) {
          var updatedStudent = {
            name = profile.name;
            graduate = true;
            team = profile.team;
          };

          ignore studentProfileStore.replace(p, updatedStudent);
          return #ok ();      
        }
      };
    } catch(e) {
      return #err("Cannot verify the project");
    }
  };
};